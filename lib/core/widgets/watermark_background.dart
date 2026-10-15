import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class WatermarkBackground extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double size;

  const WatermarkBackground({
    super.key,
    required this.child,
    this.opacity = 0.05,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: opacity,
                child: Image.asset(
                  AppAssets.logo,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
