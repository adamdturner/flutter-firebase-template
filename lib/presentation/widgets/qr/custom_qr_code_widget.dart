import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter_firebase_template/core/utils/device_utils.dart';

/// Plain QR code with optional size, colors, and padding; no logo overlay.
class CustomQrCodeWidget extends StatelessWidget {
  final String data;
  final double? size;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final int version;
  final EdgeInsetsGeometry padding;

  const CustomQrCodeWidget({
    super.key,
    required this.data,
    this.size,
    this.foregroundColor,
    this.backgroundColor = Colors.white,
    this.version = QrVersions.auto,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    final double scaledSize = (size ?? 300.0) * DeviceUtils.scaleFactor;

    return Container(
      padding: padding,
      color: backgroundColor,
      child: QrImageView(
        data: data,
        size: scaledSize,
        version: version,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor ?? Colors.black,
        ),
      ),
    );
  }
}
