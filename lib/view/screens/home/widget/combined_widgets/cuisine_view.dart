import 'package:efood_multivendor/controller/cuisine_controller.dart';
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

class CuisineView extends StatelessWidget {
  const CuisineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CuisineController>(builder: (cuisineController) {
      return (cuisineController.cuisineModel != null &&
              cuisineController.cuisineModel!.cuisines!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.isMobile(context)
                      ? Dimensions.paddingSizeDefault
                      : Dimensions.paddingSizeLarge),
              child: Stack(
                children: [
                  // Image.asset(Images.cuisineBg,
                  //     width: Dimensions.webMaxWidth,
                  //     fit: BoxFit.contain,
                  //     color: Theme.of(context).primaryColor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('cuisine'.tr,
                                style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge)),
                            ArrowIconButton(
                                onTap: () =>
                                    Get.toNamed(RouteHelper.getCuisineRoute())),
                          ],
                        ),
                      ),
                      cuisineController.cuisineModel != null
                          ? SizedBox(
                              height: ResponsiveHelper.isMobile(context)
                                  ? 130
                                  : 180,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(
                                    left: Dimensions.paddingSizeDefault,
                                    right: Dimensions.paddingSizeDefault,
                                    bottom: Dimensions.paddingSizeDefault),
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: cuisineController
                                            .cuisineModel!.cuisines!.length >
                                        7
                                    ? 8
                                    : cuisineController
                                        .cuisineModel!.cuisines!.length,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: Dimensions.paddingSizeSmall,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => Get.toNamed(
                                        RouteHelper.getCuisineRestaurantRoute(
                                            cuisineController.cuisineModel!
                                                .cuisines![index].id,
                                            cuisineController.cuisineModel!
                                                .cuisines![index].name)),
                                    // child: CuisineCard(
                                    //   image:
                                    //       '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}'
                                    //       '/${cuisineController.cuisineModel!.cuisines![index].image}',
                                    //   name: cuisineController
                                    //       .cuisineModel!.cuisines![index].name!,
                                    // ),
                                    child: Container(
                                      width: ResponsiveHelper.isMobile(context)
                                          ? 70
                                          : 100,
                                      height: ResponsiveHelper.isMobile(context)
                                          ? 70
                                          : 100,
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeExtraSmall),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall)),
                                      child: Column(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                              color:
                                                  Theme.of(context).cardColor,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ]),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            child: CustomImage(
                                              image:
                                                  '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}'
                                                  '/${cuisineController.cuisineModel!.cuisines![index].image}',
                                              height: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? 70
                                                  : 100,
                                              width: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? 70
                                                  : 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: ResponsiveHelper.isMobile(
                                                    context)
                                                ? Dimensions.paddingSizeDefault
                                                : Dimensions.paddingSizeLarge),
                                        Expanded(
                                            child: Text(
                                          cuisineController.cuisineModel!
                                              .cuisines![index].name!,
                                          style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            // color:Theme.of(context).textTheme.bodyMedium!.color,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        )),
                                      ]),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const CuisineShimmer()
                    ],
                  ),
                ],
              ),
            );
    });
  }
}

class CuisineShimmer extends StatelessWidget {
  const CuisineShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeDefault,
          bottom: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Dimensions.paddingSizeDefault,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.paddingSizeSmall),
              bottomRight: Radius.circular(Dimensions.paddingSizeSmall)),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
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
                            Get.find<ThemeController>().darkTheme ? 700 : 300],
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
                          Get.find<ThemeController>().darkTheme ? 700 : 300],
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
        );
      },
    );
  }
}
