import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryInstructionView extends StatefulWidget {
  const DeliveryInstructionView({Key? key}) : super(key: key);

  @override
  State<DeliveryInstructionView> createState() => _DeliveryInstructionViewState();
}

class _DeliveryInstructionViewState extends State<DeliveryInstructionView> {
  ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      child: GetBuilder<OrderController>(
        builder: (orderController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ExpansionTile(
            //   key: widget.key,
            //   controller: controller,
            //   title: Text('add_more_delivery_instruction'.tr, style: robotoMedium),
            //   trailing:   Icon(orderController.isExpanded ? Icons.remove : Icons.add, size: 18),
            //   tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            //   onExpansionChanged: (value) => orderController.expandedUpdate(value),
            //
            //   children: [
            //
            //     ResponsiveHelper.isDesktop(context) ? GridView.builder(
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisSpacing: Dimensions.paddingSizeSmall,
            //         mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
            //         childAspectRatio: 3.5,
            //         crossAxisCount:  2,
            //       ),
            //       physics: const NeverScrollableScrollPhysics(),
            //       shrinkWrap: true,
            //       itemCount: AppConstants.deliveryInstructionList.length,
            //       padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            //       itemBuilder: (context, index) {
            //         bool isSelected = orderController.selectedInstruction == index;
            //         return InkWell(
            //           onTap: () {
            //             orderController.setInstruction(index);
            //           },
            //           child: Container(
            //             padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            //             decoration: BoxDecoration(
            //               color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.grey[200],
            //               borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            //               border: Border.all(color: isSelected ?  Theme.of(context).primaryColor : Colors.transparent),
            //             ),
            //             child: Row(
            //               children: [
            //                 Icon(Icons.ac_unit, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 18),
            //                 const SizedBox(width: Dimensions.paddingSizeSmall),
            //                 Expanded(
            //                   child: Text(
            //                     AppConstants.deliveryInstructionList[index].tr,
            //                     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     ) : ListView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: AppConstants.deliveryInstructionList.length,
            //         itemBuilder: (context, index){
            //           bool isSelected = orderController.selectedInstruction == index;
            //           return InkWell(
            //             onTap: () {
            //               orderController.setInstruction(index);
            //               if(controller.isExpanded) {
            //                 controller.collapse();
            //               }
            //             },
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.grey[200],
            //                 borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            //                 // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
            //               ),
            //               padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            //               margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            //               child: Row(children: [
            //                 Icon(Icons.ac_unit, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, size: 18),
            //                 const SizedBox(width: Dimensions.paddingSizeSmall),
            //
            //                 Expanded(
            //                   child: Text(
            //                     AppConstants.deliveryInstructionList[index].tr,
            //                     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
            //                   ),
            //                 ),
            //               ]),
            //
            //             ),
            //           );
            //         }),
            //   ],
            // ),

            orderController.selectedInstruction != -1 && !ResponsiveHelper.isDesktop(context) ? Padding(
              padding:  EdgeInsets.symmetric(vertical: orderController.isExpanded ? Dimensions.paddingSizeSmall : 0),
              child: Row(children: [
                Text(
                  AppConstants.deliveryInstructionList[orderController.selectedInstruction].tr,
                  style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
                ),

                InkWell(
                  onTap: ()=> orderController.setInstruction(-1),
                  child: const Icon(Icons.clear, size: 16),
                ),
              ])
            ) : const SizedBox(),
            SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

          ]);
        }
      ),
    );
  }
}
