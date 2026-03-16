import 'package:flutter/material.dart';
import 'package:openiothub/common_pages/openiothub_common_pages.dart';
import 'package:openiothub/core/openiothub_constants.dart';
import 'package:openiothub/router/app_routes.dart';
import 'package:openiothub/router/app_navigator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../l10n/generated/openiothub_localizations.dart';

class GuideWidget extends StatefulWidget {
  const GuideWidget({super.key, required this.activeIndex});

  final int activeIndex;

  @override
  State<GuideWidget> createState() => _GuideWidgetState();
}

class _GuideWidgetState extends State<GuideWidget> {
  int activeIndex = 0;

  @override
  void initState() {
    activeIndex = widget.activeIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: _buildVBasicSteps(context),
    // );
    return _buildVBasicSteps(context);
  }

  Widget _buildVBasicSteps(BuildContext context) {
    var steps = [
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).register_login,
        successIcon: TDIcons.user,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).add_gateway,
        successIcon: TDIcons.internet,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).add_host,
        successIcon: TDIcons.desktop,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).add_ports,
        successIcon: TDIcons.add,
      ),
      TDStepsItemData(
        title: OpenIoTHubLocalizations.of(context).access_ports,
        successIcon: TDIcons.accessibility,
      ),
    ];
    return Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TDSteps(
                    steps: steps,
                    direction: TDStepsDirection.horizontal,
                    activeIndex: activeIndex,
                  ),
                )
              ],
            ),
            _buildGuideByIndex(activeIndex),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        if (activeIndex - 1 >= 0) {
                          setState(() {
                            activeIndex -= 1;
                          });
                        }
                      },
                      child:
                          Text(OpenIoTHubLocalizations.of(context).last_step)),
                  TextButton(
                      onPressed: () {
                        if (activeIndex + 1 <= steps.length - 1) {
                          setState(() {
                            activeIndex += 1;
                          });
                        }
                      },
                      child:
                          Text(OpenIoTHubLocalizations.of(context).next_step))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    OpenIoTHubLocalizations.of(context).skip_this_guide,
                    style: AppTextStyle.caption,
                  )),
            )
          ],
        ));
  }

  Widget _buildGuideByIndex(int index) {
    switch (index) {
      case 0:
        return _buildRegisterLoginGuide();
      case 1:
        return _buildGatewayGuide();
      case 2:
        return _buildHostGuide();
      case 3:
        return _buildPortGuide();
      case 4:
        return _buildOpenPortGuide();
      default:
        return _buildRegisterLoginGuide();
    }
  }

  Widget _buildRegisterLoginGuide() {
    return Column(children: [
      Center(
        child: Text(
          OpenIoTHubLocalizations.of(context).register_login_content,
          style: Constants.titleTextStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: TextButton(
            style: ButtonStyle(
              side: WidgetStateProperty.all(AppDecorations.dividerBorder),
              shape: WidgetStateProperty.all(const StadiumBorder()),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.login);
            },
            child: Text(OpenIoTHubLocalizations.of(context).register_login)),
      ),
    ]);
  }

  Widget _buildGatewayGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Center(
            child: Text(
              OpenIoTHubLocalizations.of(context).add_gateway_content,
              style: Constants.titleTextStyle,
            ),
          )),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Center(
            child: TextButton(
              onPressed: () {
                launchUrl("https://github.com/OpenIoTHub/gateway-go");
              },
                  child: Text(
                  OpenIoTHubLocalizations.of(context).open_gateway_guide,
                  style: Constants.titleTextStyle),
            ),
          ),
        ),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        AppDecorations.dividerBorder),
                    shape: WidgetStateProperty.all(const StadiumBorder()),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.scanQr);
                  },
                  child: Text(OpenIoTHubLocalizations.of(context).scan_QR)),
              TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        AppDecorations.dividerBorder),
                    shape: WidgetStateProperty.all(const StadiumBorder()),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.findGateway);
                  },
                  child: Text(
                      OpenIoTHubLocalizations.of(context).find_local_gateway))
            ],
          ),
        ),
    ]);
  }

  Widget _buildHostGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Center(
            child: Text(
              OpenIoTHubLocalizations.of(context).add_host_content,
              style: Constants.titleTextStyle,
            ),
          )),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    AppDecorations.dividerBorder),
                shape: WidgetStateProperty.all(const StadiumBorder()),
              ),
              onPressed: () {
                AppNavigator.pushCommonDeviceList(context, title: '');
              },
              child: Text(OpenIoTHubLocalizations.of(context).add_remote_host)))
    ]);
  }

  Widget _buildPortGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Center(
            child: Text(
              OpenIoTHubLocalizations.of(context).add_ports_content,
              style: Constants.titleTextStyle,
            ),
          )),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    AppDecorations.dividerBorder),
                shape: WidgetStateProperty.all(const StadiumBorder()),
              ),
              onPressed: () {
                AppNavigator.pushCommonDeviceList(context, title: '');
              },
              child: Text(OpenIoTHubLocalizations.of(context).add_port_button)))
    ]);
  }

  Widget _buildOpenPortGuide() {
    return Column(children: [
      // ThemeUtils.isDarkMode(context)
      //     ? Center(
      //         child: Image.asset('assets/images/empty_list_black.png'),
      //       )
      //     : Center(
      //         child: Image.asset('assets/images/empty_list.png'),
      //       ),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Center(
            child: Text(
              OpenIoTHubLocalizations.of(context).access_ports_content,
              style: Constants.titleTextStyle,
            ),
          )),
      Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    AppDecorations.dividerBorder),
                shape: WidgetStateProperty.all(const StadiumBorder()),
              ),
              onPressed: () {
                AppNavigator.pushCommonDeviceList(context, title: '');
              },
              child: Text(OpenIoTHubLocalizations.of(context).open_the_port)))
    ]);
  }
}
