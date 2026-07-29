// import 'dart:io';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:printing/printing.dart';
// import 'package:share_plus/share_plus.dart';

// import '../../../../core/constants/app_assets.dart';
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/providers/dependency_injection.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_gradients.dart';
// import '../../../../core/theme/app_radius.dart';
// import '../../../../core/theme/app_shadows.dart';
// import '../../../../core/theme/app_spacing.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/utils/currency_formatter.dart';
// import '../../../../core/utils/date_formatter.dart';
// import '../../../../shared_widgets/app_button.dart';
// import '../../../../shared_widgets/app_card.dart';
// import '../../../../shared_widgets/app_snackbar.dart';
// import '../../../settings/presentation/providers/settings_provider.dart';
// import '../../domain/entities/sale_entity.dart';

// @RoutePage()
// class InvoiceScreen extends ConsumerStatefulWidget {
//   final SaleEntity sale;

//   const InvoiceScreen({super.key, required this.sale});

//   @override
//   ConsumerState<InvoiceScreen> createState() => _InvoiceScreenState();
// }

// class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
//   bool _isGeneratingPdf = false;

//   Future<void> _shareInvoice() async {
//     setState(() {
//       _isGeneratingPdf = true;
//     });

//     final settings = ref.read(settingsProvider).valueOrNull;
//     final repo = ref.read(saleRepositoryProvider);
//     final res = await repo.generateInvoicePdf(
//       widget.sale,
//       shopName: settings?.shopName,
//       logoPath: settings?.shopLogoPath,
//     );

//     setState(() {
//       _isGeneratingPdf = false;
//     });

//     if (res.isSuccess) {
//       final bytes = res.data;
//       final xFile = XFile.fromData(
//         bytes,
//         mimeType: 'application/pdf',
//         name: '${widget.sale.invoiceNumber}.pdf',
//       );
//       await Share.shareXFiles([xFile], text: 'Invoice ${widget.sale.invoiceNumber}');
//     } else {
//       if (mounted) {
//         AppSnackbar.showError(context, 'Failed to share invoice');
//       }
//     }
//   }

//   Future<void> _printOrSavePdf() async {
//     setState(() {
//       _isGeneratingPdf = true;
//     });

//     final settings = ref.read(settingsProvider).valueOrNull;
//     final repo = ref.read(saleRepositoryProvider);
//     final res = await repo.generateInvoicePdf(
//       widget.sale,
//       shopName: settings?.shopName,
//       logoPath: settings?.shopLogoPath,
//     );

//     setState(() {
//       _isGeneratingPdf = false;
//     });

//     if (res.isSuccess) {
//       await Printing.layoutPdf(
//         onLayout: (format) async => res.data,
//         name: 'Invoice_${widget.sale.invoiceNumber}',
//       );
//     } else {
//       if (mounted) {
//         AppSnackbar.showError(context, 'Failed to print/save invoice');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = AppColors.of(context);
//     final textStyles = AppTextStyles.of(context);
//     final settings = ref.watch(settingsProvider).valueOrNull;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppStrings.invoiceTitle, style: textStyles.headline),
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(AppSpacing.md),
//         child: Column(
//           children: [
//             // Professional Thermal Receipt Card
//             AppCard(
//               border: Border.all(color: colors.primary.withValues(alpha: 0.4), width: 1.5),
//               child: Column(
//                 children: [
//                   // Header
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               settings?.shopName ?? AppStrings.appName,
//                               style: textStyles.title.copyWith(color: colors.primary, fontSize: 18),
//                             ),
//                             const SizedBox(height: 2),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: colors.primary.withValues(alpha: 0.1),
//                                 borderRadius: AppRadius.borderPill,
//                               ),
//                               child: Text(
//                                 'Invoice #${widget.sale.invoiceNumber}',
//                                 style: textStyles.label.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (settings?.shopLogoPath != null && File(settings!.shopLogoPath!).existsSync())
//                         ClipRRect(
//                           borderRadius: AppRadius.borderMd,
//                           child: Image.file(
//                             File(settings.shopLogoPath!),
//                             width: 48,
//                             height: 48,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       else
//                         Icon(AppAssets.defaultLogoIcon, size: 40, color: colors.primary),
//                     ],
//                   ),
//                   const SizedBox(height: AppSpacing.xs),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       DateFormatter.formatDateTime(widget.sale.timestamp),
//                       style: textStyles.caption,
//                     ),
//                   ),
//                   const Divider(height: 20, thickness: 1),

//                   // Items List
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: widget.sale.items.length,
//                     separatorBuilder: (_, __) => const Divider(height: 12),
//                     itemBuilder: (context, index) {
//                       final item = widget.sale.items[index];

//                       Widget itemPhoto;
//                       if (item.imagePath != null && File(item.imagePath!).existsSync()) {
//                         itemPhoto = ClipRRect(
//                           borderRadius: AppRadius.borderSm,
//                           child: Image.file(
//                             File(item.imagePath!),
//                             width: 38,
//                             height: 38,
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       } else {
//                         itemPhoto = Container(
//                           width: 38,
//                           height: 38,
//                           decoration: BoxDecoration(
//                             color: colors.primary.withValues(alpha: 0.1),
//                             borderRadius: AppRadius.borderSm,
//                           ),
//                           child: Icon(AppAssets.defaultProductIcon, color: colors.primary, size: 22),
//                         );
//                       }

//                       return Row(
//                         children: [
//                           itemPhoto,
//                           const SizedBox(width: AppSpacing.sm),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item.name,
//                                   style: textStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
//                                 ),
//                                 Text(
//                                   '${CurrencyFormatter.format(item.priceEach)} x ${item.qty}',
//                                   style: textStyles.caption,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             CurrencyFormatter.format(item.subtotal),
//                             style: textStyles.title.copyWith(
//                               color: colors.success,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   const Divider(height: 20, thickness: 1.5),

//                   // Grand Total Container
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       gradient: AppGradients.success(context),
//                       borderRadius: AppRadius.borderMd,
//                       boxShadow: AppShadows.buttonShadow(context, colors.success),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           AppStrings.totalAmount,
//                           style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           CurrencyFormatter.format(widget.sale.totalAmount),
//                           style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: AppSpacing.md),

//             // Two Action Buttons: Save PDF & Share PDF (Guaranteed 0 Overflow with Expanded + Flexible)
//             Row(
//               children: [
//                 Expanded(
//                   child: AppButton(
//                     label: 'SAVE PDF',
//                     icon: AppAssets.downloadIcon,
//                     variant: AppButtonVariant.primary,
//                     height: 46,
//                     fontSize: 13,
//                     isLoading: _isGeneratingPdf,
//                     onPressed: _printOrSavePdf,
//                   ),
//                 ),
//                 const SizedBox(width: AppSpacing.sm),
//                 Expanded(
//                   child: AppButton(
//                     label: 'SHARE PDF',
//                     icon: AppAssets.shareIcon,
//                     variant: AppButtonVariant.secondary,
//                     height: 46,
//                     fontSize: 13,
//                     isLoading: _isGeneratingPdf,
//                     onPressed: _shareInvoice,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: AppSpacing.sm),

//             // Return Home Button
//             AppButton(
//               label: AppStrings.returnHome,
//               icon: AppAssets.homeIcon,
//               variant: AppButtonVariant.success,
//               height: 48,
//               fontSize: 14,
//               onPressed: () {
//                 context.router.popUntilRoot();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
