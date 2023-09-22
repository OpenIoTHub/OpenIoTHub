import 'package:flutter/material.dart';

class CommonEndLine extends StatelessWidget {
  const CommonEndLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEEEEE),
      padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),
      child: const Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Divider(
              height: 10.0,
            ),
          ),
          Text("我也是有底线的"),
          Expanded(
            flex: 1,
            child: Divider(
              height: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
