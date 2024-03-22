import 'dart:convert';

import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/menu_drawer.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/my_points/model/awarded_model.dart';
import 'package:efood_multivendor/view/screens/my_points/model/redeem_model.dart';
import 'package:efood_multivendor/view/screens/my_points/model/spent_model.dart';
import 'package:efood_multivendor/view/screens/my_points/subscreen/awarded_subscreen.dart';
import 'package:efood_multivendor/view/screens/my_points/subscreen/redeem_subscreen.dart';
import 'package:efood_multivendor/view/screens/my_points/subscreen/spent_subscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyPointsScreen extends StatefulWidget {
  const MyPointsScreen({super.key});

  @override
  State<MyPointsScreen> createState() => _MyPointsScreenState();
}

class _MyPointsScreenState extends State<MyPointsScreen> {
  String points = "";
  int selectedTabIndex = 0;

  final controller = PageController();
  List<AwardedModel>? awardedList;
  List<RedeemModel>? redeemedList;
  List<SpentModel>? spentList;

  bool isAwardedError = false;
  bool isRedeemError = false;
  bool isSpentError = false;

  @override
  void initState() {
    super.initState();
    getAwarded();
    getRedeem();
    getSpent();
  }

  getAwarded() async {
    setState(() {
      isAwardedError = false;
      awardedList = null;
    });
    final res = await http.get(
        Uri.parse("${AppConstants.baseUrl}/api/v1/customer/points/awards"),
        headers: {
          'Authorization': 'Bearer ${Get.find<ApiClient>().token}',
        });
    if (res.statusCode == 200) {
      awardedList = [];
      points = jsonDecode(res.body)['points'].toString();
      for (var item in jsonDecode(res.body)['data']) {
        awardedList!.add(AwardedModel.fromJson(item));
      }
    } else {
      isAwardedError = true;
    }
    setState(() {});
  }

  getRedeem() async {
    setState(() {
      isRedeemError = false;
      redeemedList = null;
    });
    final res = await http.get(
        Uri.parse("${AppConstants.baseUrl}/api/v1/customer/points/plan"),
        headers: {
          'Authorization': 'Bearer ${Get.find<ApiClient>().token}',
        });
    if (res.statusCode == 200) {
      redeemedList = [];
      points = jsonDecode(res.body)['points'].toString();
      for (var item in jsonDecode(res.body)['data']) {
        redeemedList!.add(RedeemModel.fromJson(item));
      }
    } else {
      isRedeemError = true;
    }
    setState(() {});
  }

  getSpent() async {
    setState(() {
      isSpentError = false;
      spentList = null;
    });
    final res = await http.get(
        Uri.parse("${AppConstants.baseUrl}/api/v1/customer/points/spend"),
        headers: {
          'Authorization': 'Bearer ${Get.find<ApiClient>().token}',
        });
    if (res.statusCode == 200) {
      spentList = [];
      points = jsonDecode(res.body)['points'].toString();
      for (var item in jsonDecode(res.body)['data']) {
        spentList!.add(SpentModel.fromJson(item));
      }
    } else {
      isSpentError = true;
    }
    setState(() {});
  }

  exchangePoints(int planId) async {
    await http.post(
        Uri.parse(
            "${AppConstants.baseUrl}/api/v1/customer/points/ExchangePoints?plan_id=$planId"),
        headers: {
          'Authorization': 'Bearer ${Get.find<ApiClient>().token}',
        });
    getSpent();
    getAwarded();
    getRedeem();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).cardColor,
      body: Center(
        child: Container(
          width: context.width > 700 ? 500 : context.width,
          padding: context.width > 700
              ? const EdgeInsets.all(50)
              : const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
          margin:
              context.width > 700 ? const EdgeInsets.all(50) : EdgeInsets.zero,
          decoration: context.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: ResponsiveHelper.isDesktop(context)
                      ? null
                      : [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                    vertical: Dimensions.paddingSizeExtraLarge),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !ResponsiveHelper.isDesktop(context)
                          ? IconButton(
                              onPressed: () => Get.offNamedUntil(
                                RouteHelper.getInitialRoute(),
                                (route) => false,
                              ),
                              icon: const Icon(Icons.arrow_back_ios),
                            )
                          : const SizedBox(),
                      Text(
                        'my_points'.tr,
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                      const SizedBox(width: 50),
                    ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Text(
                "${'my_points'.tr}: $points",
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              _buildTabs(),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (int index) {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  children: [
                    AwardedSubscreen(
                      isError: isAwardedError,
                      data: awardedList,
                    ),
                    SpentSubscreen(
                      isError: isSpentError,
                      data: spentList,
                    ),
                    RedeemSubscreen(
                      data: redeemedList,
                      isError: isRedeemError,
                      callback: exchangePoints,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTabs() {
    return Row(
      children: [
        _buildTabButton(
          title: 'awarded'.tr,
          isSelected: selectedTabIndex == 0,
          onTap: () {
            controller.jumpToPage(0);
            setState(() {
              selectedTabIndex = 0;
            });
          },
        ),
        _buildTabButton(
          title: 'spent'.tr,
          isSelected: selectedTabIndex == 1,
          onTap: () {
            controller.jumpToPage(1);
            setState(() {
              selectedTabIndex = 1;
            });
          },
        ),
        _buildTabButton(
          title: 'redeem'.tr,
          isSelected: selectedTabIndex == 2,
          onTap: () {
            controller.jumpToPage(2);
            setState(() {
              selectedTabIndex = 2;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: isSelected ? 4 : 1,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(Get.context!).primaryColor
                    : Colors.grey,
                borderRadius: isSelected ? BorderRadius.circular(4) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
