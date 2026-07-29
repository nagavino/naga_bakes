import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared_widgets/app_button.dart';
import '../../../../shared_widgets/app_snackbar.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/sale_entity.dart';

@RoutePage()
class InvoiceScreen extends ConsumerStatefulWidget {
  final SaleEntity sale;

  const InvoiceScreen({super.key, required this.sale});

  @override
  ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  bool _isGeneratingPdf = false;

  Future<void> _shareInvoice() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    final settings = ref.read(settingsProvider).valueOrNull;
    final repo = ref.read(saleRepositoryProvider);
    final res = await repo.generateInvoicePdf(
      widget.sale,
      shopName: settings?.shopName,
      logoPath: settings?.shopLogoPath,
    );

    setState(() {
      _isGeneratingPdf = false;
    });

    if (res.isSuccess) {
      final bytes = res.data;
      final xFile = XFile.fromData(
        bytes,
        mimeType: 'application/pdf',
        name: '${widget.sale.invoiceNumber}.pdf',
      );
      await Share.shareXFiles([xFile], text: 'Invoice ${widget.sale.invoiceNumber}');
    } else {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to share invoice');
      }
    }
  }

  Future<void> _printOrSavePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    final settings = ref.read(settingsProvider).valueOrNull;
    final repo = ref.read(saleRepositoryProvider);
    final res = await repo.generateInvoicePdf(
      widget.sale,
      shopName: settings?.shopName,
      logoPath: settings?.shopLogoPath,
    );

    setState(() {
      _isGeneratingPdf = false;
    });

    if (res.isSuccess) {
      await Printing.layoutPdf(
        onLayout: (format) async => res.data,
        name: 'Invoice_${widget.sale.invoiceNumber}',
      );
    } else {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to print/save invoice');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    final settings = ref.watch(settingsProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.invoiceTitle, style: textStyles.headline),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Success Feedback Icon & Banner
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 44,
                    color: colors.success,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Payment Successful',
                  style: textStyles.title.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: colors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Thank you for your purchase!',
                  style: textStyles.caption.copyWith(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // World-Class Dotted Digital Ticket Card
            Container(
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
                  // Header Block (Shop Info, Logo, Invoice ID, PAID Badge)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (settings?.shopLogoPath != null && File(settings!.shopLogoPath!).existsSync())
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: AppRadius.borderMd,
                                  border: Border.all(
                                    color: colors.primary.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: AppRadius.borderMd,
                                  child: Image.file(
                                    File(settings.shopLogoPath!),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.08),
                                  borderRadius: AppRadius.borderMd,
                                ),
                                child: Icon(
                                  AppAssets.defaultLogoIcon,
                                  size: 26,
                                  color: colors.primary,
                                ),
                              ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    settings?.shopName ?? AppStrings.appName,
                                    style: textStyles.title.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(alpha: 0.08),
                                      borderRadius: AppRadius.borderPill,
                                    ),
                                    child: Text(
                                      'Invoice #${widget.sale.invoiceNumber}',
                                      style: textStyles.label.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.success.withValues(alpha: 0.1),
                                borderRadius: AppRadius.borderPill,
                                border: Border.all(
                                  color: colors.success.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'PAID',
                                style: textStyles.label.copyWith(
                                  color: colors.success,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Transaction Info Grid
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: AppRadius.borderLg,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DATE & TIME',
                                    style: textStyles.caption.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormatter.formatDateTime(widget.sale.timestamp),
                                    style: textStyles.body.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'PAYMENT METHOD',
                                    style: textStyles.caption.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Cash / UPI',
                                    style: textStyles.body.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tear Line Cutout Section
                  Row(
                    children: [
                      Transform.translate(
                        offset: const Offset(-8, 0),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: colors.background,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomPaint(
                          size: const Size.fromHeight(1),
                          painter: DashedLinePainter(color: colors.cardBorder),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(8, 0),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: colors.background,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Items & Pricing Breakdown Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ITEMS',
                              style: textStyles.caption.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colors.textSecondary,
                                letterSpacing: 0.8,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'SUBTOTAL',
                              style: textStyles.caption.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colors.textSecondary,
                                letterSpacing: 0.8,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: colors.divider, height: 1, thickness: 1),
                        const SizedBox(height: 12),

                        // Itemized List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.sale.items.length,
                          separatorBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Divider(
                              color: colors.divider.withValues(alpha: 0.4),
                              height: 1,
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final item = widget.sale.items[index];

                            Widget itemPhoto;
                            if (item.imagePath != null && File(item.imagePath!).existsSync()) {
                              itemPhoto = ClipRRect(
                                borderRadius: AppRadius.borderSm,
                                child: Image.file(
                                  File(item.imagePath!),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              itemPhoto = Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.08),
                                  borderRadius: AppRadius.borderSm,
                                ),
                                child: Icon(
                                  AppAssets.defaultProductIcon,
                                  color: colors.primary,
                                  size: 20,
                                ),
                              );
                            }

                            return Row(
                              children: [
                                itemPhoto,
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: textStyles.body.copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${CurrencyFormatter.format(item.priceEach)} x ${item.qty}',
                                        style: textStyles.caption.copyWith(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(item.subtotal),
                                  style: textStyles.body.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Divider(color: colors.divider, height: 1, thickness: 1),
                        const SizedBox(height: 16),

                        // Grand Total Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.success.withValues(alpha: 0.08),
                            borderRadius: AppRadius.borderLg,
                            border: Border.all(
                              color: colors.success.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL AMOUNT',
                                style: textStyles.label.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: colors.success,
                                  letterSpacing: 1.2,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(widget.sale.totalAmount),
                                style: textStyles.headline.copyWith(
                                  color: colors.success,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save PDF & Share PDF Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'SAVE PDF',
                    icon: AppAssets.downloadIcon,
                    variant: AppButtonVariant.primary,
                    height: 48,
                    fontSize: 13,
                    isLoading: _isGeneratingPdf,
                    onPressed: _printOrSavePdf,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'SHARE PDF',
                    icon: AppAssets.shareIcon,
                    variant: AppButtonVariant.secondary,
                    height: 48,
                    fontSize: 13,
                    isLoading: _isGeneratingPdf,
                    onPressed: _shareInvoice,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Return Home Button
            AppButton(
              label: AppStrings.returnHome,
              icon: AppAssets.homeIcon,
              variant: AppButtonVariant.success,
              height: 50,
              fontSize: 14,
              onPressed: () {
                context.router.popUntilRoot();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    double startX = 0.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
