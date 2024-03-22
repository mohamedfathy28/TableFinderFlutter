import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/bottom_cart_widget.dart';
import 'package:efood_multivendor/view/base/footer_view.dart';
import 'package:efood_multivendor/view/base/menu_drawer.dart';
import 'package:efood_multivendor/view/base/paginated_list_view.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/veg_filter_widget.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/arrow_icon_button.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/item_card.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_info_section.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_screen_shimmer_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant? restaurant;
  final int? restaurantId;
  final String slug;
  final int? type;
  final int? tableId;
  const RestaurantScreen({
    Key? key,
    this.restaurant,
    this.slug = '',
    this.type,
    this.tableId,
    this.restaurantId,
  }) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.restaurantId != null) {
      Get.find<RestaurantController>().getRestaurantDetails(
          Restaurant(id: widget.restaurantId),
          slug: widget.slug);
      if (Get.find<RestaurantController>().categoryList == null) {
        Get.find<RestaurantController>()
            .getCategoryList(true, widget.restaurantId);
      }
    } else {
      Get.find<RestaurantController>().setRestaurant(widget.restaurant!);
      Get.find<RestaurantController>()
          .getCategoryList(true, widget.restaurantId);
    }

    initDataCall();
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  Future<void> initDataCall() async {
    Get.find<RestaurantController>().restaurantId =
        widget.restaurantId ?? widget.restaurant!.id!;
    getCategoryList(true);
    Get.find<OrderController>().orderTypeMethod = widget.type;
    Get.find<OrderController>().tableIdMethod = widget.tableId;
    if (Get.find<RestaurantController>().isSearching) {
      Get.find<RestaurantController>().changeSearchStatus(isUpdate: false);
    }
    await Get.find<RestaurantController>().getRestaurantDetails(
        Restaurant(id: widget.restaurantId ?? widget.restaurant!.id),
        slug: widget.slug);
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<CouponController>().getRestaurantCouponList(
        restaurantId: widget.restaurantId ??
            widget.restaurant!.id ??
            Get.find<RestaurantController>().restaurant!.id!);
    Get.find<RestaurantController>().getRestaurantRecommendedItemList(
        widget.restaurantId ??
            widget.restaurant!.id ??
            Get.find<RestaurantController>().restaurant!.id!,
        false);
    Get.find<RestaurantController>().getRestaurantProductList(
        widget.restaurantId ??
            widget.restaurant!.id ??
            Get.find<RestaurantController>().restaurant!.id!,
        1,
        'all',
        false);
  }

  List<CategoryModel>? _categoryList;
  List<bool>? _interestSelectedList;

  Future<void> getCategoryList(bool reload) async {
    if (_categoryList == null || reload) {
      Response response =
          await Get.find<CategoryController>().categoryRepo.getCategoryList(
                resId: widget.restaurantId ??
                    widget.restaurant!.id ??
                    Get.find<RestaurantController>().restaurant!.id!,
              );
      if (response.statusCode == 200) {
        _categoryList = [];
        _interestSelectedList = [];
        response.body.forEach((category) {
          _categoryList!.add(CategoryModel.fromJson(category));
          _interestSelectedList!.add(false);
        });
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  bool calledSetCategoryList = false;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
        appBar: isDesktop ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).cardColor,
        body: GetBuilder<RestaurantController>(builder: (restController) {
          Restaurant? restaurant = restController.restaurant;
          if (restController.restaurant != null &&
              restController.restaurant!.name != null &&
              _categoryList != null) {
            restaurant = restController.restaurant;
          }
          restController.setCategoryList();

          return (restController.restaurant != null &&
                  restController.restaurant?.name != null &&
                  restController.categoryList != null)
              ? CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  slivers: [
                    RestaurantInfoSection(
                        restaurant: restaurant!,
                        restController: restController),
                    SliverToBoxAdapter(
                        child: Center(
                            child: Container(
                      width: Dimensions.webMaxWidth,
                      color: Theme.of(context).cardColor,
                      child: Column(children: [
                        // isDesktop ? const SizedBox() : RestaurantDescriptionView(restaurant: restaurant),
                        restaurant.discount != null
                            ? Container(
                                width: context.width,
                                margin: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeSmall,
                                    horizontal: Dimensions.paddingSizeLarge),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    color: Theme.of(context).primaryColor),
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        restaurant.discount!.discountType ==
                                                'percent'
                                            ? '${restaurant.discount!.discount}% ${'off'.tr}'
                                            : '${PriceConverter.convertPrice(restaurant.discount!.discount)} ${'off'.tr}',
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context).cardColor),
                                      ),
                                      Text(
                                        restaurant.discount!.discountType ==
                                                'percent'
                                            ? '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}'
                                            : '${'enjoy'.tr} ${PriceConverter.convertPrice(restaurant.discount!.discount)}'
                                                ' ${'off_on_all_categories'.tr}',
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).cardColor),
                                      ),
                                      SizedBox(
                                          height: (restaurant.discount!
                                                          .minPurchase !=
                                                      0 ||
                                                  restaurant.discount!
                                                          .maxDiscount !=
                                                      0)
                                              ? 5
                                              : 0),
                                      restaurant.discount!.minPurchase != 0
                                          ? Text(
                                              '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            )
                                          : const SizedBox(),
                                      restaurant.discount!.maxDiscount != 0
                                          ? Text(
                                              '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            )
                                          : const SizedBox(),
                                      Text(
                                        '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(restaurant.discount!.startTime!)} '
                                        '- ${DateConverter.convertTimeToTime(restaurant.discount!.endTime!)} ]',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).cardColor),
                                      ),
                                    ]),
                              )
                            : const SizedBox(),
                        SizedBox(
                            height: (restaurant.announcementActive! &&
                                    restaurant.announcementMessage != null)
                                ? 0
                                : Dimensions.paddingSizeSmall),

                        ResponsiveHelper.isMobile(context)
                            ? (restaurant.announcementActive! &&
                                    restaurant.announcementMessage != null)
                                ? Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.green),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeSmall,
                                        horizontal:
                                            Dimensions.paddingSizeLarge),
                                    margin: const EdgeInsets.only(
                                        bottom: Dimensions.paddingSizeSmall),
                                    child: Row(children: [
                                      Image.asset(Images.announcement,
                                          height: 26, width: 26),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeSmall),
                                      Flexible(
                                        child: Text(
                                          restaurant.announcementMessage ?? '',
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color:
                                                  Theme.of(context).cardColor),
                                        ),
                                      ),
                                    ]),
                                  )
                                : const SizedBox()
                            : const SizedBox(),

                        restController.recommendedProductModel != null &&
                                restController.recommendedProductModel!
                                    .products!.isNotEmpty
                            ? Container(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: Dimensions.paddingSizeLarge,
                                        left: Dimensions.paddingSizeLarge,
                                        bottom: Dimensions.paddingSizeSmall,
                                        right: Dimensions.paddingSizeLarge,
                                      ),
                                      child: Row(children: [
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'popular_in_this_restaurant'
                                                        .tr,
                                                    style:
                                                        robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Text(
                                                    'here_is_what_you_might_like_to_test'
                                                        .tr,
                                                    style:
                                                        robotoRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)),
                                              ]),
                                        ),
                                        ArrowIconButton(
                                          onTap: () => Get.toNamed(
                                              RouteHelper.getPopularFoodRoute(
                                                  false,
                                                  fromIsRestaurantFood: true,
                                                  restaurantId: widget
                                                          .restaurant!.id ??
                                                      Get.find<
                                                              RestaurantController>()
                                                          .restaurant!
                                                          .id!)),
                                        ),
                                      ]),
                                    ),
                                    SizedBox(
                                      height: 260,
                                      width: context.width,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: restController
                                            .recommendedProductModel!
                                            .products!
                                            .length,
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                            top: Dimensions
                                                .paddingSizeExtraSmall,
                                            bottom: Dimensions
                                                .paddingSizeExtraSmall,
                                            right:
                                                Dimensions.paddingSizeDefault),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: Dimensions
                                                    .paddingSizeDefault),
                                            child: ItemCard(
                                              product: restController
                                                  .recommendedProductModel!
                                                  .products![index],
                                              isBestItem: false,
                                              isPopularNearbyItem: false,
                                              resRoute: RouteHelper
                                                  .getRestaurantRoute(
                                                widget.restaurantId ??
                                                    widget.restaurant!.id,
                                                widget.type,
                                                widget.tableId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ]),
                    ))),
                    (restController.categoryList?.isNotEmpty ?? false)
                        ? SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverDelegate(
                                height: 95,
                                child: Center(
                                    child: Container(
                                  width: Dimensions.webMaxWidth,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    boxShadow: isDesktop
                                        ? []
                                        : [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 5)
                                          ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: Dimensions.paddingSizeLarge,
                                          right: Dimensions.paddingSizeLarge,
                                          top: Dimensions.paddingSizeSmall),
                                      child: Row(children: [
                                        Text('all_food_items'.tr,
                                            style: robotoBold.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeDefault)),
                                        const Expanded(child: SizedBox()),
                                        isDesktop
                                            ? Container(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeExtraSmall),
                                                height: 35,
                                                width: 320,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.40)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        controller:
                                                            _searchController,
                                                        textInputAction:
                                                            TextInputAction
                                                                .search,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 0,
                                                                  vertical: 0),
                                                          hintText:
                                                              'search_for_products'
                                                                  .tr,
                                                          hintStyle: robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      Dimensions
                                                                          .radiusSmall),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                          filled: true,
                                                          fillColor:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          isDense: true,
                                                          prefixIcon: InkWell(
                                                            onTap: () {
                                                              if (!restController
                                                                  .isSearching) {
                                                                Get.find<
                                                                        RestaurantController>()
                                                                    .getRestaurantSearchProductList(
                                                                  _searchController
                                                                      .text
                                                                      .trim(),
                                                                  widget
                                                                      .restaurant!
                                                                      .id
                                                                      .toString(),
                                                                  1,
                                                                  restController
                                                                      .type,
                                                                );
                                                              } else {
                                                                _searchController
                                                                    .text = '';
                                                                restController
                                                                    .initSearchData();
                                                                restController
                                                                    .changeSearchStatus();
                                                              }
                                                            },
                                                            child: Icon(
                                                                restController
                                                                        .isSearching
                                                                    ? Icons
                                                                        .clear
                                                                    : CupertinoIcons
                                                                        .search,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.50)),
                                                          ),
                                                        ),
                                                        onSubmitted:
                                                            (String? value) {
                                                          if (value!
                                                              .isNotEmpty) {
                                                            restController
                                                                .getRestaurantSearchProductList(
                                                              _searchController
                                                                  .text
                                                                  .trim(),
                                                              (widget.restaurantId ??
                                                                      widget
                                                                          .restaurant!
                                                                          .id)
                                                                  .toString(),
                                                              1,
                                                              restController
                                                                  .type,
                                                            );
                                                          }
                                                        },
                                                        onChanged:
                                                            (String? value) {},
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeSmall),
                                                  ],
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  await Get.toNamed(RouteHelper
                                                      .getSearchRestaurantProductRoute(
                                                          restaurant!.id));
                                                  if (restController
                                                      .isSearching) {
                                                    restController
                                                        .changeSearchStatus();
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault),
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Image.asset(
                                                      Images.search,
                                                      height: 25,
                                                      width: 25,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                        restController.type.isNotEmpty
                                            ? VegFilterWidget(
                                                type: restController.type,
                                                onSelected: (String type) {
                                                  restController
                                                      .getRestaurantProductList(
                                                          restController
                                                              .restaurant!.id,
                                                          1,
                                                          type,
                                                          true);
                                                },
                                              )
                                            : const SizedBox(),
                                      ]),
                                    ),
                                    const Divider(thickness: 0.2, height: 10),
                                    SizedBox(
                                      height: 30,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: restController
                                                .categoryList?.length ??
                                            0,
                                        padding: const EdgeInsets.only(
                                            left: Dimensions.paddingSizeLarge),
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () => restController
                                                .setCategoryIndex(index),
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeSmall,
                                                  vertical: Dimensions
                                                      .paddingSizeExtraSmall),
                                              margin: const EdgeInsets.only(
                                                  right: Dimensions
                                                      .paddingSizeSmall),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .radiusDefault),
                                                color: index ==
                                                        restController
                                                            .categoryIndex
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1)
                                                    : Colors.transparent,
                                              ),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      restController
                                                          .categoryList![index]
                                                          .name!,
                                                      style: index ==
                                                              restController
                                                                  .categoryIndex
                                                          ? robotoMedium.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)
                                                          : robotoRegular.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                    ),
                                                  ]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ]),
                                ))),
                          )
                        : const SliverToBoxAdapter(child: SizedBox()),
                    SliverToBoxAdapter(
                        child: FooterView(
                      child: Center(
                          child: Container(
                        width: Dimensions.webMaxWidth,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                        ),
                        child: PaginatedListView(
                          scrollController: scrollController,
                          onPaginate: (int? offset) {
                            if (restController.isSearching) {
                              restController.getRestaurantSearchProductList(
                                restController.searchText,
                                (widget.restaurantId ?? widget.restaurant!.id)
                                    .toString(),
                                offset!,
                                restController.type,
                              );
                            } else {
                              restController.getRestaurantProductList(
                                  widget.restaurantId ?? widget.restaurant!.id,
                                  offset!,
                                  restController.type,
                                  false);
                            }
                          },
                          totalSize: restController.isSearching
                              ? restController
                                  .restaurantSearchProductModel?.totalSize
                              : restController.restaurantProducts != null
                                  ? restController.foodPageSize
                                  : null,
                          offset: restController.isSearching
                              ? restController
                                  .restaurantSearchProductModel?.offset
                              : restController.restaurantProducts != null
                                  ? restController.foodPageOffset
                                  : null,
                          productView: ProductView(
                            isRestaurant: false,
                            restaurants: null,
                            products: restController.isSearching
                                ? restController
                                    .restaurantSearchProductModel?.products
                                : restController.categoryList?.isNotEmpty ??
                                        false
                                    ? restController.restaurantProducts
                                    : null,
                            inRestaurantPage: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeLarge,
                            ),
                          ),
                        ),
                      )),
                    )),
                  ],
                )
              : const RestaurantScreenShimmerView();
        }),
        bottomNavigationBar:
            GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.isNotEmpty && !isDesktop
              ? BottomCartWidget(
                  restaurantId: widget.restaurantId ?? widget.restaurant!.id,
                  restaurantName: widget.restaurant!.name ?? "",
                )
              : const SizedBox();
        }));
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;

  SliverDelegate({required this.child, this.height = 100});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}
