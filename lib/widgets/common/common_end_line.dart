import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';

class CommonEndLine extends StatelessWidget {
  const CommonEndLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEEEEE),
      padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TDDivider(),
          ),
          Text(OpenIoTHubLocalizations.of(context).i_also_have_a_bottom_line),
          Expanded(
            flex: 1,
            child: TDDivider(),
          ),
        ],
      ),
    );
  }
}
