import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/scan/reserve_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCartSnackBar() {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: ResponsiveHelper.isDesktop(Get.context)
        ? EdgeInsets.only(
            right: Get.context!.width * 0.7,
            left: Dimensions.paddingSizeSmall,
            bottom: Dimensions.paddingSizeSmall,
          )
        : const EdgeInsets.all(Dimensions.paddingSizeSmall),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
    action: SnackBarAction(
      label: Get.find<RestaurantController>().backFromReservation
          ? "reserve".tr
          : 'view_cart'.tr,
      textColor: Colors.white,
      onPressed: () {
        if (Get.find<RestaurantController>().backFromReservation &&
            Get.find<RestaurantController>().restaurant?.name != null &&
            Get.find<RestaurantController>().restaurant?.id != null) {
          final id = Get.find<RestaurantController>().restaurant!.id;
          final name = Get.find<RestaurantController>().restaurant!.name;
          ReserveScreen.navigate(
            Get.context!,
            restaurantId: id!,
            restaurantName: name!,
            isCartEmpty: false,
          );
          return;
        }
        Get.toNamed(RouteHelper.getCartRoute());
      },
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
    content: Text(
      'item_added_to_cart'.tr,
      style: robotoMedium.copyWith(color: Colors.white),
    ),
  ));
}

