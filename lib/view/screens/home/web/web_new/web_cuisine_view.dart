import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/arrow_icon_button.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/cuisine_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebCuisineView extends StatelessWidget {
  const WebCuisineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(builder: (cuisineController) {
      return (cuisineController.cuisineModel != null &&
              cuisineController.cuisineModel!.cuisines!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeLarge),
              child: Container(
                // height: 216,
                // width: Dimensions.webMaxWidth,
                // decoration: BoxDecoration(
                //   color: Theme.of(context).primaryColor.withOpacity(0.1),
                //   borderRadius: const BorderRadius.all(
                //       Radius.circular(Dimensions.radiusSmall)),
                // ),
                child: Stack(
                  children: [
                    // Image.asset(Images.cuisineBg,
                    //     height: 216,
                    //     width: Dimensions.webMaxWidth,
                    //     fit: BoxFit.cover,
                    //     color: Theme.of(context).primaryColor),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: ResponsiveHelper.isMobile(context)
                                ? Dimensions.paddingSizeLarge
                                : Dimensions.paddingSizeOverLarge,
                            left: Get.find<LocalizationController>().isLtr
                                ? Dimensions.paddingSizeExtraSmall
                                : 0,
                            right: Get.find<LocalizationController>().isLtr
                                ? 0
                                : Dimensions.paddingSizeExtraSmall,
                            bottom: ResponsiveHelper.isMobile(context)
                                ? Dimensions.paddingSizeDefault
                                : Dimensions.paddingSizeOverLarge,
                          ),
                          child: Text('cuisine'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                        ),
                        cuisineController.cuisineModel != null
                            ? Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: ResponsiveHelper.isMobile(context)
                                          ? 120
                                          : 170,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: Dimensions.paddingSizeLarge,
                                            right: Dimensions.paddingSizeLarge),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: cuisineController
                                                        .cuisineModel!
                                                        .cuisines!
                                                        .length >
                                                    7
                                                ? 7
                                                : cuisineController
                                                    .cuisineModel!
                                                    .cuisines!
                                                    .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 35),
                                                child: InkWell(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  onTap: () => Get.toNamed(
                                                      RouteHelper
                                                          .getCuisineRestaurantRoute(
                                                              cuisineController
                                                                  .cuisineModel!
                                                                  .cuisines![
                                                                      index]
                                                                  .id,
                                                              cuisineController
                                                                  .cuisineModel!
                                                                  .cuisines![
                                                                      index]
                                                                  .name)),
                                                  // child: CuisineCard(
                                                  //   image:
                                                  //       '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}'
                                                  //       '/${cuisineController.cuisineModel!.cuisines![index].image}',
                                                  //   name: cuisineController
                                                  //       .cuisineModel!
                                                  //       .cuisines![index]
                                                  //       .name!,
                                                  // ),
                                                  child: Container(
                                                    width: ResponsiveHelper
                                                            .isMobile(context)
                                                        ? 70
                                                        : 100,
                                                    height: ResponsiveHelper
                                                            .isMobile(context)
                                                        ? 70
                                                        : 100,
                                                    padding: const EdgeInsets
                                                        .all(Dimensions
                                                            .paddingSizeExtraSmall),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusSmall)),
                                                    child: Column(children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                            color: Theme.of(context).cardColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.1),
                                                                  blurRadius: 5,
                                                                  spreadRadius:
                                                                      1)
                                                            ]),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                          child: CustomImage(
                                                            image:
                                                                '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}'
                                                                '/${cuisineController.cuisineModel!.cuisines![index].image}',
                                                            height: ResponsiveHelper
                                                                    .isMobile(
                                                                        context)
                                                                ? 70
                                                                : 100,
                                                            width: ResponsiveHelper
                                                                    .isMobile(
                                                                        context)
                                                                ? 70
                                                                : 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: ResponsiveHelper
                                                                  .isMobile(
                                                                      context)
                                                              ? Dimensions
                                                                  .paddingSizeDefault
                                                              : Dimensions
                                                                  .paddingSizeLarge),
                                                      Expanded(
                                                          child: Text(
                                                        cuisineController
                                                            .cuisineModel!
                                                            .cuisines![index]
                                                            .name!,
                                                        style: robotoMedium
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          // color:Theme.of(context).textTheme.bodyMedium!.color,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ]),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                  ArrowIconButton(
                                    onTap: () => Get.toNamed(
                                        RouteHelper.getCuisineRoute()),
                                  ),
                                  const SizedBox(width: 35),
                                ],
                              )
                            : const WebCuisineShimmer()
                      ],
                    ),
                  ],
                ),
              ),
            );
    });
  }
}

class WebCuisineShimmer extends StatelessWidget {
  const WebCuisineShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 35),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Dimensions.paddingSizeSmall),
                  bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),
              child: Shimmer(
                enabled: true,
                duration: const Duration(seconds: 2),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -55,
                      left: 0,
                      right: 0,
                      child: Transform.rotate(
                        angle: 40,
                        child: Container(
                          height: 120,
                          width: 120,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300],
                            borderRadius: BorderRadius.circular(50)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey[
                                  Get.find<ThemeController>().darkTheme
                                      ? 700
                                      : 300],
                            )),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 120,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 700
                                  : 300],
                          borderRadius: const BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(Dimensions.paddingSizeSmall),
                              bottomRight:
                                  Radius.circular(Dimensions.paddingSizeSmall)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

