import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/screens/my_points/model/redeem_model.dart';
import 'package:efood_multivendor/view/screens/my_points/widgets/redeem_card.dart';
import 'package:flutter/material.dart';

class RedeemSubscreen extends StatelessWidget {
  const RedeemSubscreen({
    super.key,
    required this.data,
    required this.isError,
    required this.callback,
  });
  final List<RedeemModel>? data;
  final bool isError;
  final Function(int) callback;

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return const Center(child: Text('Something went wrong'));
    }
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = data![index];
        return RedeemCard(item: item, callback: callback);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: Dimensions.paddingSizeSmall,
        );
      },
      itemCount: data!.length,
    );
  }
}
