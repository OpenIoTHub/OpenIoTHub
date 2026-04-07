import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

class DeviceDetails extends StatefulWidget {
  final PortConfig portConfig;
  const DeviceDetails({super.key, required this.portConfig});

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
