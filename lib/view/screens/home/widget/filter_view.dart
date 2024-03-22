import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/data/model/response/cuisine_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/all_populer_restaurant_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';

class FilterView extends StatelessWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurant) {
      return restaurant.restaurantModel != null
          ? Row(
              children: [
                _buildCuisineFilter(restaurant, context),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                _buildTypeFilter(restaurant, context),
              ],
            )
          : const SizedBox();
    });
  }

  PopupMenuButton<String> _buildTypeFilter(
      RestaurantController restaurant, BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              value: 'all',
              textStyle: robotoMedium.copyWith(
                color: restaurant.restaurantType == 'all'
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).disabledColor,
              ),
              child: Text('all'.tr)),
          PopupMenuItem(
              value: 'take_away',
              textStyle: robotoMedium.copyWith(
                color: restaurant.restaurantType == 'take_away'
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).disabledColor,
              ),
              child: Text('take_away'.tr)),
          PopupMenuItem(
              value: 'delivery',
              textStyle: robotoMedium.copyWith(
                color: restaurant.restaurantType == 'delivery'
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).disabledColor,
              ),
              child: Text('delivery'.tr)),
          PopupMenuItem(
              value: 'latest',
              textStyle: robotoMedium.copyWith(
                color: restaurant.restaurantType == 'latest'
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).disabledColor,
              ),
              child: Text('latest'.tr)),
          PopupMenuItem(
              value: 'popular',
              textStyle: robotoMedium.copyWith(
                color: restaurant.restaurantType == 'popular'
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).disabledColor,
              ),
              child: Text('popular'.tr)),
        ];
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Container(
        height: 35,
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3)),
        ),
        child:
            Icon(Icons.tune, color: Theme.of(context).primaryColor, size: 20),
      ),
      onSelected: (dynamic value) => restaurant.setRestaurantType(value),
    );
  }

  Widget _buildCuisineFilter(
    RestaurantController restaurant,
    BuildContext context,
  ) {
    return GetBuilder<CuisineController>(
      builder: (cuisineController) {
        if (cuisineController.cuisineModel?.cuisines == null ||
            cuisineController.cuisineModel!.cuisines!.isEmpty) {
          return const SizedBox.shrink();
        }
        return InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CuisineSelectorDialog(
                    cuisines: cuisineController.cuisineModel!.cuisines!,
                    restaurant: restaurant,
                  );
                });
          },
          child: AllPopularRestaurantsFilterButton(
            buttonText: 'cuisine'.tr,
          ),
        );
        // return PopupMenuButton(
        //   itemBuilder: (context) {
        //     return cuisineController.cuisineModel!.cuisines!
        //         .map(
        //           (cuisine) => PopupMenuItem(
        //             value: cuisine.id,
        //             textStyle: robotoMedium.copyWith(
        //               color: restaurant.cuisines.contains(cuisine.id)
        //                   ? Theme.of(context).textTheme.bodyLarge!.color
        //                   : Theme.of(context).disabledColor,
        //             ),
        //             child: Text(cuisine.name ?? ""),
        //           ),
        //         )
        //         .toList();
        //   },
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        //   child: AllPopularRestaurantsFilterButton(
        //     buttonText: 'cuisine'.tr,
        //   ),
        //   onSelected: (int value) => restaurant.addCuisine(value),
        // );
      },
    );
  }
}

class CuisineSelectorDialog extends StatefulWidget {
  final List<Cuisines> cuisines;
  final RestaurantController restaurant;
  const CuisineSelectorDialog({
    super.key,
    required this.cuisines,
    required this.restaurant,
  });

  @override
  State<CuisineSelectorDialog> createState() => _CuisineSelectorDialogState();
}

class _CuisineSelectorDialogState extends State<CuisineSelectorDialog> {
  // List<int> selectedCuisines = [];
  List<Cuisines> displayCuisines = [];

  @override
  void initState() {
    super.initState();
    displayCuisines = widget.cuisines;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: ResponsiveHelper.isDesktop(context) ? 500 : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.clear),
                      const SizedBox(
                        width: Dimensions.paddingSizeSmall,
                      ),
                      Text(
                        'cuisines'.tr,
                        style: robotoMedium,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.restaurant.clearCuisines();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'clear_all'.tr,
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'search_cuisine'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  displayCuisines = widget.cuisines
                      .where((cuisine) => cuisine.name!
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                itemCount: displayCuisines.length,
                itemBuilder: (context, index) {
                  final cuisine = displayCuisines[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cuisine.name ?? "",
                        style: robotoMedium,
                      ),
                      Checkbox(
                        value: widget.restaurant.cuisines.contains(cuisine.id),
                        onChanged: (value) {
                          setState(() {
                            widget.restaurant.addCuisine(cuisine.id!);
                            // if (value!) {
                            //   selectedCuisines.add(cuisine.id!);
                            // } else {
                            //   selectedCuisines.remove(cuisine.id);
                            // }
                          });
                        },
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
            CustomButton(
              buttonText: 'apply'.tr,
              onPressed: () {
                widget.restaurant.submitCuisineFilter();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
