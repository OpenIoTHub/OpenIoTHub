import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openiothub_constants/constants/Constants.dart';
import 'package:openiothub_grpc_api/proto/mobile/mobile.pb.dart';

class PortConfigDetails extends StatefulWidget {
  final PortConfig portConfig;
  const PortConfigDetails({required this.portConfig});

  @override
  State<PortConfigDetails> createState() => _PortConfigDetailsState();
}

class _PortConfigDetailsState extends State<PortConfigDetails> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
