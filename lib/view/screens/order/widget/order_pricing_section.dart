import 'package:dotted_border/dotted_border.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/order/widget/bottom_view_widget.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPricingSection extends StatelessWidget {
  final double itemsPrice;
  final double addOns;
  final OrderModel order;
  final double subTotal;
  final double discount;
  final double couponDiscount;
  final double tax;
  final double? service;
  final double dmTips;
  final double deliveryCharge;
  final double total;
  final OrderController orderController;
  final int? orderId;
  final String? contactNumber;
  final double? fees;
  const OrderPricingSection({
    Key? key,
    required this.itemsPrice,
    required this.addOns,
    required this.order,
    required this.subTotal,
    required this.discount,
    required this.couponDiscount,
    required this.tax,
    required this.dmTips,
    required this.deliveryCharge,
    required this.total,
    required this.orderController,
    this.orderId,
    this.contactNumber,
    this.service,
    this.fees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool subscription = order.subscription != null;
    bool taxIncluded = order.taxStatus ?? false;

    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ])
          : null,
      child: Column(children: [
        ResponsiveHelper.isDesktop(context)
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  itemCount: orderController.orderDetails!.length,
                  itemBuilder: (context, index) {
                    return OrderProductWidget(
                        order: order,
                        orderDetails: orderController.orderDetails![index]);
                  },
                ),
              ])
            : const SizedBox(),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [
            // Total
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('item_price'.tr, style: robotoRegular),
              Text(PriceConverter.convertPrice(itemsPrice),
                  style: robotoRegular, textDirection: TextDirection.ltr),
            ]),
            const SizedBox(height: 10),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('addons'.tr, style: robotoRegular),
              Text('(+) ${PriceConverter.convertPrice(addOns)}',
                  style: robotoRegular, textDirection: TextDirection.ltr),
            ]),

            Divider(
                thickness: 1,
                color: Theme.of(context).hintColor.withOpacity(0.5)),

            !subscription
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                            '${'subtotal'.tr} ${taxIncluded ? 'tax_included'.tr : ''}',
                            style: robotoMedium),
                        Text(PriceConverter.convertPrice(subTotal),
                            style: robotoMedium,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            SizedBox(height: !subscription ? Dimensions.paddingSizeSmall : 0),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('discount'.tr, style: robotoRegular),
              Text('(-) ${PriceConverter.convertPrice(discount)}',
                  style: robotoRegular, textDirection: TextDirection.ltr),
            ]),
            if (fees != 0) const SizedBox(height: Dimensions.paddingSizeSmall),
            if (fees != 0)
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('reservation_fees'.tr, style: robotoRegular),
                Text('(-) ${PriceConverter.convertPrice(fees)}',
                    style: robotoRegular, textDirection: TextDirection.ltr),
              ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            (order.additionalCharge != null && order.additionalCharge! > 0)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                            Get.find<SplashController>()
                                .configModel!
                                .additionalChargeName!,
                            style: robotoRegular),
                        Text(
                            '(+) ${PriceConverter.convertPrice(order.additionalCharge)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            (order.additionalCharge != null && order.additionalCharge! > 0)
                ? const SizedBox(height: 10)
                : const SizedBox(),

            couponDiscount > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('coupon_discount'.tr, style: robotoRegular),
                        Text(
                          '(-) ${PriceConverter.convertPrice(couponDiscount)}',
                          style: robotoRegular,
                          textDirection: TextDirection.ltr,
                        ),
                      ])
                : const SizedBox(),
            SizedBox(
                height: couponDiscount > 0 ? Dimensions.paddingSizeSmall : 0),

            !taxIncluded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('vat_tax'.tr, style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(tax)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            SizedBox(height: taxIncluded ? 0 : Dimensions.paddingSizeSmall),

            order.orderType != 'take_away'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text('service'.tr, style: robotoRegular),
                        Text('(+) ${PriceConverter.convertPrice(service)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr),
                      ])
                : const SizedBox(),
            SizedBox(
                height: order.orderType != 'take_away'
                    ? 0
                    : Dimensions.paddingSizeSmall),
            (!subscription &&
                    order.orderType != 'take_away' &&
                    Get.find<SplashController>().configModel!.dmTipsStatus == 1)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('delivery_man_tips'.tr, style: robotoRegular),
                      Text('(+) ${PriceConverter.convertPrice(dmTips)}',
                          style: robotoRegular,
                          textDirection: TextDirection.ltr),
                    ],
                  )
                : const SizedBox(),
            SizedBox(
                height: (order.orderType != 'take_away' &&
                        Get.find<SplashController>()
                                .configModel!
                                .dmTipsStatus ==
                            1)
                    ? 10
                    : 0),

            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              child: Divider(
                  thickness: 1,
                  color: Theme.of(context).hintColor.withOpacity(0.5)),
            ),

            order.paymentMethod == 'partial_payment'
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: DottedBorder(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 1,
                      strokeCap: StrokeCap.butt,
                      dashPattern: const [8, 5],
                      padding: const EdgeInsets.all(8),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(Dimensions.radiusDefault),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('total_amount'.tr,
                                  style: robotoMedium.copyWith(
                                    fontSize:
                                        ResponsiveHelper.isDesktop(context)
                                            ? Dimensions.fontSizeSmall
                                            : Dimensions.fontSizeDefault,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              Text(
                                PriceConverter.convertPrice(total),
                                textDirection: TextDirection.ltr,
                                style: robotoMedium.copyWith(
                                    fontSize:
                                        ResponsiveHelper.isDesktop(context)
                                            ? Dimensions.fontSizeSmall
                                            : Dimensions.fontSizeDefault,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ]),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('paid_by_wallet'.tr,
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
                              Text(
                                PriceConverter.convertPrice(
                                    order.payments?[0].amount ?? 0),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                            ]),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${order.payments?[1].paymentStatus == 'paid' ? 'paid_by'.tr : 'due_amount'.tr} (${order.payments?[1].paymentMethod?.toString().replaceAll('_', ' ')})',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                              Text(
                                PriceConverter.convertPrice(
                                    order.payments?[1].amount ?? 0),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                            ]),
                      ]),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(subscription ? 'subtotal'.tr : 'total_amount'.tr,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor,
                            )),
                        Text(
                          PriceConverter.convertPrice(total),
                          textDirection: TextDirection.ltr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor),
                        ),
                      ]),

            subscription
                ? Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('subscription_order_count'.tr,
                              style: robotoMedium),
                          Text(order.subscription!.quantity.toString(),
                              style: robotoMedium),
                        ]),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeSmall),
                      child: Divider(
                          thickness: 1,
                          color: Theme.of(context).hintColor.withOpacity(0.5)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total_amount'.tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            PriceConverter.convertPrice(
                                total * order.subscription!.quantity!),
                            textDirection: TextDirection.ltr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context).primaryColor),
                          ),
                        ]),
                  ])
                : const SizedBox(),
          ]),
        ),
        ResponsiveHelper.isDesktop(context)
            ? BottomViewWidget(
                orderController: orderController,
                order: order,
                orderId: orderId,
                total: total,
                contactNumber: contactNumber)
            : const SizedBox(),
      ]),
    );
  }
}
