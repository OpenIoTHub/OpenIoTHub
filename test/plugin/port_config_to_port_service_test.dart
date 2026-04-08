import 'package:flutter_test/flutter_test.dart';
import 'package:openiothub/core/config/config.dart';
import 'package:openiothub/utils/plugin/port_config_to_port_service.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

void main() {
  test('portConfig2portService merges mDNS info and uses tunnel endpoint', () {
    final device = Device()
      ..runId = 'run-1'
      ..addr = '10.0.0.2';
    final mdns = PortService()
      ..info['model'] = '_http._tcp'
      ..info['name'] = 'HomeSvc';
    final pc = PortConfig(
      device: device,
      localProt: 18080,
      mDNSInfo: mdns,
    );

    final psi = portConfig2portService(pc);

    expect(psi.port, 18080);
    expect(psi.isLocal, isFalse);
    expect(psi.runId, 'run-1');
    expect(psi.realAddr, '10.0.0.2');
    expect(psi.addr, Config.webgRpcIp);
    expect(psi.info!['model'], '_http._tcp');
    expect(psi.info!['name'], 'HomeSvc');
  });
}
