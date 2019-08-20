import '../iotDeviceModel.dart';
import './devices.dart';

class ModelsMap {
  static Map<String, dynamic> modelsMap = Map.from({
    "com.iotserv.devices.one-key-switch": (IoTDevice device) {
      return OneKeySwitchPage(
        device: device,
      );
    },
    "com.iotserv.devices.phicomm_dc1": (IoTDevice device) {
      return PhicommDC1PluginPage(
        device: device,
      );
    },
  });
}
