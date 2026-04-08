import 'package:flutter/material.dart';
import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:openiothub/utils/app/openiothub_desktop_layout.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(OpenIoTHubLocalizations.of(context).nas_terminal),
        ),
        body: openIoTHubDesktopScrollableListBody(
          scrollable: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [],
            ),
          ),
        ),
    );
  }
}
