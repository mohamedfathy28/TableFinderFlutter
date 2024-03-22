import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/my_points/model/awarded_model.dart';
import 'package:flutter/material.dart';

class AwardedCard extends StatelessWidget {
  const AwardedCard({
    super.key,
    required this.item,
  });

  final AwardedModel item;

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
                  item.order_number,
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
            Text("+${item.points}")
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
