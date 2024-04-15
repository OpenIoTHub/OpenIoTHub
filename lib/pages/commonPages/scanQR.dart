import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oktoast/oktoast.dart';
import 'package:openiothub/generated/l10n.dart';
import 'package:openiothub_api/api/IoTManager/GatewayManager.dart';
import 'package:openiothub_api/api/OpenIoTHub/SessionApi.dart';
import 'package:openiothub_grpc_api/google/protobuf/wrappers.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/common.pb.dart';
import 'package:openiothub_grpc_api/proto/manager/gatewayManager.pb.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

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
    );
  }

  //已经确认过可以添加，添加到我的账号
  _addToMyAccount(String gatewayId) async {
    try {
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
        StringValue gatewayJwt =
        await GatewayManager.GetGatewayJwtByGatewayUuid(gatewayId);
        _addToMySessionList(gatewayJwt.value, "Gateway-${DateTime.now()}");
      } else {
        showToast("添加网关到我的账户失败:${operationResponse.msg}");
      }
    } catch (exception) {
      showToast("添加网关失败：${exception}");
    }
  }

  Future _addToMySessionList(String token, name) async {
    SessionConfig config = SessionConfig();
    config.token = token;
    config.description = name;
    try {
      await SessionApi.createOneSession(config);
      showToast("添加网关成功！");
    } catch (exception) {
      showToast("登录失败：${exception}");
    }
  }
}
