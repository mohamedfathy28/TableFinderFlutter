import 'dart:io';

import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  static void navigate(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ScanScreen()),
      );

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  bool calledOnResult = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR code"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!calledOnResult) {
        final url = scanData.code;
        print("asldfkjasdlfkvj qr code scan ============> $url");
        final uri = Uri.parse(url ?? "");
        if (uri.isAbsolute) {
          await Get.offAndToNamed(url!.split(uri.host).last);
        } else {
          showCustomSnackBar("Invalid QR code");
        }

        calledOnResult = true;
      }
    });
  }

  // Widget _buildFlashlightBtn() {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Container(
  //       width: 100,
  //       height: 100,
  //       decoration: const BoxDecoration(
  //         color: Colors.orange,
  //         borderRadius: BorderRadius.all(Radius.circular(1000)),
  //       ),
  //       margin: const EdgeInsets.all(10),
  //       child: IconButton(
  //         icon: Icon(
  //           flashlightOn ? Icons.flashlight_off : Icons.flashlight_on,
  //           color: Colors.white,
  //           size: 50,
  //         ),
  //         onPressed: () async {
  //           await controller.toggleTorch();
  //           setState(() {
  //             flashlightOn = !flashlightOn;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  // bool navFinished = true;

//   Widget _buildScanner(BuildContext context) {
//     return MobileScanner(
//       controller: controller,
//       onDetect: (barcode) async {
//         final url = barcode.barcodes[0].displayValue ?? "";
//         print("qr code scan ============> $url");
//         final uri = Uri.parse(url);
//         if (uri.isAbsolute) {
//           if (navFinished) {
//             navFinished = false;
//             await Get.offAndToNamed(url.split(uri.host).last);
//             navFinished = true;
//           }
//         } else {
//           showCustomSnackBar("Invalid QR code");
//         }
//
//         // RouteHelper.getWaitingListRoute(navigateTo)
//         // print("value2: ${barcode.barcodes[0].rawValue}");
//         // Navigator.of(context).pop(barcode.barcodes[0].rawValue);
//
// // TODO (abdelaziz): Go to enter information
//       },
//     );
//   }
}
