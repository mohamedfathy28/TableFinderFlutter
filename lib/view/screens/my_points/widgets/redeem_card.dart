import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/screens/my_points/model/redeem_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RedeemCard extends StatelessWidget {
  const RedeemCard({
    super.key,
    required this.item,
    required this.callback,
  });

  final RedeemModel item;
  final Function(int) callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                // const SizedBox(
                //   height: Dimensions.paddingSizeSmall,
                // ),
                // Text(
                //   DateFormat.yMd().add_jm().format(item.date),
                //   style: robotoMedium.copyWith(
                //     fontSize: Dimensions.fontSizeDefault,
                //   ),
                // ),
              ],
            ),
            Column(
              children: [
                Text("${item.value} EGP"),
                // const SizedBox(
                //   height: Dimensions.paddingSizeSmall,
                // ),
                // Text("+${item.points}"),
              ],
            )
          ],
        ),
        const SizedBox(
          height: Dimensions.paddingSizeSmall,
        ),
        CustomButton(
          buttonText: "redeem".tr,
          onPressed: () => callback(item.id),
        ),
        const SizedBox(
          height: Dimensions.paddingSizeSmall,
        ),
        const Divider(),
      ],
    );
  }
}
