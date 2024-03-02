import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oktoast/oktoast.dart';

import 'package:openiothub/generated/l10n.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.scan_QR),
        actions: [
          IconButton(
            // color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            // color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          // final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            // debugPrint('Barcode found! ${barcode.rawValue}');
            // showToast('Barcode found!len:${barcodes.length},this value: ${barcode.rawValue}');
            //根据扫码内容做不同的操作
            if (barcode.rawValue == null) {
              continue;
            }
            Uri? uri = Uri.tryParse(barcode.rawValue!);
            if (uri == null) {
              continue;
            }
            // UriData uriData = UriData.fromUri(uri);
            // Map<String, String> parameters = uriData.parameters;
            // showToast("parameters:$parameters");
            switch (uri.host) {
              case "iothub.cloud":
                switch (uri.path) {
                  case "/a/g":
                    // TODO 添加网关
                    showToast(
                        "path: ${uri.path},parameters:${uri.queryParameters}");
                    break;
                  default:
                    showToast("不支持的Uri路径");
                    break;
                }
                break;
              default:
                showToast("不支持的二维码");
            }
          }
        },
      ),
    );
  }
}
