import 'dart:convert';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/menu_drawer.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/scan/models/history_details/history_details_model.dart';
import 'package:efood_multivendor/view/screens/scan/models/history_details/history_details_order_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReservationHistoryDetailsScreen extends StatefulWidget {
  static void navigate(
    BuildContext context, {
    required int id,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReservationHistoryDetailsScreen(
            id: id,
          ),
        ),
      );
  final int id;
  const ReservationHistoryDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ReservationHistoryDetailsScreenState createState() =>
      ReservationHistoryDetailsScreenState();
}

class ReservationHistoryDetailsScreenState
    extends State<ReservationHistoryDetailsScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isError = false;
  String errMessage = "";

  HistoryDetailsModel? data;

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    _getData();
  }

  _getData() async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
        errMessage = "";
      });
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(AppConstants.token);
      final res = await http.get(
        Uri.parse(
            "${AppConstants.baseUrl}/api/v1/customer/table_reservation/history_data/${widget.id}"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        data = HistoryDetailsModel.fromJson(body);
      } else {
        isError = true;
        errMessage = body["message"];
      }
    } catch (e, t) {
      debugPrint(
        e.toString(),
      );
      debugPrint(
        t.toString(),
      );
      isError = true;
      errMessage =
          "Something went wrong while getting the config. Tap to refresh.";
    }
    setState(() {
      isLoading = false;
    });
  }

  _callApi() async {
    setState(() {
      isLoading = true;
    });
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(AppConstants.token);

      final res = await http.get(
        Uri.parse(
            "${AppConstants.baseUrl}/api/v1/customer/table_reservation/cancellation/${widget.id}"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && (data["success"] as bool? ?? false)) {
        _getData();
        if (mounted) Navigator.of(context).pop();
      } else {
        showCustomSnackBar(data['message'] ?? "Something went wrong!");
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'reservation_details'.tr,
        isBackButtonExist: true,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: RefreshIndicator(
        onRefresh: () async {
          _getData();
        },
        child: Builder(
          builder: (context) {
            if (!isLoggedIn) {
              return NotLoggedInScreen(
                callBack: (value) {
                  _getData();
                  setState(() {});
                },
              );
            }
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (isError) {
              return Center(
                child: InkWell(
                  onTap: _getData,
                  child: Text(errMessage),
                ),
              );
            }
            return _buildBody();
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildGeneralInfo(),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        if (data!.data.order_details.isNotEmpty) _buildItems(),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        _buildRestaurantDetails(),
        const Expanded(
            child: SizedBox(width: Dimensions.paddingSizeExtraLarge)),
        if (data!.data.can_cancel)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge,
              vertical: Dimensions.paddingSizeSmall,
            ),
            child: CustomButton(
              buttonText: "cancel_reservation".tr,
              onPressed: () {
                _callApi();
              },
            ),
          ),
      ],
    );
  }

  Widget _buildGeneralInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              blurRadius: 10)
        ],
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('general_info'.tr, style: robotoMedium),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Row(children: [
            Text(
              '${'reservation_id'.tr}:',
              style: robotoRegular,
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(widget.id.toString(), style: robotoMedium),
            const Expanded(child: SizedBox()),
            const Icon(Icons.watch_later, size: 17),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(
              data!.data.date_time,
              style: robotoRegular,
            ),
          ]),
          if (data!.data.order_details.isNotEmpty)
            const Divider(height: Dimensions.paddingSizeLarge),
          if (data!.data.order_details.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(
                children: [
                  Text('${'item'.tr}:', style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    data!.data.order_details.length.toString(),
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    height: 7,
                    width: 7,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                ],
              ),
            ),
          const Divider(height: Dimensions.paddingSizeLarge),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(
              children: [
                Text('${'status'.tr}:', style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  data!.data.status,
                  style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          const Divider(height: Dimensions.paddingSizeLarge),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(
              children: [
                Text('${'no_of_guest'.tr}:', style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  data!.data.guest.toString(),
                  style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          if (data!.data.table_number != null)
            const Divider(height: Dimensions.paddingSizeLarge),
          if (data!.data.table_number != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(
                children: [
                  Text('${'table_number'.tr}:', style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    data!.data.table_number,
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeLarge,
            vertical: Dimensions.paddingSizeSmall),
        child: Text('item_info'.tr, style: robotoMedium),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data!.data.order_details.length,
        itemBuilder: (context, index) {
          return ReservationHistoryProductWidget(
            order: data!.data.order_details[index],
            orderDetails: data!.data.order_details[index],
          );
        },
      ),
    ]);
// const SizedBox(height: Dimensions.paddingSizeSmall),
  }

  Widget _buildRestaurantDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'restaurant_details'.tr,
            style: robotoMedium,
          ),
          const SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          Row(
            children: [
              ClipOval(
                  child: CustomImage(
                image:
                    '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${data!.data.restaurant_logo}',
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              )),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data!.data.restaurant_name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReservationHistoryProductWidget extends StatelessWidget {
  final HistoryDetailsOrderDetailsModel order;
  final HistoryDetailsOrderDetailsModel orderDetails;
  // final OrderDetailsModel orderDetails;
  const ReservationHistoryProductWidget({
    Key? key,
    required this.order,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    for (var addOn in order.add_ons!) {
      addOnText =
          '$addOnText${(addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
    }

    String? variationText = '';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeSmall,
          horizontal: Dimensions.paddingSizeLarge),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          orderDetails.food_details.image.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      image:
                          '${orderDetails.item_campaign_id != null ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/'
                          '${orderDetails.food_details.image}',
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(
                  orderDetails.food_details.name,
                  style:
                      robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
                Text('${'quantity'.tr}:',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall)),
                Text(
                  orderDetails.quantity.toString(),
                  style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(children: [
                Expanded(
                    child: Text(
                  PriceConverter.convertPrice(
                    double.parse(orderDetails.price),
                  ),
                  style: robotoMedium,
                  textDirection: TextDirection.ltr,
                )),
                Get.find<SplashController>().configModel!.toggleVegNonVeg!
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraSmall,
                            horizontal: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.05),
                        ),
                        child: Text(
                          orderDetails.food_details.veg ?? "Non-Veg",
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).primaryColor),
                        ),
                      )
                    : const SizedBox(),
              ]),
            ]),
          ),
        ]),
        addOnText.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  const SizedBox(width: 60),
                  Text('${'addons'.tr}: ',
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall)),
                  Flexible(
                      child: Text(addOnText,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor,
                          ))),
                ]),
              )
            : const SizedBox(),
        variationText != ''
            ? (orderDetails.food_details.variations != null &&
                    orderDetails.food_details.variations!.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeExtraSmall),
                    child: Row(children: [
                      const SizedBox(width: 60),
                      Text('${'variations'.tr}: ',
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall)),
                      Flexible(
                          child: Text(variationText,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).disabledColor,
                              ))),
                    ]),
                  )
                : const SizedBox()
            : const SizedBox(),
        const Divider(height: Dimensions.paddingSizeLarge),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ]),
    );
  }
}
