import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/delivery_man_body.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/helper/custom_validator.dart';
import 'package:efood_multivendor/helper/extensions.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_dropdown.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/base/footer_view.dart';
import 'package:efood_multivendor/view/base/menu_drawer.dart';
import 'package:efood_multivendor/view/base/web_header_skeleton.dart';
import 'package:efood_multivendor/view/base/web_page_title_widget.dart';
import 'package:efood_multivendor/view/screens/auth/widget/additional_data_section.dart';
import 'package:efood_multivendor/view/screens/auth/widget/pass_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryManRegistrationScreen extends StatefulWidget {
  const DeliveryManRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryManRegistrationScreen> createState() =>
      _DeliveryManRegistrationScreenState();
}

class _DeliveryManRegistrationScreenState
    extends State<DeliveryManRegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _identityNumberController =
      TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String? _countryDialCode;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode;
    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass();
    }
    Get.find<AuthController>().pickDmImage(false, true);
    Get.find<AuthController>().dmStatusChange(0.4, isUpdate: false);
    Get.find<AuthController>().validPassCheck('', isUpdate: false);
    Get.find<AuthController>().setIdentityTypeIndex(
        Get.find<AuthController>().identityTypeList[0], false);
    Get.find<AuthController>().setDMTypeIndex(0, false);
    Get.find<AuthController>().setVehicleIndex(0, false);
    Get.find<AuthController>().getZoneList();
    Get.find<AuthController>().getVehicleList();
    Get.find<AuthController>().initIdentityTypeIndex();
    Get.find<AuthController>()
        .setDeliverymanAdditionalJoinUsPageData(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      appBar: CustomAppBar(
        title: 'delivery_man_registration'.tr,
        onBackPressed: () {
          if (Get.find<AuthController>().dmStatus != 0.4) {
            Get.find<AuthController>().dmStatusChange(0.4);
          } else {
            Get.back();
          }
        },
      ),
      body: SafeArea(
        child: GetBuilder<AuthController>(builder: (authController) {
          List<int> zoneIndexList = [];
          List<DropdownItem<int>> zoneList = [];
          List<DropdownItem<int>> vehicleList = [];
          List<DropdownItem<int>> dmTypeList = [];
          List<DropdownItem<int>> identityTypeList = [];

          // dmTypeList.add(DropdownItem<int>(value: 0, child: SizedBox(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text('select_dm_type'.tr),
          //   ),
          // )));
          // identityTypeList.add(DropdownItem<int>(value: 0, child: SizedBox(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text('select_identity_type'.tr),
          //   ),
          // )));
          // zoneList.add(DropdownItem<int>(value: 0, child: SizedBox(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text('select_zone'.tr),
          //   ),
          // )));
          // vehicleList.add(DropdownItem<int>(value: 0, child: SizedBox(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text('select_vehicle_type'.tr),
          //   ),
          // )));

          for (int index = 0;
              index < authController.dmTypeList.length;
              index++) {
            dmTypeList.add(DropdownItem<int>(
                value: index,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${authController.dmTypeList[index]?.tr}'),
                  ),
                )));
          }
          for (int index = 0;
              index < authController.identityTypeList.length;
              index++) {
            identityTypeList.add(DropdownItem<int>(
                value: index,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(authController.identityTypeList[index].tr),
                  ),
                )));
          }
          if (authController.zoneList != null) {
            for (int index = 0;
                index < authController.zoneList!.length;
                index++) {
              zoneIndexList.add(index);
              zoneList.add(DropdownItem<int>(
                  value: index,
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${authController.zoneList![index].name}'.tr),
                    ),
                  )));
            }
          }
          if (authController.vehicles != null) {
            for (int index = 0;
                index < authController.vehicles!.length;
                index++) {
              vehicleList.add(DropdownItem<int>(
                  value: index,
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${authController.vehicles![index].type}'.tr),
                    ),
                  )));
            }
          }

          return ResponsiveHelper.isDesktop(context)
              ? webView(authController, zoneIndexList, dmTypeList, zoneList,
                  identityTypeList, vehicleList)
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      Text(
                        'complete_registration_process_to_serve_as_delivery_man_in_this_platform'
                            .tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      LinearProgressIndicator(
                        backgroundColor: Theme.of(context).disabledColor,
                        minHeight: 2,
                        value: authController.dmStatus,
                      ),
                      // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    ]),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context)
                        ? 0
                        : Dimensions.paddingSizeLarge),
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                        child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Visibility(
                                        visible: authController.dmStatus == 0.4,
                                        child: Column(children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .radiusDefault),
                                                      child: authController
                                                                  .pickedImage !=
                                                              null
                                                          ? GetPlatform.isWeb
                                                              ? Image.network(
                                                                  authController
                                                                      .pickedImage!
                                                                      .path,
                                                                  width: 150,
                                                                  height: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(authController
                                                                      .pickedImage!
                                                                      .path),
                                                                  width: 150,
                                                                  height: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                          : SizedBox(
                                                              width: 150,
                                                              height: 120,
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .photo_camera,
                                                                        size:
                                                                            38,
                                                                        color: Theme.of(context)
                                                                            .disabledColor),
                                                                    const SizedBox(
                                                                        height:
                                                                            Dimensions.paddingSizeSmall),
                                                                    Text(
                                                                      'upload_deliveryman_photo'
                                                                          .tr,
                                                                      style: robotoMedium.copyWith(
                                                                          color: Theme.of(context)
                                                                              .disabledColor,
                                                                          fontSize:
                                                                              Dimensions.fontSizeSmall),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ]),
                                                            ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      top: 0,
                                                      left: 0,
                                                      child: InkWell(
                                                        onTap: () =>
                                                            authController
                                                                .pickDmImage(
                                                                    true,
                                                                    false),
                                                        child: DottedBorder(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          strokeWidth: 1,
                                                          strokeCap:
                                                              StrokeCap.butt,
                                                          dashPattern: const [
                                                            5,
                                                            5
                                                          ],
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(
                                                              Dimensions
                                                                  .radiusDefault),
                                                          child: Visibility(
                                                            visible: authController
                                                                    .pickedImage !=
                                                                null,
                                                            child: Center(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        25),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .white),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .all(
                                                                    Dimensions
                                                                        .paddingSizeLarge),
                                                                child: const Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    authController
                                                                .pickedImage !=
                                                            null
                                                        ? Positioned(
                                                            bottom: -10,
                                                            right: -10,
                                                            child: InkWell(
                                                              onTap: () =>
                                                                  authController
                                                                      .removeDmImage(),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      width: 2),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error,
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .all(
                                                                    Dimensions
                                                                        .paddingSizeExtraSmall),
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  size: 18,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ])),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraLarge),
                                          Row(children: [
                                            Expanded(
                                                child: CustomTextField(
                                              titleText: 'first_name'.tr,
                                              controller: _fNameController,
                                              capitalization:
                                                  TextCapitalization.words,
                                              inputType: TextInputType.name,
                                              focusNode: _fNameNode,
                                              nextFocus: _lNameNode,
                                              prefixIcon: Icons.person,
                                            )),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeSmall),
                                            Expanded(
                                                child: CustomTextField(
                                              titleText: 'last_name'.tr,
                                              controller: _lNameController,
                                              capitalization:
                                                  TextCapitalization.words,
                                              inputType: TextInputType.name,
                                              focusNode: _lNameNode,
                                              nextFocus: _phoneNode,
                                              prefixIcon: Icons.person,
                                            )),
                                          ]),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraLarge),
                                          CustomTextField(
                                            titleText:
                                                ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? 'phone'.tr
                                                    : 'enter_phone_number'.tr,
                                            controller: _phoneController,
                                            focusNode: _phoneNode,
                                            nextFocus: _emailNode,
                                            inputType: TextInputType.phone,
                                            isPhone: true,
                                            onCountryChanged:
                                                (CountryCode countryCode) {
                                              _countryDialCode =
                                                  countryCode.dialCode;
                                            },
                                            countryDialCode: _countryDialCode != null
                                                ? CountryCode.fromCountryCode(
                                                        Get.find<
                                                                SplashController>()
                                                            .configModel!
                                                            .country!)
                                                    .code
                                                : Get.find<
                                                        LocalizationController>()
                                                    .locale
                                                    .countryCode,
                                          ),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraLarge),
                                          CustomTextField(
                                            titleText: 'email'.tr,
                                            controller: _emailController,
                                            focusNode: _emailNode,
                                            nextFocus: _passwordNode,
                                            inputType:
                                                TextInputType.emailAddress,
                                            prefixIcon: Icons.email,
                                          ),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraLarge),
                                          CustomTextField(
                                            titleText: 'password'.tr,
                                            controller: _passwordController,
                                            focusNode: _passwordNode,
                                            nextFocus: _confirmPasswordNode,
                                            inputType:
                                                TextInputType.visiblePassword,
                                            isPassword: true,
                                            prefixIcon: Icons.lock,
                                            onChanged: (value) {
                                              if (value != null &&
                                                  value.isNotEmpty) {
                                                if (!authController
                                                    .showPassView) {
                                                  authController.showHidePass();
                                                }
                                                authController
                                                    .validPassCheck(value);
                                              } else {
                                                if (authController
                                                    .showPassView) {
                                                  authController.showHidePass();
                                                }
                                              }
                                            },
                                          ),
                                          authController.showPassView
                                              ? const PassView()
                                              : const SizedBox(),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraLarge),
                                          CustomTextField(
                                            titleText: 'confirm_password'.tr,
                                            hintText: '',
                                            controller:
                                                _confirmPasswordController,
                                            focusNode: _confirmPasswordNode,
                                            inputAction: TextInputAction.done,
                                            inputType:
                                                TextInputType.visiblePassword,
                                            prefixIcon: Icons.lock,
                                            isPassword: true,
                                          ),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraLarge),
                                        ]),
                                      ),
                                      Visibility(
                                        visible: authController.dmStatus != 0.4,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 0.3)),
                                                    child: CustomDropdown<int>(
                                                      onChange: (int? value,
                                                          int index) {
                                                        authController
                                                            .setDMTypeIndex(
                                                                index, true);
                                                      },
                                                      dropdownButtonStyle:
                                                          DropdownButtonStyle(
                                                        height: 45,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: Dimensions
                                                              .paddingSizeExtraSmall,
                                                          horizontal: Dimensions
                                                              .paddingSizeExtraSmall,
                                                        ),
                                                        primaryColor:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color,
                                                      ),
                                                      dropdownStyle:
                                                          DropdownStyle(
                                                        elevation: 10,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                        padding: const EdgeInsets
                                                            .all(Dimensions
                                                                .paddingSizeExtraSmall),
                                                      ),
                                                      items: dmTypeList,
                                                      child: Text(authController
                                                          .dmTypeList[
                                                              authController
                                                                  .dmTypeIndex]!
                                                          .tr),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall),
                                                Expanded(
                                                    child: (authController
                                                                    .zoneList !=
                                                                null &&
                                                            authController
                                                                    .selectedZoneIndex !=
                                                                -1)
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                border: Border.all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    width:
                                                                        0.3)),
                                                            child:
                                                                CustomDropdown<
                                                                    int>(
                                                              onChange: (int?
                                                                      value,
                                                                  int index) {
                                                                authController
                                                                    .setZoneIndex(
                                                                        value);
                                                              },
                                                              dropdownButtonStyle:
                                                                  DropdownButtonStyle(
                                                                height: 45,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical:
                                                                      Dimensions
                                                                          .paddingSizeExtraSmall,
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeExtraSmall,
                                                                ),
                                                                primaryColor: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .color,
                                                              ),
                                                              dropdownStyle:
                                                                  DropdownStyle(
                                                                elevation: 10,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusDefault),
                                                                padding: const EdgeInsets
                                                                    .all(
                                                                    Dimensions
                                                                        .paddingSizeExtraSmall),
                                                              ),
                                                              items: zoneList,
                                                              child: Text(
                                                                  '${authController.zoneList![authController.selectedZoneIndex!].name}'
                                                                      .tr),
                                                            ),
                                                          )
                                                        : const Center(
                                                            child:
                                                                CircularProgressIndicator())),
                                              ]),

                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraLarge),

                                              authController.vehicleIds != null
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              width: 0.3)),
                                                      child:
                                                          CustomDropdown<int>(
                                                        onChange: (int? value,
                                                            int index) {
                                                          authController
                                                              .setVehicleIndex(
                                                                  index, true);
                                                        },
                                                        dropdownButtonStyle:
                                                            DropdownButtonStyle(
                                                          height: 45,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: Dimensions
                                                                .paddingSizeExtraSmall,
                                                            horizontal: Dimensions
                                                                .paddingSizeExtraSmall,
                                                          ),
                                                          primaryColor:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                        ),
                                                        dropdownStyle:
                                                            DropdownStyle(
                                                          elevation: 10,
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusDefault),
                                                          padding: const EdgeInsets
                                                              .all(Dimensions
                                                                  .paddingSizeExtraSmall),
                                                        ),
                                                        items: vehicleList,
                                                        child: Text(authController
                                                            .vehicles![
                                                                authController
                                                                    .vehicleIndex!]
                                                            .type!
                                                            .tr),
                                                      ),
                                                    )
                                                  : const CircularProgressIndicator(),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraLarge),

                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault),
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 0.3)),
                                                child: CustomDropdown<int>(
                                                  onChange:
                                                      (int? value, int index) {
                                                    authController
                                                        .setIdentityTypeIndex(
                                                            authController
                                                                    .identityTypeList[
                                                                index],
                                                            true);
                                                  },
                                                  dropdownButtonStyle:
                                                      DropdownButtonStyle(
                                                    height: 45,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall,
                                                      horizontal: Dimensions
                                                          .paddingSizeExtraSmall,
                                                    ),
                                                    primaryColor:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color,
                                                  ),
                                                  dropdownStyle: DropdownStyle(
                                                    elevation: 10,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault),
                                                    padding: const EdgeInsets
                                                        .all(Dimensions
                                                            .paddingSizeExtraSmall),
                                                  ),
                                                  items: identityTypeList,
                                                  child: Text(authController
                                                      .identityTypeList[
                                                          authController
                                                              .identityTypeIndex]
                                                      .tr),
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraLarge),

                                              CustomTextField(
                                                titleText: authController
                                                            .identityTypeIndex ==
                                                        0
                                                    ? 'Ex: XXXXX-XXXXXXX-X'
                                                    : authController
                                                                .identityTypeIndex ==
                                                            1
                                                        ? 'L-XXX-XXX-XXX-XXX.'
                                                        : 'XXX-XXXXX',
                                                controller:
                                                    _identityNumberController,
                                                focusNode: _identityNumberNode,
                                                inputAction:
                                                    TextInputAction.done,
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraLarge),

                                              ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: authController
                                                        .pickedIdentities
                                                        .length +
                                                    1,
                                                itemBuilder: (context, index) {
                                                  XFile? file = index ==
                                                          authController
                                                              .pickedIdentities
                                                              .length
                                                      ? null
                                                      : authController
                                                              .pickedIdentities[
                                                          index];
                                                  if (index ==
                                                      authController
                                                          .pickedIdentities
                                                          .length) {
                                                    return InkWell(
                                                      onTap: () =>
                                                          authController
                                                              .pickDmImage(
                                                                  false, false),
                                                      child: DottedBorder(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        strokeWidth: 1,
                                                        strokeCap:
                                                            StrokeCap.butt,
                                                        dashPattern: const [
                                                          5,
                                                          5
                                                        ],
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        borderType:
                                                            BorderType.RRect,
                                                        radius: const Radius
                                                            .circular(Dimensions
                                                                .radiusDefault),
                                                        child: SizedBox(
                                                          height: 120,
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    size: 38),
                                                                Text(
                                                                    'upload_identity_image'
                                                                        .tr,
                                                                    style: robotoMedium
                                                                        .copyWith(
                                                                            color:
                                                                                Theme.of(context).disabledColor)),
                                                              ]),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        bottom: Dimensions
                                                            .paddingSizeSmall),
                                                    child: DottedBorder(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      strokeWidth: 1,
                                                      strokeCap: StrokeCap.butt,
                                                      dashPattern: const [5, 5],
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      borderType:
                                                          BorderType.RRect,
                                                      radius: const Radius
                                                          .circular(Dimensions
                                                              .radiusDefault),
                                                      child: Stack(children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          child: GetPlatform
                                                                  .isWeb
                                                              ? Image.network(
                                                                  file!.path,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.file(
                                                                  File(file!
                                                                      .path),
                                                                  width: double
                                                                      .infinity,
                                                                  height: 120,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          top: 0,
                                                          child: InkWell(
                                                            onTap: () =>
                                                                authController
                                                                    .removeIdentityImage(
                                                                        index),
                                                            child:
                                                                const Padding(
                                                              padding: EdgeInsets
                                                                  .all(Dimensions
                                                                      .paddingSizeSmall),
                                                              child: Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  );
                                                },
                                              ),

                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraLarge),

                                              AdditionalDataSection(
                                                  authController:
                                                      authController,
                                                  scrollController:
                                                      _scrollController),

                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),

                                              //ConditionCheckBox(authController: authController, fromSignUp: true),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeLarge),
                                  (ResponsiveHelper.isDesktop(context) ||
                                          ResponsiveHelper.isWeb())
                                      ? buttonView()
                                      : const SizedBox(),
                                ]))),
                  )),
                  (ResponsiveHelper.isDesktop(context) ||
                          ResponsiveHelper.isWeb())
                      ? const SizedBox()
                      : buttonView(),
                ]);
        }),
      ),
    );
  }

  Widget webView(
      AuthController authController,
      List<int> zoneIndexList,
      List<DropdownItem<int>> typeList,
      List<DropdownItem<int>> zoneList,
      List<DropdownItem<int>> identityTypeList,
      List<DropdownItem<int>> vehicleList) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: FooterView(
        child: Center(
          child: Column(
            children: [
              WebScreenTitleWidget(title: 'join_as_a_delivery_man'.tr),
              SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(children: [
                          Text('delivery_man_registration'.tr,
                              style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            'complete_registration_process_to_serve_as_delivery_man_in_this_platform'
                                .tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Align(
                              alignment: Alignment.center,
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  child: authController.pickedImage != null
                                      ? GetPlatform.isWeb
                                          ? Image.network(
                                              authController.pickedImage!.path,
                                              width: 180,
                                              height: 180,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(authController
                                                  .pickedImage!.path),
                                              width: 180,
                                              height: 180,
                                              fit: BoxFit.cover,
                                            )
                                      : SizedBox(
                                          width: 180,
                                          height: 180,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera_alt,
                                                    size: 38,
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                Text(
                                                  'upload_deliveryman_photo'.tr,
                                                  style: robotoMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  top: 0,
                                  left: 0,
                                  child: InkWell(
                                    onTap: () =>
                                        authController.pickDmImage(true, false),
                                    child: DottedBorder(
                                      color: Theme.of(context).primaryColor,
                                      strokeWidth: 1,
                                      strokeCap: StrokeCap.butt,
                                      dashPattern: const [5, 5],
                                      padding: const EdgeInsets.all(0),
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(
                                          Dimensions.radiusDefault),
                                      child: Visibility(
                                        visible:
                                            authController.pickedImage != null,
                                        child: Center(
                                          child: Container(
                                            margin: const EdgeInsets.all(25),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeLarge),
                                            child: const Icon(Icons.camera_alt,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Row(children: [
                            Expanded(
                                child: CustomTextField(
                              titleText: 'first_name'.tr,
                              controller: _fNameController,
                              capitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              focusNode: _fNameNode,
                              nextFocus: _lNameNode,
                              prefixIcon: Icons.person,
                              showTitle: true,
                            )),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: CustomTextField(
                              titleText: 'last_name'.tr,
                              controller: _lNameController,
                              capitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              focusNode: _lNameNode,
                              nextFocus: _phoneNode,
                              prefixIcon: Icons.person,
                              showTitle: true,
                            )),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: CustomTextField(
                                titleText: 'phone'.tr,
                                controller: _phoneController,
                                focusNode: _phoneNode,
                                nextFocus: _emailNode,
                                inputType: TextInputType.phone,
                                isPhone: true,
                                showTitle: ResponsiveHelper.isDesktop(context),
                                onCountryChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                countryDialCode: _countryDialCode != null
                                    ? CountryCode.fromCountryCode(
                                            Get.find<SplashController>()
                                                .configModel!
                                                .country!)
                                        .code
                                    : Get.find<LocalizationController>()
                                        .locale
                                        .countryCode,
                              ),
                            ),
                          ]),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: CustomTextField(
                                  titleText: 'email'.tr,
                                  controller: _emailController,
                                  focusNode: _emailNode,
                                  nextFocus: _passwordNode,
                                  inputType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email,
                                  showTitle: true,
                                )),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Expanded(
                                    child: Column(
                                  children: [
                                    CustomTextField(
                                      titleText: 'password'.tr,
                                      controller: _passwordController,
                                      focusNode: _passwordNode,
                                      nextFocus: _confirmPasswordNode,
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.visiblePassword,
                                      isPassword: true,
                                      prefixIcon: Icons.lock,
                                      showTitle: true,
                                      onChanged: (value) {
                                        // authController.validPassCheck(value);
                                        if (value != null && value.isNotEmpty) {
                                          if (!authController.showPassView) {
                                            authController.showHidePass();
                                          }
                                          authController.validPassCheck(value);
                                        } else {
                                          if (authController.showPassView) {
                                            authController.showHidePass();
                                          }
                                        }
                                      },
                                    ),
                                    authController.showPassView
                                        ? const PassView()
                                        : const SizedBox(),
                                  ],
                                )),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Expanded(
                                    child: CustomTextField(
                                  titleText: 'confirm_password'.tr,
                                  hintText: '8_character'.tr,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordNode,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: Icons.lock,
                                  isPassword: true,
                                  showTitle: true,
                                ))
                              ]),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                        ),
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(children: [
                          Row(children: [
                            const Icon(Icons.person),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text('delivery_man_information'.tr,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall))
                          ]),
                          const Divider(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Row(children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('delivery_man_type'.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(
                                    height: Dimensions.paddingSizeDefault),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      color: Theme.of(context).cardColor,
                                      border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 0.3)),
                                  child: CustomDropdown<int>(
                                    onChange: (int? value, int index) {
                                      authController.setDMTypeIndex(
                                          index, true);
                                    },
                                    dropdownButtonStyle: DropdownButtonStyle(
                                      height: 45,
                                      padding: const EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.paddingSizeExtraSmall,
                                        horizontal:
                                            Dimensions.paddingSizeExtraSmall,
                                      ),
                                      primaryColor: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                    dropdownStyle: DropdownStyle(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault),
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeExtraSmall),
                                    ),
                                    items: typeList,
                                    child: Text(
                                        '${authController.dmTypeList[0]}'.tr),
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('zone'.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(
                                    height: Dimensions.paddingSizeDefault),
                                (authController.zoneList != null &&
                                        authController.zoneList!.isNotEmpty)
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            color: Theme.of(context).cardColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 0.3)),
                                        child: CustomDropdown<int>(
                                          onChange: (int? value, int index) {
                                            authController.setZoneIndex(value);
                                          },
                                          dropdownButtonStyle:
                                              DropdownButtonStyle(
                                            height: 45,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall,
                                              horizontal: Dimensions
                                                  .paddingSizeExtraSmall,
                                            ),
                                            primaryColor: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color,
                                          ),
                                          dropdownStyle: DropdownStyle(
                                            elevation: 10,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                            padding: const EdgeInsets.all(
                                                Dimensions
                                                    .paddingSizeExtraSmall),
                                          ),
                                          items: zoneList,
                                          child: Text(
                                              '${authController.zoneList![authController.selectedZoneIndex!].name}'
                                                  .tr),
                                        ),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator()),
                              ],
                            )),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('vehicle_type'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall)),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  (authController.vehicleIds != null &&
                                          authController.vehicleIds!.isNotEmpty)
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                              color:
                                                  Theme.of(context).cardColor,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 0.3)),
                                          child: CustomDropdown<int>(
                                            onChange: (int? value, int index) {
                                              authController.setVehicleIndex(
                                                  index, true);
                                            },
                                            dropdownButtonStyle:
                                                DropdownButtonStyle(
                                              height: 45,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .paddingSizeExtraSmall,
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall,
                                              ),
                                              primaryColor: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                            ),
                                            dropdownStyle: DropdownStyle(
                                              elevation: 10,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                            ),
                                            items: vehicleList,
                                            child: Text(authController
                                                .vehicles![authController
                                                    .vehicleIndex!]
                                                .type!
                                                .tr),
                                          ),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator()),
                                ],
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Row(children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('identity_type'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall)),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 0.3)),
                                    child: CustomDropdown<int>(
                                      onChange: (int? value, int index) {
                                        authController.setIdentityTypeIndex(
                                            authController
                                                .identityTypeList[index],
                                            true);
                                      },
                                      dropdownButtonStyle: DropdownButtonStyle(
                                        height: 45,
                                        padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.paddingSizeExtraSmall,
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall,
                                        ),
                                        primaryColor: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                      ),
                                      dropdownStyle: DropdownStyle(
                                        elevation: 10,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeExtraSmall),
                                      ),
                                      items: identityTypeList,
                                      child: Text(authController
                                          .identityTypeList[
                                              authController.identityTypeIndex]
                                          .tr),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: CustomTextField(
                              titleText: authController.identityTypeIndex == 1
                                  ? 'identity_number'.tr
                                  : authController.identityTypeIndex == 2
                                      ? 'driving_license_number'.tr
                                      : 'nid_number'.tr,
                              controller: _identityNumberController,
                              focusNode: _identityNumberNode,
                              inputAction: TextInputAction.done,
                              showTitle: true,
                            )),
                            const Expanded(child: SizedBox()),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  authController.pickedIdentities.length + 1,
                              itemBuilder: (context, index) {
                                XFile? file = index ==
                                        authController.pickedIdentities.length
                                    ? null
                                    : authController.pickedIdentities[index];
                                if (index ==
                                    authController.pickedIdentities.length) {
                                  return InkWell(
                                    onTap: () => authController.pickDmImage(
                                        false, false),
                                    child: DottedBorder(
                                      color: Theme.of(context).primaryColor,
                                      strokeWidth: 1,
                                      strokeCap: StrokeCap.butt,
                                      dashPattern: const [5, 5],
                                      padding: const EdgeInsets.all(5),
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(
                                          Dimensions.radiusDefault),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeDefault),
                                        child: Column(
                                          children: [
                                            Icon(Icons.camera_alt,
                                                color: Theme.of(context)
                                                    .disabledColor),
                                            Text('upload_identity_image'.tr,
                                                style: robotoMedium.copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                                textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: const EdgeInsets.only(
                                      right: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                  child: Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      child: GetPlatform.isWeb
                                          ? Image.network(
                                              file!.path,
                                              width: 150,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(file!.path),
                                              width: 150,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () => authController
                                            .removeIdentityImage(index),
                                        child: const Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          child: Icon(Icons.delete_forever,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeSmall),
                        child: Column(children: [
                          Row(children: [
                            const Icon(Icons.person),
                            Text('additional_information'.tr,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall))
                          ]),
                          const Divider(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          AdditionalDataSection(
                              authController: authController,
                              scrollController: _scrollController),
                        ]),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(
                                  color: Theme.of(context).hintColor)),
                          width: 165,
                          child: CustomButton(
                            transparent: true,
                            textColor: Theme.of(context).hintColor,
                            radius: Dimensions.radiusSmall,
                            onPressed: () {
                              _phoneController.text = '';
                              _emailController.text = '';
                              _fNameController.text = '';
                              _lNameController.text = '';
                              _lNameController.text = '';
                              _passwordController.text = '';
                              _confirmPasswordController.text = '';
                              _identityNumberController.text = '';
                              authController.resetDeliveryRegistration();
                              authController
                                  .setRestaurantAdditionalJoinUsPageData(
                                      isUpdate: true);
                            },
                            buttonText: 'reset'.tr,
                            isBold: false,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeLarge),
                        SizedBox(width: 165, child: buttonView()),
                      ]),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonView() {
    return GetBuilder<AuthController>(builder: (authController) {
      return CustomButton(
        isLoading: authController.isLoading,
        buttonText: (authController.dmStatus == 0.4 &&
                !ResponsiveHelper.isDesktop(context))
            ? 'next'.tr
            : 'submit'.tr,
        margin: EdgeInsets.all(
            (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb())
                ? 0
                : Dimensions.paddingSizeSmall),
        height: 50,
        onPressed: () async {
          if (authController.dmStatus == 0.4 &&
              !ResponsiveHelper.isDesktop(context)) {
            String fName = _fNameController.text.trim();
            String lName = _lNameController.text.trim();
            String email = _emailController.text.trim();
            String phone = _phoneController.text.trim();
            if (phone[0] == '0') {
              phone = phone.substring(1);
            }
            String password = _passwordController.text.trim();
            String confirmPassword = _confirmPasswordController.text.trim();
            String numberWithCountryCode = _countryDialCode! + phone;
            PhoneValid phoneValid =
                await CustomValidator.isPhoneValid(numberWithCountryCode);
            numberWithCountryCode = phoneValid.phone;

            if (authController.pickedImage == null) {
              showCustomSnackBar('upload_delivery_man_image'.tr);
            } else if (fName.isEmpty) {
              showCustomSnackBar('enter_delivery_man_first_name'.tr);
            } else if (lName.isEmpty) {
              showCustomSnackBar('enter_delivery_man_last_name'.tr);
            } else if (authController.pickedImage == null) {
              showCustomSnackBar('pick_delivery_man_profile_image'.tr);
            } else if (phone.isEmpty) {
              showCustomSnackBar('enter_delivery_man_phone_number'.tr);
            } else if (email.isEmpty) {
              showCustomSnackBar('enter_delivery_man_email_address'.tr);
            } else if (!GetUtils.isEmail(email)) {
              showCustomSnackBar('enter_a_valid_email_address'.tr);
            } else if (!phoneValid.isValid) {
              showCustomSnackBar('enter_a_valid_phone_number'.tr);
            } else if (password.isEmpty) {
              showCustomSnackBar('enter_password_for_delivery_man'.tr);
            } else if (password != confirmPassword) {
              showCustomSnackBar('confirm_password_does_not_matched'.tr);
            } else if (!authController.spatialCheck ||
                !authController.lowercaseCheck ||
                !authController.uppercaseCheck ||
                !authController.numberCheck ||
                !authController.lengthCheck) {
              showCustomSnackBar('provide_valid_password'.tr);
            } else {
              authController.dmStatusChange(0.8);
            }
          } else {
            _addDeliveryMan(authController);
          }
        },
      );
    });
  }

  void _addDeliveryMan(AuthController authController) async {
    String fName = _fNameController.text.trim();
    String lName = _lNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    if (phone[0] == '0') {
      phone = phone.substring(1);
    }
    String password = _passwordController.text.trim();
    String identityNumber = _identityNumberController.text.trim();
    String numberWithCountryCode = _countryDialCode! + phone;

    bool customFieldEmpty = false;

    Map<String, dynamic> additionalData = {};
    List<FilePickerResult> additionalDocuments = [];
    List<String> additionalDocumentsInputType = [];

    if (authController.dmStatus != 0.4) {
      for (DataModel data in authController.dataList!) {
        bool isTextField = data.fieldType == 'text' ||
            data.fieldType == 'number' ||
            data.fieldType == 'email' ||
            data.fieldType == 'phone';
        bool isDate = data.fieldType == 'date';
        bool isCheckBox = data.fieldType == 'check_box';
        bool isFile = data.fieldType == 'file';
        int index = authController.dataList!.indexOf(data);
        bool isRequired = data.isRequired == 1;

        if (isTextField) {
          if (kDebugMode) {
            print(
                '=====check text field : ${authController.additionalList![index].text == ''}');
          }
          if (authController.additionalList![index].text != '') {
            additionalData.addAll(
                {data.inputData!: authController.additionalList![index].text});
          } else {
            if (isRequired) {
              customFieldEmpty = true;
              showCustomSnackBar(
                  '${data.placeholderData} ${'can_not_be_empty'.tr}');
              break;
            }
          }
        } else if (isDate) {
          if (kDebugMode) {
            print('---check date : ${authController.additionalList![index]}');
          }
          if (authController.additionalList![index] != null) {
            additionalData.addAll(
                {data.inputData!: authController.additionalList![index]});
          } else {
            if (isRequired) {
              customFieldEmpty = true;
              showCustomSnackBar(
                  '${data.placeholderData} ${'can_not_be_empty'.tr}');
              break;
            }
          }
        } else if (isCheckBox) {
          List<String> checkData = [];
          bool noNeedToGoElse = false;
          for (var e in authController.additionalList![index]) {
            if (e != 0) {
              checkData.add(e);
              customFieldEmpty = false;
              noNeedToGoElse = true;
            } else if (!noNeedToGoElse) {
              customFieldEmpty = true;
            }
          }
          if (customFieldEmpty && isRequired) {
            showCustomSnackBar(
                '${'please_set_data_in'.tr} ${authController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()} ${'field'.tr}');
            break;
          } else {
            additionalData.addAll({data.inputData!: checkData});
          }
        } else if (isFile) {
          if (kDebugMode) {
            print('---check file : ${authController.additionalList![index]}');
          }
          if (authController.additionalList![index].length == 0 && isRequired) {
            customFieldEmpty = true;
            showCustomSnackBar(
                '${'please_add'.tr} ${authController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()}');
            break;
          } else {
            authController.additionalList![index].forEach((file) {
              additionalDocuments.add(file);
              additionalDocumentsInputType
                  .add(authController.dataList![index].inputData!);
            });
          }
        }
      }
    }

    if (ResponsiveHelper.isDesktop(context)) {
      PhoneValid phoneValid =
          await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      if (authController.pickedImage == null) {
        showCustomSnackBar('upload_delivery_man_image'.tr);
      } else if (fName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_first_name'.tr);
      } else if (lName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_last_name'.tr);
      } else if (authController.pickedImage == null) {
        showCustomSnackBar('pick_delivery_man_profile_image'.tr);
      } else if (phone.isEmpty) {
        showCustomSnackBar('enter_delivery_man_phone_number'.tr);
      } else if (email.isEmpty) {
        showCustomSnackBar('enter_delivery_man_email_address'.tr);
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar('enter_a_valid_email_address'.tr);
      } else if (!phoneValid.isValid) {
        showCustomSnackBar('enter_a_valid_phone_number'.tr);
      } else if (password.isEmpty) {
        showCustomSnackBar('enter_password_for_delivery_man'.tr);
      } else if (!authController.spatialCheck ||
          !authController.lowercaseCheck ||
          !authController.uppercaseCheck ||
          !authController.numberCheck ||
          !authController.lengthCheck) {
        showCustomSnackBar('provide_valid_password'.tr);
      }
    }

    if (authController.dmTypeIndex == 0) {
      showCustomSnackBar('please_select_deliveryman_type'.tr);
    } else if (authController.vehicleIndex == 0) {
      showCustomSnackBar('please_select_vehicle_for_the_deliveryman'.tr);
    } else if (authController.identityTypeIndex == 0) {
      showCustomSnackBar('please_select_identity_type_for_the_deliveryman'.tr);
    } else if (authController.selectedZoneIndex == 0) {
      showCustomSnackBar('please_select_zone_for_the_deliveryman'.tr);
    } else if (identityNumber.isEmpty) {
      showCustomSnackBar('enter_delivery_man_identity_number'.tr);
    } else if (authController.pickedIdentities.isEmpty) {
      showCustomSnackBar('please_select_identity_image'.tr);
    } else if (customFieldEmpty) {
      if (kDebugMode) {
        print('not provide addition data');
      }
    } else {
      Map<String, String> data = {};

      data.addAll(DeliveryManBody(
        fName: fName,
        lName: lName,
        password: password,
        phone: numberWithCountryCode,
        email: email,
        identityNumber: identityNumber,
        identityType:
            authController.identityTypeList[authController.identityTypeIndex],
        earning: authController.dmTypeIndex == 1 ? '1' : '0',
        zoneId: authController.zoneList![authController.selectedZoneIndex!].id
            .toString(),
        vehicleId: authController.vehicles![authController.vehicleIndex!].id
            .toString(),
      ).toJson());

      data.addAll({
        'additional_data': jsonEncode(additionalData),
      });

      if (kDebugMode) {
        print('-------final data-- :  $data');
      }

      authController.registerDeliveryMan(
          data, additionalDocuments, additionalDocumentsInputType);
    }
  }
}
