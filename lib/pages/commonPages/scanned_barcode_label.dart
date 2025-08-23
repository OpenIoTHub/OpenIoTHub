import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:openiothub/l10n/generated/openiothub_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({super.key, required this.barcodes});

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                OpenIoTHubLocalizations.of(context).please_scan_the_qr_code,
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.white),
              ),
              Padding(padding: EdgeInsetsGeometry.only(left: 10), child: Text(
                "-",
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.white),
              )),
              TextButton(
                onPressed: () {
                  launchUrlString("https://github.com/OpenIoTHub/gateway-go");
                },
                child: Text(
                  OpenIoTHubLocalizations.of(context).install_gateway_url,
                ),
              ),
            ],
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}
