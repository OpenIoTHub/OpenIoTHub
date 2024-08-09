import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/pages/commonPages/scanned_barcode_label.dart';
import 'package:openiothub/pages/commonPages/scanner_error_widget.dart';
import 'package:openiothub_api/api/IoTManager/GatewayManager.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() =>
      _ScanQRPageState();
}

class _ScanQRPageState
    extends State<ScanQRPage> {
  final MobileScannerController controller = MobileScannerController();

  Widget _buildBarcodeOverlay() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized || !value.isRunning || value.error != null) {
          return const SizedBox();
        }

        return StreamBuilder<BarcodeCapture>(
          stream: controller.barcodes,
          builder: (context, snapshot) {
            final BarcodeCapture? barcodeCapture = snapshot.data;

            // No barcode.
            if (barcodeCapture == null || barcodeCapture.barcodes.isEmpty) {
              return const SizedBox();
            }

            final scannedBarcode = barcodeCapture.barcodes.first;

            // No barcode corners, or size, or no camera preview size.
            if (scannedBarcode.corners.isEmpty ||
                value.size.isEmpty ||
                barcodeCapture.size.isEmpty) {
              return const SizedBox();
            }

            return CustomPaint(
              painter: BarcodeOverlay(
                barcodeCorners: scannedBarcode.corners,
                barcodeSize: barcodeCapture.size,
                boxFit: BoxFit.contain,
                cameraPreviewSize: value.size,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildScanWindow(Rect scanWindowRect) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          painter: ScannerOverlay(scanWindowRect),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('扫描二维码')),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            fit: BoxFit.contain,
            scanWindow: scanWindow,
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
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
                        if (uri.queryParameters.containsKey("id")) {
                          String id = uri.queryParameters["id"]!;
                          _addToMyAccount(id);
                        } else {
                          showToast(
                              "不支持的二维码，path: ${uri.path},parameters:${uri.queryParameters}");
                        }
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
          _buildBarcodeOverlay(),
          _buildScanWindow(scanWindow),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: ScannedBarcodeLabel(barcodes: controller.barcodes),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcodeCorners,
    required this.barcodeSize,
    required this.boxFit,
    required this.cameraPreviewSize,
  });

  final List<Offset> barcodeCorners;
  final Size barcodeSize;
  final BoxFit boxFit;
  final Size cameraPreviewSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcodeCorners.isEmpty ||
        barcodeSize.isEmpty ||
        cameraPreviewSize.isEmpty) {
      return;
    }

    final adjustedSize = applyBoxFit(boxFit, cameraPreviewSize, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final double ratioWidth;
    final double ratioHeight;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      ratioWidth = barcodeSize.width / adjustedSize.destination.width;
      ratioHeight = barcodeSize.height / adjustedSize.destination.height;
    } else {
      ratioWidth = cameraPreviewSize.width / adjustedSize.destination.width;
      ratioHeight = cameraPreviewSize.height / adjustedSize.destination.height;
    }

    final List<Offset> adjustedOffset = [
      for (final offset in barcodeCorners)
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
    ];

    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//已经确认过可以添加，添加到我的账号
_addToMyAccount(String gatewayId) async {
  try {
    // TODO 可以搞一个确认步骤，确认后添加
    // 使用扫描的Gateway ID构建一个GatewayInfo用于服务器添加
    GatewayInfo gatewayInfo = GatewayInfo(
        gatewayUuid: gatewayId,
        name: "Gateway-${DateTime.now()}",
        description: "Gateway-${DateTime.now()} form scan QR code");
    OperationResponse operationResponse =
    await GatewayManager.AddGateway(gatewayInfo);
    //将网关映射到本机
    if (operationResponse.code == 0) {
      // TODO 从服务器获取连接JWT
      StringValue openIoTHubJwt =
      await GatewayManager.GetOpenIoTHubJwtByGatewayUuid(gatewayId);
      await _addToMySessionList(
          openIoTHubJwt.value, "Gateway-${DateTime.now()}", "Gateway-${DateTime.now()} form scan QR code");
    } else {
      showToast("添加网关到我的账户失败:${operationResponse.msg}");
    }
  } catch (exception) {
    showToast("添加网关失败：${exception}");
  }
}

Future _addToMySessionList(String token, name, description) async {
  SessionConfig config = SessionConfig();
  config.token = token;
  config.name = name;
  config.description = description;
  try {
    await SessionApi.createOneSession(config);
    showToast("添加网关成功！");
  } catch (exception) {
    showToast("登录失败：${exception}");
  }
}
