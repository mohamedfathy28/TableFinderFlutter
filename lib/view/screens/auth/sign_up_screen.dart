import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/auth/widget/sign_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
    this.exitFromApp = false,
    this.backFromThis = false,
    this.isRes = false,
    this.resId,
    this.typeId,
    this.tableId,
    this.isWait = false,
  }) : super(key: key);

  final bool exitFromApp;
  final bool backFromThis;
  final bool isRes;
  final bool isWait;
  final int? resId;
  final int? typeId;
  final int? tableId;
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();

    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Colors.transparent
          : Theme.of(context).cardColor,
      body: SafeArea(
          child: Scrollbar(
        child: Center(
          child: Container(
            width: context.width > 700 ? 700 : context.width,
            padding: context.width > 700
                ? const EdgeInsets.all(40)
                : const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: context.width > 700
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  )
                : null,
            child: GetBuilder<AuthController>(builder: (authController) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveHelper.isDesktop(context)
                        ? Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.clear),
                            ),
                          )
                        : const SizedBox(),
                    Image.asset(Images.logo, width: 60),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Image.asset(Images.logoName, width: 100),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('sign_up'.tr,
                          style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge)),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    SignUpWidget(
                      exitFromApp: widget.exitFromApp,
                      backFromThis: widget.backFromThis,
                      isRes: widget.isRes,
                      isWait: widget.isWait,
                      resId: widget.resId,
                      typeId: widget.typeId,
                      tableId: widget.tableId,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      )),
    );
  }
}
