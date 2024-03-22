import 'dart:convert';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/all_populer_restaurant_filter_button.dart';
import 'package:efood_multivendor/view/screens/scan/models/reservation_config_model.dart';
import 'package:efood_multivendor/view/screens/scan/models/time_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class ReserveScreen extends StatefulWidget {
  static void navigate(BuildContext context,
          {required int restaurantId,
          required String restaurantName,
          required bool isCartEmpty}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReserveScreen(
            restaurantId: restaurantId,
            restaurantName: restaurantName,
            isCartEmpty: isCartEmpty,
          ),
        ),
      );
  final int restaurantId;
  final String restaurantName;
  final bool isCartEmpty;
  const ReserveScreen({
    Key? key,
    required this.restaurantId,
    required this.restaurantName,
    required this.isCartEmpty,
  }) : super(key: key);

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  final _countController = TextEditingController();
  final _countFocus = FocusNode();
  bool checkedLogin = false;
  DataItemModel? smoking;

  bool configLoading = true;
  bool timesLoading = false;
  bool configError = false;
  bool timesError = false;
  String configErrorMessage = "";
  String timesErrorMessage = "";

  ReservationModel? config;
  ReservationTimesModel? times;

  DayModel? selectedDay;
  String? selectedTime;

  bool btnLoading = false;
  bool agreeToTerms = true;

  @override
  void initState() {
    super.initState();

    _getConfig();
  }

  _getTimes(DayModel day) async {
    try {
      setState(() {
        timesLoading = true;
      });
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(AppConstants.token);
      final res = await http.post(
        Uri.parse(
            "${AppConstants.baseUrl}/api/v1/customer/table_reservation/get_time"),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          "restaurant_id": widget.restaurantId.toString(),
          "day": day.value,
        },
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        times = ReservationTimesModel.fromJson(body);
      } else {
        timesError = true;
        timesErrorMessage = body["message"];
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
      timesError = true;
      timesErrorMessage =
          "Something went wrong while getting the times. Tap to refresh";
    }
    setState(() {
      timesLoading = false;
    });
  }

  _getConfig() async {
    try {
      setState(() {
        configLoading = true;
      });
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(AppConstants.token);
      final res = await http.post(
        Uri.parse(
            "${AppConstants.baseUrl}/api/v1/customer/table_reservation/get_config"),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          "restaurant_id": widget.restaurantId.toString(),
        },
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        config = ReservationModel.fromJson(body);
        if (config!.data.config.required_order && widget.isCartEmpty) {
          if (mounted) OrderRequiredDialog.show(context);
        } else {
          // Get.find<RestaurantController>().updateBackFromReservation(false);
        }
      } else {
        configError = true;
        configErrorMessage = body["message"];
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
      configError = true;
      configErrorMessage =
          "Something went wrong while getting the config. Tap to refresh.";
    }
    setState(() {
      configLoading = false;
    });
  }

  _onReserveButtonClicked(CartController cartController) {
    setState(() {
      btnLoading = true;
    });
    final carts = getCarts(cartController);
    final total = getTotal(carts);
    if (config!.data.config.minim_order_pay_status) {
      final minOrder = double.parse(config!.data.config.minim_order_pay);
      if (total < minOrder) {
        OrderRequiredDialog.show(
          context,
          message:
              "${"minimum_order_amount_is".tr} \$${minOrder.toStringAsFixed(2)}",
        );
        return;
      }
    }
    _callApi(carts);
    setState(() {
      btnLoading = false;
    });
  }

  _callApi(List<OnlineCart> carts) async {
    if (_countController.text.isEmpty) {
      showCustomSnackBar("Enter number of guest");
      return;
    }
    setState(() {
      isLoading = true;
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(AppConstants.token);

    final body = {
      "guest": _countController.text,
      "restaurant_id": widget.restaurantId.toString(),
      "smoking": smoking?.id,
      "day": selectedDay?.value ?? "",
      "time": selectedTime,
      "carts": carts.map((e) => e.toJson()).toList(),
      "is_web": GetPlatform.isWeb ? 1 : 0,
    };
    final res = await http.post(
      Uri.parse(
          "${AppConstants.baseUrl}/api/v1/customer/table_reservation/reservation"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && (data["success"] as bool? ?? false)) {
      final redirctUrl = data['data'] as String?;
      // setState(() {
      //   isDone = true;
      // });

      if (redirctUrl?.isEmpty ?? true) {
        showCustomSnackBar(data['message']);
        if (mounted) Navigator.pop(context);
      } else {
        if (GetPlatform.isWeb) {
          // Get.back();
          // await Get.find<AuthController>().saveGuestNumber(contactNumber ?? '');
          // String? hostname = html.window.location.hostname;
          // String protocol = html.window.location.protocol;
          // '/payment-mobile?customer_id=${widget.orderModel.userId == 0 ? widget.guestId : widget.orderModel.userId}&order_id=${widget.orderModel.id}&payment_method=${widget.paymentMethod}';
          // String selectedUrl =
          //     '${AppConstants.baseUrl}/payment-mobile?order_id=$orderID&customer_id=${Get.find<UserController>().userInfoModel?.id ?? Get.find<AuthController>().getGuestId()}'
          //     '&payment_method=${Get.find<OrderController>().digitalPaymentName}&payment_platform=web&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&amount=$amount&status=';
          html.window.open(redirctUrl!, "_self");
        } else {
          Get.offAndToNamed(RouteHelper.getPaymentRoute(
            OrderModel(),
            "Payment",
            subscriptionUrl: redirctUrl,
            guestId: Get.find<AuthController>().getGuestId(),
          ));
        }
      }
    } else {
      showCustomSnackBar(data['message'] ?? "Something went wrong!");
    }
    setState(() {
      isLoading = false;
    });
  }

  List<OnlineCart> getCarts(CartController cartController) {
    final cartList = cartController.cartList;
    List<OnlineCart> carts = [];
    for (int index = 0; index < cartList.length; index++) {
      CartModel cart = cartList[index];
      List<int?> addOnIdList = [];
      List<int?> addOnQtyList = [];
      List<OrderVariation> variations = [];
      for (var addOn in cart.addOnIds!) {
        addOnIdList.add(addOn.id);
        addOnQtyList.add(addOn.quantity);
      }
      if (cart.product!.variations != null) {
        for (int i = 0; i < cart.product!.variations!.length; i++) {
          if (cart.variations![i].contains(true)) {
            variations.add(OrderVariation(
                name: cart.product!.variations![i].name,
                values: OrderVariationValue(label: [])));
            for (int j = 0;
                j < cart.product!.variations![i].variationValues!.length;
                j++) {
              if (cart.variations![i][j]!) {
                variations[variations.length - 1].values!.label!.add(
                    cart.product!.variations![i].variationValues![j].level);
              }
            }
          }
        }
      }
      carts.add(
        OnlineCart(
          cart.id,
          cart.product!.id,
          cart.isCampaign! ? cart.product!.id : null,
          cart.discountedPrice.toString(),
          variations,
          cart.quantity,
          addOnIdList,
          cart.addOns,
          addOnQtyList,
          'Food',
        ),
      );
    }
    return carts;
  }

  double getTotal(List<OnlineCart> carts) {
    double total = 0;
    for (var cart in carts) {
      total += double.parse(cart.price ?? "0") * (cart.quantity ?? 1);
    }
    return total;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
      ),
      body: !isLoggedIn
          ? NotLoggedInScreen(
              callBack: (value) {
                _getConfig();
                setState(() {});
              },
            )
          : Center(
              child: (configLoading)
                  ? const CircularProgressIndicator()
                  : Container(
                      width: context.width > 700 ? 500 : context.width,
                      padding: context.width > 700
                          ? const EdgeInsets.all(50)
                          : const EdgeInsets.all(
                              Dimensions.paddingSizeExtraLarge),
                      margin: context.width > 700
                          ? const EdgeInsets.all(50)
                          : EdgeInsets.zero,
                      decoration: context.width > 700
                          ? BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              boxShadow: ResponsiveHelper.isDesktop(context)
                                  ? null
                                  : [
                                      BoxShadow(
                                          color: Colors.grey[
                                              Get.isDarkMode ? 700 : 300]!,
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ],
                            )
                          : null,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDaysSelection(),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildTimesSelection(),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildAreaSelection(config!.data.area_selection),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildNumberOfPeople(),
                          const Expanded(
                            child: SizedBox(
                              height: 20,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200]!,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: GetBuilder<CartController>(
                              builder: (cartController) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: true,
                                          onChanged: (value) {},
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              CancellationPolicyDialog.show(
                                                context,
                                                policy: config!.data
                                                        .CancellationPolicy ??
                                                    "",
                                              );
                                            },
                                            child: Text(
                                              "cancellation_terms".tr,
                                              style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    if (config?.data.config.reservation_fees !=
                                            null &&
                                        config!.data.config.fees_status)
                                      _buildButtonInfoRow(
                                        title: 'reservation_fees'.tr,
                                        value: config!
                                            .data.config.reservation_fees,
                                      ),
                                    if (config?.data.config.reservation_fees !=
                                            null &&
                                        config!.data.config.fees_status)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    if (config?.data.config.minim_order !=
                                            null &&
                                        config!.data.config.minim_order_status)
                                      _buildButtonInfoRow(
                                        title: 'minim_order'.tr,
                                        value: config!.data.config.minim_order,
                                      ),
                                    if (config?.data.config.minim_order !=
                                            null &&
                                        config!.data.config.minim_order_status)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    if (config?.data.config.minim_order_pay !=
                                            null &&
                                        config!
                                            .data.config.minim_order_pay_status)
                                      _buildButtonInfoRow(
                                        title:
                                            "${'you_should_pay'.tr} ${config?.data.config.minim_order_pay}% ${'of_order_total'.tr}",
                                        value: "",
                                      ),
                                    if (config?.data.config.minim_order_pay !=
                                            null &&
                                        config!
                                            .data.config.minim_order_pay_status)
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    CustomButton(
                                      isLoading: btnLoading,
                                      buttonText:
                                          "Reserve a table".toUpperCase(),
                                      onPressed: () async {
                                        return _onReserveButtonClicked(
                                            cartController);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }

  Row _buildButtonInfoRow({
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: robotoRegular,
        ),
        Text(
          value,
          style: robotoRegular,
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  Widget _buildTimesSelection() {
    if (timesLoading) {
      return const CircularProgressIndicator();
    }
    if (times == null) {
      return const SizedBox.shrink();
    }
    List<String> allTimes = [];
    for (var t in times!.data) {
      allTimes.addAll(t);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available timings".toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            itemCount: allTimes.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemBuilder: (context, index) {
              final time = allTimes[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedTime = time;
                  });
                },
                child: Container(
                  width: 100,
                  height: 70,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: selectedTime == time ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        color:
                            selectedTime == time ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _buildDaysSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date of reservation".toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            itemCount: config!.data.days.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemBuilder: (context, index) {
              final day = config!.data.days[index];
              return InkWell(
                onTap: () {
                  _getTimes(day);
                  setState(() {
                    selectedDay = day;
                  });
                },
                child: Container(
                  width: 150,
                  height: 70,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: selectedDay == day ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.day,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedDay == day ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        day.day_month,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              selectedDay == day ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _buildNumberOfPeople() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "No. of people".toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        CustomTextField(
          hintText: " ",
          controller: _countController,
          focusNode: _countFocus,
          inputType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          inputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Column _buildAreaSelection(List<DataItemModel> areas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Area Selection".toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        PopupMenuButton<DataItemModel>(
          itemBuilder: (context) {
            return areas
                .map(
                  (e) => PopupMenuItem(
                    value: e,
                    textStyle: robotoMedium.copyWith(
                      color: smoking?.id == e.id
                          ? Theme.of(context).textTheme.bodyLarge!.color
                          : Theme.of(context).disabledColor,
                    ),
                    child: Text(e.name),
                  ),
                )
                .toList();
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          child: AllPopularRestaurantsFilterButton(
            buttonText: smoking == null ? "Select Area" : smoking!.name,
          ),
          onSelected: (value) => setState(() {
            smoking = value;
          }),
        ),
      ],
    );
  }
}

class CancellationPolicyDialog extends StatelessWidget {
  static void show(
    BuildContext context, {
    required String policy,
  }) {
    showDialog(
      context: context,
      builder: (context) => CancellationPolicyDialog(
        plicy: policy,
      ),
    );
  }

  const CancellationPolicyDialog({
    super.key,
    required this.plicy,
  });
  final String plicy;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    plicy,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              buttonText: "Ok",
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class OrderRequiredDialog extends StatelessWidget {
  static void show(
    BuildContext context, {
    String? message,
    Function()? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => OrderRequiredDialog(
        message: message,
        onPressed: onPressed,
      ),
    );
  }

  final String? message;
  final Function()? onPressed;

  const OrderRequiredDialog({
    super.key,
    this.message,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? "add_item_to_cart_to_reserve".tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              buttonText: "Ok",
              onPressed: onPressed ??
                  () {
                    Get.find<RestaurantController>()
                        .updateBackFromReservation(true);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
            )
          ],
        ),
      ),
    );
  }
}
