import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/my_points/model/spent_model.dart';
import 'package:flutter/material.dart';

class SpentCard extends StatelessWidget {
  const SpentCard({
    super.key,
    required this.item,
  });

  final SpentModel item;

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
                const SizedBox(
                  height: Dimensions.paddingSizeSmall,
                ),
                Text(
                  item.date,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text("${item.amount} EGP"),
                const SizedBox(
                  height: Dimensions.paddingSizeSmall,
                ),
                Text("+${item.points}"),
              ],
            )
          ],
        ),
        const SizedBox(
          height: Dimensions.paddingSizeSmall,
        ),
        const Divider(),
      ],
    );
  }
}
