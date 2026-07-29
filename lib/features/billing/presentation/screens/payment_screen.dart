import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/dependency_injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared_widgets/app_button.dart';
import '../../../../shared_widgets/app_snackbar.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/cart_provider.dart';
import '../../../reports/presentation/providers/reports_provider.dart';

@RoutePage()
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    final repo = ref.read(saleRepositoryProvider);
    final checkoutRes = await repo.checkoutSale(cart);

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      checkoutRes.when(
        success: (sale) {
          ref.read(cartProvider.notifier).clearCart();
          ref.invalidate(salesReportProvider);
          context.router.replace(InvoiceRoute(sale: sale));
        },
        error: (failure) {
          AppSnackbar.showError(context, failure.message);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    final totalAmount = ref.watch(billingTotalProvider);
    final settingsState = ref.watch(settingsProvider);
    final settings = settingsState.valueOrNull;

    Widget qrWidget;
    final qrPath = settings?.qrImagePath;
    if (qrPath != null && File(qrPath).existsSync()) {
      qrWidget = ClipRRect(
        borderRadius: AppRadius.borderLg,
        child: Image.file(
          File(qrPath),
          width: AppSizes.qrImageSize - 20,
          height: AppSizes.qrImageSize - 20,
          fit: BoxFit.cover,
        ),
      );
    } else {
      qrWidget = InkWell(
        onTap: () => context.router.push(const SettingsRoute()),
        borderRadius: AppRadius.borderLg,
        child: Container(
          width: AppSizes.qrImageSize - 20,
          height: AppSizes.qrImageSize - 20,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.08),
            borderRadius: AppRadius.borderLg,
            border: Border.all(color: colors.primary.withValues(alpha: 0.3), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppAssets.defaultQrIcon,
                size: 70,
                color: colors.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.noQrUploaded,
                textAlign: TextAlign.center,
                style: textStyles.body.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.uploadQrPrompt,
                textAlign: TextAlign.center,
                style: textStyles.caption.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CHECKOUT', style: textStyles.headline),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: AppSizes.iconMd),
          onPressed: () => context.router.maybePop(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Amount Summary Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: AppRadius.borderXl,
                border: Border.all(
                  color: colors.cardBorder,
                  width: 1.5,
                ),
                boxShadow: AppShadows.cardShadow(context),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payments_rounded,
                        color: colors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AMOUNT TO PAY',
                        style: textStyles.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: colors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(totalAmount),
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Scan & Pay Card Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.borderXl,
                border: Border.all(
                  color: colors.cardBorder,
                  width: 1,
                ),
                boxShadow: AppShadows.cardShadow(context),
              ),
              child: Column(
                children: [
                  Text(
                    'SCAN QR TO PAY',
                    style: textStyles.caption.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use any UPI application to complete payment',
                    style: textStyles.caption.copyWith(
                      fontSize: 11.5,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // QR Code Canvas with Scanning Guide Corners
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: AppSizes.qrImageSize + 16,
                        height: AppSizes.qrImageSize + 16,
                        decoration: BoxDecoration(
                          color: Colors.white, // Pure white for perfect scanning contrast
                          borderRadius: AppRadius.borderXl,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      // QR Code Widget
                      qrWidget,
                      // Custom Scanner Reticle Corners
                      Positioned.fill(
                        child: CustomPaint(
                          painter: QRScannerReticlePainter(color: colors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // UPI Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildUpiBadge('GPay', Colors.blue),
                      const SizedBox(width: 8),
                      _buildUpiBadge('PhonePe', Colors.deepPurple),
                      const SizedBox(width: 8),
                      _buildUpiBadge('Paytm', Colors.cyan),
                      const SizedBox(width: 8),
                      _buildUpiBadge('BHIM', Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Payment Received Button
            AppButton(
              label: AppStrings.paymentReceived,
              icon: AppAssets.checkIcon,
              variant: AppButtonVariant.success,
              isLoading: _isProcessing,
              height: 52,
              fontSize: 15,
              onPressed: _isProcessing ? null : _processPayment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class QRScannerReticlePainter extends CustomPainter {
  final Color color;

  QRScannerReticlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    const cornerLength = 20.0;

    // Top Left Corner
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, 0)
        ..lineTo(cornerLength, 0),
      paint,
    );

    // Top Right Corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, cornerLength),
      paint,
    );

    // Bottom Left Corner
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height)
        ..lineTo(cornerLength, size.height),
      paint,
    );

    // Bottom Right Corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
