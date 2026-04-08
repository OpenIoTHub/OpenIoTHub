import 'package:flutter/material.dart';
import 'package:openiothub/pages/guide/guide_widget.dart';
import 'package:openiothub/utils/openiothub_desktop_layout.dart';

import '../../l10n/generated/openiothub_localizations.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key, required this.activeIndex});
  final int activeIndex;
  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(OpenIoTHubLocalizations.of(context).user_guide),),
      body: openIoTHubDesktopScrollableListBody(
        maxWidth: 920,
        scrollable: SingleChildScrollView(
          child: GuideWidget(activeIndex: widget.activeIndex),
        ),
      ),
    );
  }
}
