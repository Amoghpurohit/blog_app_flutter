import 'package:blog_app/core/device/device_dimensions.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const AuthGradientButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(DeviceResolution.getDeviceWidth(context) * 0.9,
            DeviceResolution.getDeviceHeight(context) * 0.06),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}
