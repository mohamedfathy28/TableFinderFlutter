import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_dropdown.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/location/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class DeliverySection extends StatefulWidget {
  final OrderController orderController;
  final RestaurantController restController;
  final LocationController locationController;
  final TextEditingController guestNameTextEditingController;
  final TextEditingController guestNumberTextEditingController;
  final TextEditingController guestEmailController;
  final FocusNode guestNumberNode;
  final FocusNode guestEmailNode;
  const DeliverySection(
      {Key? key,
      required this.orderController,
      required this.restController,
      required this.locationController,
      required this.guestNameTextEditingController,
      required this.guestNumberTextEditingController,
      required this.guestNumberNode,
      required this.guestEmailController,
      required this.guestEmailNode})
      : super(key: key);

  @override
  State<DeliverySection> createState() => _DeliverySectionState();
}

class _DeliverySectionState extends State<DeliverySection> {
  final carNumbersController = TextEditingController();
  final carColorController = TextEditingController();
  final carTypeController = TextEditingController();
  final tableNumbersController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();
    bool takeAway = (widget.orderController.orderType == 'take_away');
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    GlobalKey<CustomDropdownState> dropDownKey =
        GlobalKey<CustomDropdownState>();
    AddressModel addressModel;

    return Column(children: [
      takeAway
          ? Container(
              margin: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault,
                vertical: 10,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? Dimensions.paddingSizeLarge
                      : Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 2))
                ],
              ),
              child: carOrRestaurant(context),
            )
          : const SizedBox.shrink(),
      (takeAway && selectIndex == 1)
          ? Container(
              margin: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault,
                vertical: 10,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? Dimensions.paddingSizeLarge
                      : Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 2))
                ],
              ),
              child: Column(
                children: [
                  // "car_number": "رقم السيارة",
                  // "enter_car_number": "ادخل رقم السيارة",
                  // "car_color": "لون السيارة",
                  // "enter_car_color": "ادخل لون السيارة",
                  // "car_type": "نوع السيارة",
                  // "enter_car_type": "ادخل نوع السيارة"
                  CustomTextField(
                    showTitle: true,
                    titleText: "car_number".tr,
                    hintText: 'enter_car_number'.tr,
                    inputType: TextInputType.name,
                    controller: carNumbersController,
                    capitalization: TextCapitalization.words,
                    onChanged: (value) {
                      Get.find<OrderController>().carLicencePlate = value;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    showTitle: true,
                    titleText: "car_color".tr,
                    hintText: 'enter_car_color'.tr,
                    inputType: TextInputType.name,
                    controller: carColorController,
                    capitalization: TextCapitalization.words,
                    onChanged: (value) {
                      Get.find<OrderController>().carColor = value;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    showTitle: true,
                    titleText: "car_type".tr,
                    hintText: 'enter_car_type'.tr,
                    inputType: TextInputType.name,
                    controller: carTypeController,
                    capitalization: TextCapitalization.words,
                    onChanged: (value) {
                      Get.find<OrderController>().carType = value;
                    },
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
      (!takeAway && Get.find<OrderController>().tableIdMethod == null)
          ? Container(
              margin: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault,
                vertical: 10,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? Dimensions.paddingSizeLarge
                      : Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 2))
                ],
              ),
              child: CustomTextField(
                showTitle: true,
                titleText: "Table Number",
                hintText: 'Enter Table number',
                inputType: TextInputType.number,
                controller: tableNumbersController,
                capitalization: TextCapitalization.words,
                onChanged: (value) {
                  print("onChanged value $value");
                  Get.find<OrderController>().tableNumber = value;
                  print(
                      "onChanged value ${Get.find<OrderController>().tableNumber}");
                },
              ),
            )
          : const SizedBox.shrink(),
      // isGuestLoggedIn
      //     ? GuestDeliveryAddress(
      //         orderController: widget.orderController,
      //         restController: widget.restController,
      //         guestNumberNode: widget.guestNumberNode,
      //         guestNameTextEditingController:
      //             widget.guestNameTextEditingController,
      //         guestNumberTextEditingController:
      //             widget.guestNumberTextEditingController,
      //         guestEmailController: widget.guestEmailController,
      //         guestEmailNode: widget.guestEmailNode,
      //       )
      //     : const SizedBox.shrink(),
      // !takeAway ? Container(
      //   margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
      //   padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).cardColor,
      //     borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      //     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
      //   ),
      //   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //       Text('deliver_to'.tr, style: robotoMedium),
      //       InkWell(
      //         onTap: () async{
      //           dropDownKey.currentState?.toggleDropdown();
      //         },
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
      //           child: Icon(Icons.arrow_drop_down, size: 34, color: Theme.of(context).primaryColor),
      //         ),
      //       ),
      //     ]),
      //
      //
      //     Container(
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      //           color: Colors.transparent,
      //           border: Border.all(color: Colors.transparent)
      //       ),
      //       child: CustomDropdown<int>(
      //         key: dropDownKey,
      //         hideIcon: true,
      //         onChange: (int? value, int index) async {
      //
      //           if(value == -1) {
      //             var address = await Get.toNamed(RouteHelper.getAddAddressRoute(true, restController.restaurant!.zoneId));
      //             if(address != null) {
      //
      //               restController.insertAddresses(Get.context!, address, notify: true);
      //
      //               orderController.streetNumberController.text = address.road ?? '';
      //               orderController.houseController.text = address.house ?? '';
      //               orderController.floorController.text = address.floor ?? '';
      //
      //               orderController.getDistanceInMeter(
      //                 LatLng(double.parse(address.latitude), double.parse(address.longitude )),
      //                 LatLng(double.parse(restController.restaurant!.latitude!), double.parse(restController.restaurant!.longitude!)),
      //               );
      //             }
      //           } else if(value == -2) {
      //             _checkPermission(() async {
      //               addressModel = await locationController.getCurrentLocation(true, mapController: null, showSnackBar: true);
      //
      //               if(addressModel.zoneIds!.isNotEmpty) {
      //
      //                 restController.insertAddresses(Get.context!, addressModel, notify: true);
      //
      //                 orderController.getDistanceInMeter(
      //                   LatLng(
      //                     locationController.position.latitude, locationController.position.longitude,
      //                   ),
      //                   LatLng(double.parse(restController.restaurant!.latitude!), double.parse(restController.restaurant!.longitude!)),
      //                 );
      //               }
      //             });
      //
      //           } else{
      //             orderController.getDistanceInMeter(
      //               LatLng(
      //                 double.parse(restController.address[value!].latitude!),
      //                 double.parse(restController.address[value].longitude!),
      //               ),
      //               LatLng(double.parse(restController.restaurant!.latitude!), double.parse(restController.restaurant!.longitude!)),
      //             );
      //             orderController.setAddressIndex(value);
      //
      //             orderController.streetNumberController.text = restController.address[value].road ?? '';
      //             orderController.houseController.text = restController.address[value].house ?? '';
      //             orderController.floorController.text = restController.address[value].floor ?? '';
      //           }
      //
      //         },
      //         dropdownButtonStyle: DropdownButtonStyle(
      //           height: 0, width: double.infinity,
      //           padding: EdgeInsets.zero,
      //           backgroundColor: Colors.transparent,
      //           primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
      //         ),
      //         dropdownStyle: DropdownStyle(
      //           elevation: 10,
      //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      //           padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      //         ),
      //         items: restController.addressList,
      //         child: const SizedBox(),
      //
      //       ),
      //     ),
      //     Container(
      //       constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? 90 : 75),
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      //           color: Theme.of(context).primaryColor.withOpacity(0.1),
      //           border: Border.all(color: Theme.of(context).primaryColor)
      //       ),
      //       child: AddressWidget(
      //         address: (restController.address.length-1) >= orderController.addressIndex ? restController.address[orderController.addressIndex] : restController.address[0],
      //         fromAddress: false, fromCheckout: true,
      //       ),
      //     ),
      //
      //     SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeDefault),
      //
      //     !ResponsiveHelper.isDesktop(context) ? CustomTextField(
      //       titleText: 'street_number'.tr,
      //       inputType: TextInputType.streetAddress,
      //       focusNode: orderController.streetNode,
      //       nextFocus: orderController.houseNode,
      //       controller: orderController.streetNumberController,
      //     ) : const SizedBox(),
      //     SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
      //
      //     Row(
      //       children: [
      //         ResponsiveHelper.isDesktop(context) ? Expanded(
      //           child: CustomTextField(
      //             titleText: 'street_number'.tr,
      //             inputType: TextInputType.streetAddress,
      //             focusNode: orderController.streetNode,
      //             nextFocus: orderController.houseNode,
      //             controller: orderController.streetNumberController,
      //             showTitle: ResponsiveHelper.isDesktop(context),
      //           ),
      //         ) : const SizedBox(),
      //         SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),
      //
      //         Expanded(
      //           child: CustomTextField(
      //             titleText: 'house'.tr,
      //             inputType: TextInputType.text,
      //             focusNode: orderController.houseNode,
      //             nextFocus: orderController.floorNode,
      //             controller: orderController.houseController,
      //             showTitle: ResponsiveHelper.isDesktop(context),
      //           ),
      //         ),
      //         const SizedBox(width: Dimensions.paddingSizeSmall),
      //
      //         Expanded(
      //           child: CustomTextField(
      //             titleText: 'floor'.tr,
      //             inputType: TextInputType.text,
      //             focusNode: orderController.floorNode,
      //             inputAction: TextInputAction.done,
      //             controller: orderController.floorController,
      //             showTitle: ResponsiveHelper.isDesktop(context),
      //           ),
      //         ),
      //       ],
      //     ),
      //     const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      //
      //   ]),
      // ) : const SizedBox(),
    ]);
  }

  int selectIndex = 0;

  Widget carOrRestaurant(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildbutton(context, 0, 'self_delivery'.tr, selectIndex == 0),
        _buildbutton(context, 1, 'drive_thru'.tr, selectIndex == 1),
      ],
    );
  }

  Row _buildbutton(
      BuildContext context, int value, String title, bool isSelected) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: selectIndex,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (val) {
            Get.find<OrderController>().takeAwayType = value + 1;
            setState(() {
              selectIndex = val ?? 0;
            });
          },
          activeColor: Theme.of(context).primaryColor,
          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Text(title,
            style: robotoMedium.copyWith(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyMedium!.color)),
      ],
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    } else {
      onTap();
    }
  }
}
