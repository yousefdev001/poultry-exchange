import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/watermark_background.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const List<String> images = [
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.35 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.36 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.36 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.36 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.37 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.37 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.38 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.40 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.40 PM (4).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.40 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.41 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.42 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.42 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.42 PM (3).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.42 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.43 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.45 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.45 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.45 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.46 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.47 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.47 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.47 PM (3).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.47 PM (4).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.47 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.48 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.48 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.48 PM (3).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.48 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.49 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.49 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.49 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.51 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.53 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.54 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.55 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.55 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.55 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.56 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.57 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.57 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.58 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.58 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.58 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.59 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.40.59 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.41.00 PM (2).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.41.00 PM (3).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.41.01 PM.jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.41.05 PM (1).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.41.05 PM (3).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.41.05 PM (5).jpeg',
    'assets/images/WhatsApp Image 2026-09-13 at 9.41.06 PM (1).jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('معرض منتجات الشمس'),
        centerTitle: true,
      ),
      body: WatermarkBackground(
        child: images.isEmpty
            ? const Center(child: Text('لا توجد صور حالياً في المعرض'))
            : GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.base),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.9,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imagePath = images[index];
                  return GestureDetector(
                    onTap: () => _openFullImage(context, imagePath, index),
                    child: Hero(
                      tag: 'gallery_$index',
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.broken_image_rounded, color: AppColors.textHint),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _openFullImage(BuildContext context, String imagePath, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(
            child: Hero(
              tag: 'gallery_$index',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
