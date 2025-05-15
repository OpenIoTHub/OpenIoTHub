import 'package:flutter/material.dart';
import 'package:openiothub/pages/guide/guideWidget.dart';

import '../../l10n/generated/openiothub_localizations.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(OpenIoTHubLocalizations.of(context).user_guide),),
      body: GuideWidget(),
    );
  }
}
