import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_helper.dart';

class ProductPhotoPicker extends StatelessWidget {
  final String? imagePath;
  final ValueChanged<String?> onImageSelected;

  const ProductPhotoPicker({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        final savedPath = await ImageHelper.saveImageToAppStorage(picked.path);
        if (savedPath != null) {
          onImageSelected(savedPath);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasImage = imagePath != null && File(imagePath!).existsSync();

    Widget imageContent;
    if (hasImage) {
      imageContent = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else {
      imageContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt_rounded,
              size: 32,
              color: colors.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to add photo',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        // Photo area with dashed border
        GestureDetector(
          onTap: () => _pickImage(ImageSource.camera, context),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.keypadKeyBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: hasImage
                ? imageContent
                : CustomPaint(
                    painter: _DashedBorderPainter(
                      color: colors.cardBorder,
                      borderRadius: 16,
                      dashWidth: 8,
                      dashSpace: 5,
                      strokeWidth: 1.5,
                    ),
                    child: imageContent,
                  ),
          ),
        ),
        const SizedBox(height: 12),
        // Pill action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPillButton(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              color: colors.primary,
              onTap: () => _pickImage(ImageSource.camera, context),
            ),
            const SizedBox(width: 12),
            _buildPillButton(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              color: colors.secondary,
              onTap: () => _pickImage(ImageSource.gallery, context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPillButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for dashed border rectangles
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final length = min(dashWidth, metric.length - distance);
        final extracted = metric.extractPath(distance, distance + length);
        canvas.drawPath(extracted, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
