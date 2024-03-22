import 'dart:convert';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/menu_drawer.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/scan/models/reserve_history_model.dart';
import 'package:efood_multivendor/view/screens/scan/reservation/reservation_history_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReservationHistoryScreen extends StatefulWidget {
  static void navigate(BuildContext context, {required bool isWaitingList}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReservationHistoryScreen(
            isWaitingList: isWaitingList,
          ),
        ),
      );

  final bool isWaitingList;
  const ReservationHistoryScreen({
    Key? key,
    required this.isWaitingList,
  }) : super(key: key);

  @override
  ReservationHistoryScreenState createState() =>
      ReservationHistoryScreenState();
}

class ReservationHistoryScreenState extends State<ReservationHistoryScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isError = false;
  String errMessage = "";

  ReserveHistoryModel? data;

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    _getData();
  }

  _callApi(ReserveHistoryItemModel item) async {
    setState(() {
      isLoading = true;
    });
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(AppConstants.token);

      String endpoint =
          "/api/v1/customer/table_reservation/cancellation/${item.id}";
      if (widget.isWaitingList) {
        endpoint = "/api/v1/customer/waiting_list/cancellation/${item.id}";
      }

      final res = await http.get(
        Uri.parse("${AppConstants.baseUrl}$endpoint"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && (data["success"] as bool? ?? false)) {
        _getData();
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

  _getData() async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
        errMessage = "";
      });
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(AppConstants.token);
      String endpoint = "/api/v1/customer/table_reservation/history";
      if (widget.isWaitingList) {
        endpoint = "/api/v1/customer/waiting_list/history";
      }
      final res = await http.get(
        Uri.parse("${AppConstants.baseUrl}$endpoint"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        data = ReserveHistoryModel.fromJson(body);
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

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isWaitingList
            ? 'waiting_list_history'.tr
            : 'reservation_history'.tr,
        isBackButtonExist: true,
      ),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: RefreshIndicator(
        onRefresh: () async {
          _getData();
        },
        child: Builder(builder: (context) {
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
        }),
      ),
    );
  }

  Widget _buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisSpacing: Dimensions.paddingSizeLarge,
        //   mainAxisSpacing: 0,
        //   childAspectRatio: 4.5,
        //   crossAxisCount:
        //       ResponsiveHelper.isMobile(context) ? 1 : 2,
        // ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        itemCount: data!.data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = data!.data[index];
          return HistoryItemWidget(
            item: item,
            onTap: _callApi,
            hideTotal: widget.isWaitingList,
          );
        },
      ),
    );
  }
}

class HistoryItemWidget extends StatelessWidget {
  const HistoryItemWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.hideTotal,
  });

  final ReserveHistoryItemModel item;
  final bool hideTotal;
  final Function(ReserveHistoryItemModel item) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!hideTotal) {
          ReservationHistoryDetailsScreen.navigate(context, id: item.id);
        }
      },
      hoverColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImage(
                  image:
                      '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                      '/${item.restaurant_logo}',
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.restaurant_name,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${'reservation_id'.tr}:',
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),
                              const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall,
                              ),
                              Text(
                                '#${item.id}',
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),
                            ],
                          ),
                          if (!hideTotal)
                            _buildDataRow(
                              title: '${'total'.tr}:',
                              value: item.total,
                            ),
                          _buildDataRow(
                            title: '${'no_of_guest'.tr}:',
                            value: '#${item.guest}',
                          ),
                          _buildDataRow(
                            title: '${'status'.tr}:',
                            value: item.status,
                          ),
                          // if (hideTotal && item.table_number != null)
                          _buildDataRow(
                            title: '${'table_number'.tr}:',
                            value: item.table_number ?? "0",
                          ),
                        ],
                      ),
                    ),
                    if (item.can_cancel)
                      SizedBox(
                        width: 80,
                        child: CustomButton(
                          buttonText: "cancel".tr,
                          onPressed: () {
                            onTap(item);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildDataRow({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Text(
          value,
          style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
      ],
    );
  }
}
