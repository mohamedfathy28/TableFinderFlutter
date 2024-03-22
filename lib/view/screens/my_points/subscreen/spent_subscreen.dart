import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/screens/my_points/model/spent_model.dart';
import 'package:efood_multivendor/view/screens/my_points/widgets/spent_card.dart';
import 'package:flutter/material.dart';

class SpentSubscreen extends StatelessWidget {
  const SpentSubscreen({
    super.key,
    required this.data,
    required this.isError,
  });
  final List<SpentModel>? data;
  final bool isError;

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
        return SpentCard(item: item);
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
