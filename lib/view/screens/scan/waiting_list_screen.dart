import 'dart:async';
import 'dart:convert';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/auth/widget/auth_dialog.dart';
import 'package:efood_multivendor/view/screens/home/widget/new/all_populer_restaurant_filter_button.dart';
import 'package:efood_multivendor/view/screens/scan/models/reservation_config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WaitingListScreen extends StatefulWidget {
  final int restaurantId;
  const WaitingListScreen({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<WaitingListScreen> createState() => _WaitingListScreenState();
}

class _WaitingListScreenState extends State<WaitingListScreen> {
  // final _nameController = TextEditingController();
  // final _phoneController = TextEditingController();
  final _countController = TextEditingController();

  // final _nameFocus = FocusNode();
  // final _phoneFocus = FocusNode();
  final _countFocus = FocusNode();
  String? resName;
  String? resLogo;
  List<DataItemModel> areas = [];
  bool checkedLogin = false;

  DataItemModel? smoking;

  _checkLogin() {
    if (checkedLogin) return;
    if (!Get.find<AuthController>().isLoggedIn()) {
      if (ResponsiveHelper.isDesktop(context)) {
        Get.dialog(AuthDialog(
          exitFromApp: false,
          backFromThis: false,
          isWait: true,
          resId: widget.restaurantId,
        ));
      } else {
        Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
      }
    }
    Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      checkedLogin = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLogo();
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        setState(() {});
      },
    );
  }

  _getLogo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(AppConstants.token);
    final res = await http.get(
        Uri.parse(
            "${AppConstants.baseUrl}${AppConstants.getResLogo}?id=${widget.restaurantId.toString()}"),
        headers: {
          "Authorization": "Bearer $token",
        });
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        resName = body['name'];
        resLogo = body['logo'];
        final status = body['status'];
        if (!status) {
          showCustomSnackBar("Restaurant isn't subscribed yet");
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }
        areas = List<DataItemModel>.from(
          body['area_selection'].map(
            (x) => DataItemModel.fromJson(x),
          ),
        );
        DataItemModel.fromJson(body["area_selection"]);
      });
    }
  }

  _saveData() async {
    // if (_nameController.text.isEmpty) {
    //   showCustomSnackBar("Enter name");
    //   return;
    // }
    // if (_phoneController.text.isEmpty) {
    //   showCustomSnackBar("Enter phone");
    //   return;
    // }
    if (_countController.text.isEmpty) {
      showCustomSnackBar("Enter number of guest");
      return;
    }
    setState(() {
      isLoading = true;
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(AppConstants.token);

    final body = {
      // "name": _nameController.text,
      // "phone": _phoneController.text,
      "number_of_guest": _countController.text,
      "restaurant_id": widget.restaurantId.toString(),
      "smoking": smoking?.id,
    };
    final res = await http.post(
      Uri.parse("${AppConstants.baseUrl}${AppConstants.waitingListUri}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) {
      setState(() {
        isDone = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        Get.toNamed(RouteHelper.initial);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isDone = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // _checkLogin();

    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      body: !isLoggedIn
          ? NotLoggedInScreen(
              callBack: (value) {
                _getLogo();
                setState(() {});
              },
              isWait: true,
              resId: widget.restaurantId,
            )
          : Center(
              child: isDone
                  ? const Text(
                      "Saved successfully",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : (isLoading || resLogo == null || resName == null)
                      ? const CircularProgressIndicator()
                      : Container(
                          width: context.width > 700 ? 500 : context.width,
                          padding: context.width > 700
                              ? const EdgeInsets.all(50)
                              : const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraLarge),
                          margin: context.width > 700
                              ? const EdgeInsets.all(50)
                              : EdgeInsets.zero,
                          decoration: context.width > 700
                              ? BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  boxShadow: ResponsiveHelper.isDesktop(context)
                                      ? null
                                      : [
                                          BoxShadow(
                                              color: Colors.grey[
                                                  Get.isDarkMode ? 700 : 300]!,
                                              blurRadius: 5,
                                              spreadRadius: 1)
                                        ],
                                )
                              : null,
                          child: SingleChildScrollView(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Join Waitinglist",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // Text(
                                //   "Customer name".toUpperCase(),
                                //   style: const TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // CustomTextField(
                                //   // titleText: "Name",
                                //   hintText: " ",
                                //   controller: _nameController,
                                //   focusNode: _nameFocus,
                                //   inputType: TextInputType.name,
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Text(
                                  "Area Selection".toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                PopupMenuButton<DataItemModel>(
                                  itemBuilder: (context) {
                                    return areas
                                        .map(
                                          (e) => PopupMenuItem(
                                            value: e,
                                            textStyle: robotoMedium.copyWith(
                                              color: smoking?.id == e.id
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color
                                                  : Theme.of(context)
                                                      .disabledColor,
                                            ),
                                            child: Text(e.name),
                                          ),
                                        )
                                        .toList();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall)),
                                  child: AllPopularRestaurantsFilterButton(
                                    buttonText: smoking == null
                                        ? "Select Area"
                                        : smoking!.name,
                                  ),
                                  onSelected: (value) => setState(() {
                                    smoking = value;
                                  }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "No. of people".toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomTextField(
                                            hintText: " ",
                                            controller: _countController,
                                            focusNode: _countFocus,
                                            inputType: const TextInputType
                                                .numberWithOptions(
                                                signed: true, decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            inputAction: TextInputAction.done,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomButton(
                                  buttonText: "Save",
                                  onPressed: () {
                                    _saveData();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
            ),
    );
  }
}
