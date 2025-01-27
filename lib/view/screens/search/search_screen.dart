import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/cuisine_controller.dart';
import 'package:efood_multivendor/controller/search_controller.dart' as search;
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/bottom_cart_widget.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/footer_view.dart';
import 'package:efood_multivendor/view/base/menu_drawer.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/web_header.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/cuisine_card.dart';
import 'package:efood_multivendor/view/screens/search/widget/filter_widget.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_field.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<search.SearchController>().setSearchMode(true, canUpdate: false);
    if (_isLoggedIn) {
      Get.find<search.SearchController>().getSuggestedFoods();
    }
    Get.find<CuisineController>().getCuisineList();
    Get.find<search.SearchController>().getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Get.find<search.SearchController>().isSearchMode) {
          return true;
        } else {
          Get.find<search.SearchController>().setSearchMode(true);
          return false;
        }
      },
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(child:
            GetBuilder<search.SearchController>(builder: (searchController) {
          _searchController.text = searchController.searchText;
          return Column(children: [
            Container(
              height: ResponsiveHelper.isDesktop(context) ? 130 : 80,
              color: ResponsiveHelper.isDesktop(context)
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ResponsiveHelper.isDesktop(context)
                      ? Text('search_food_and_restaurant'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge))
                      : const SizedBox(),
                  SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Row(children: [
                        SizedBox(
                            width: ResponsiveHelper.isMobile(context)
                                ? 0
                                : Dimensions.paddingSizeExtraSmall),

                        ResponsiveHelper.isDesktop(context)
                            ? const SizedBox()
                            : IconButton(
                                onPressed: () => searchController.isSearchMode
                                    ? Get.offNamedUntil(
                                        RouteHelper.getInitialRoute(),
                                        (route) => false,
                                      )
                                    : searchController.setSearchMode(true),
                                icon: const Icon(Icons.arrow_back_ios),
                              ),

                        Expanded(
                            child: SearchField(
                          controller: _searchController,
                          hint: 'search_food_or_restaurant'.tr,
                          suffixIcon: !searchController.isSearchMode
                              ? Icons.filter_list
                              : Icons.search,
                          iconPressed: () =>
                              _actionSearch(searchController, false),
                          onSubmit: (text) =>
                              _actionSearch(searchController, true),
                        )),
                        // ResponsiveHelper.isDesktop(context) ? const SizedBox() : CustomButton(
                        //   onPressed: () => searchController.isSearchMode ? Get.back() : searchController.setSearchMode(true),
                        //   buttonText: 'cancel'.tr,
                        //   transparent: true,
                        //   width: 80,
                        // ),
                        SizedBox(
                            width: ResponsiveHelper.isMobile(context)
                                ? Dimensions.paddingSizeSmall
                                : 0),
                      ])),
                ],
              )),
            ),
            Expanded(
                child: searchController.isSearchMode
                    ? SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: ResponsiveHelper.isDesktop(context)
                            ? EdgeInsets.zero
                            : const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                        child: FooterView(
                          child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    searchController.historyList.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('recent_search'.tr,
                                                    style: robotoMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge)),
                                                InkWell(
                                                  onTap: () => searchController
                                                      .clearSearchAddress(),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: Dimensions
                                                            .paddingSizeSmall,
                                                        horizontal: 4),
                                                    child: Text('clear_all'.tr,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error,
                                                        )),
                                                  ),
                                                ),
                                              ])
                                        : const SizedBox(),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    Wrap(
                                      children: searchController.historyList
                                          .map((address) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right:
                                                  Dimensions.paddingSizeSmall,
                                              bottom:
                                                  Dimensions.paddingSizeSmall),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.6)),
                                            ),
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () =>
                                                        searchController
                                                            .searchData(
                                                                address),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      child: Text(
                                                        address,
                                                        style: robotoRegular
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .color!
                                                                    .withOpacity(
                                                                        0.5)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeSmall),
                                                  InkWell(
                                                    onTap: () => searchController
                                                        .removeHistory(
                                                            searchController
                                                                .historyList
                                                                .indexOf(
                                                                    address)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      child: Icon(Icons.close,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          size: 20),
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),
                                    (_isLoggedIn &&
                                            searchController
                                                    .suggestedFoodList !=
                                                null)
                                        ? Text(
                                            'recommended'.tr,
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    (_isLoggedIn &&
                                            searchController
                                                    .suggestedFoodList !=
                                                null)
                                        ? searchController
                                                .suggestedFoodList!.isNotEmpty
                                            ? Wrap(
                                                children: searchController
                                                    .suggestedFoodList!
                                                    .map((product) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        right: Dimensions
                                                            .paddingSizeSmall,
                                                        bottom: Dimensions
                                                            .paddingSizeSmall),
                                                    child: InkWell(
                                                      onTap: () {
                                                        ResponsiveHelper
                                                                .isMobile(
                                                                    context)
                                                            ? Get.bottomSheet(
                                                                ProductBottomSheet(
                                                                    product:
                                                                        product),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                isScrollControlled:
                                                                    true,
                                                              )
                                                            : Get.dialog(
                                                                Dialog(
                                                                    child: ProductBottomSheet(
                                                                        product:
                                                                            product)),
                                                              );
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: Dimensions
                                                                .paddingSizeSmall,
                                                            vertical: Dimensions
                                                                .paddingSizeSmall),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                        child: Text(
                                                          product.name!,
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                    'no_suggestions_available'
                                                        .tr))
                                        : const SizedBox(),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),
                                    GetBuilder<CuisineController>(
                                        builder: (cuisineController) {
                                      return (cuisineController.cuisineModel !=
                                                  null &&
                                              cuisineController.cuisineModel!
                                                  .cuisines!.isEmpty)
                                          ? const SizedBox()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (cuisineController
                                                            .cuisineModel !=
                                                        null)
                                                    ? Text(
                                                        'cuisines'.tr,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge),
                                                      )
                                                    : const SizedBox(),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeDefault),
                                                (cuisineController
                                                            .cuisineModel !=
                                                        null)
                                                    ? cuisineController
                                                            .cuisineModel!
                                                            .cuisines!
                                                            .isNotEmpty
                                                        ? GetBuilder<
                                                                CuisineController>(
                                                            builder:
                                                                (cuisineController) {
                                                            return cuisineController
                                                                        .cuisineModel !=
                                                                    null
                                                                ? GridView
                                                                    .builder(
                                                                        gridDelegate:
                                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                          crossAxisCount: ResponsiveHelper.isDesktop(context)
                                                                              ? 8
                                                                              : ResponsiveHelper.isTab(context)
                                                                                  ? 6
                                                                                  : 4,
                                                                          mainAxisSpacing:
                                                                              20,
                                                                          crossAxisSpacing: ResponsiveHelper.isDesktop(context)
                                                                              ? 35
                                                                              : 15,
                                                                          childAspectRatio: ResponsiveHelper.isDesktop(context)
                                                                              ? 1
                                                                              : 0.9,
                                                                        ),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: cuisineController
                                                                            .cuisineModel!
                                                                            .cuisines!
                                                                            .length,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .vertical,
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name));
                                                                            },
                                                                            child:
                                                                                SizedBox(
                                                                              height: 130,
                                                                              child: CuisineCard(
                                                                                image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}/${cuisineController.cuisineModel!.cuisines![index].image}',
                                                                                name: cuisineController.cuisineModel!.cuisines![index].name!,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        })
                                                                : const Center(
                                                                    child:
                                                                        CircularProgressIndicator());
                                                          })
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            child: Text(
                                                                'no_suggestions_available'
                                                                    .tr))
                                                    : const SizedBox(),
                                              ],
                                            );
                                    }),
                                  ])),
                        ),
                      )
                    : SearchResultWidget(
                        searchText: _searchController.text.trim())),
          ]);
        })),
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.isNotEmpty &&
                  !ResponsiveHelper.isDesktop(context)
              ? const BottomCartWidget()
              : const SizedBox();
        }),
      ),
    );
  }

  void _actionSearch(search.SearchController searchController, bool isSubmit) {
    if (searchController.isSearchMode || isSubmit) {
      if (_searchController.text.trim().isNotEmpty) {
        searchController.searchData(_searchController.text.trim());
      } else {
        showCustomSnackBar('search_food_or_restaurant'.tr);
      }
    } else {
      List<double?> prices = [];
      if (!searchController.isRestaurant) {
        for (var product in searchController.allProductList!) {
          prices.add(product.price);
        }
        prices.sort();
      }
      double? maxValue = prices.isNotEmpty ? prices[prices.length - 1] : 1000;
      ResponsiveHelper.isMobile(context)
          ? Get.bottomSheet(FilterWidget(
              maxValue: maxValue, isRestaurant: searchController.isRestaurant))
          : Get.dialog(
              Dialog(
                  insetPadding: const EdgeInsets.all(30),
                  child: FilterWidget(
                      maxValue: maxValue,
                      isRestaurant: searchController.isRestaurant)),
            );
    }
  }
}
