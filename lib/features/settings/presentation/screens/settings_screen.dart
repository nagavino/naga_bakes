import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../../shared_widgets/app_snackbar.dart';
import '../providers/settings_provider.dart';

@RoutePage()
class SettingsScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const SettingsScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _shopNameController;
  late FocusNode _shopNameFocus;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).valueOrNull;
    _shopNameController = TextEditingController(text: settings?.shopName ?? 'Naga Bakes');
    _shopNameFocus = FocusNode();
    _shopNameFocus.addListener(() {
      if (!_shopNameFocus.hasFocus) {
        _saveShopName();
      }
    });
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopNameFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, bool isLogo) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        final savedPath = await ImageHelper.saveImageToAppStorage(picked.path);
        if (savedPath != null) {
          final notifier = ref.read(settingsProvider.notifier);
          final ok = isLogo ? await notifier.updateLogo(savedPath) : await notifier.updateQrCode(savedPath);
          if (mounted && ok) {
            AppSnackbar.showSuccess(context, isLogo ? 'Logo updated' : 'QR code updated');
          }
        }
      }
    } catch (_) {}
  }

  void _showImageSourceSheet(bool isLogo) {
    final colors = AppColors.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.inputHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isLogo ? 'Update Shop Logo' : 'Update QR Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      color: colors.primary,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera, isLogo);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      color: colors.secondary,
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery, isLogo);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveShopName() async {
    final name = _shopNameController.text.trim();
    if (name.isEmpty) return;
    final ok = await ref.read(settingsProvider.notifier).updateShopName(name);
    if (mounted && ok) {
      AppSnackbar.showSuccess(context, 'Shop name saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final settings = ref.watch(settingsProvider).valueOrNull;

    // Shop logo widget
    final hasLogo = settings?.shopLogoPath != null && File(settings?.shopLogoPath ?? '').existsSync();
    final hasQr = settings?.qrImagePath != null && File(settings?.qrImagePath ?? '').existsSync();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings, style: textStyles.headline),
        automaticallyImplyLeading: !widget.isEmbedded,
        leading: widget.isEmbedded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: AppSizes.iconMd),
                onPressed: () => context.router.maybePop(),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Profile Hero Section ──
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => _showImageSourceSheet(true),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            colors.primary.withValues(alpha: 0.3),
                            colors.secondary.withValues(alpha: 0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        color: colors.cardBackground,
                        ),
                        child: hasLogo
                            ? ClipOval(
                                child: Image.file(
                                  File(settings?.shopLogoPath ?? ''),
                                  fit: BoxFit.cover,
                                  width: 94,
                                  height: 94,
                                ),
                              )
                            : Icon(
                                AppAssets.defaultLogoIcon,
                                size: 42,
                                color: colors.primary.withValues(alpha: 0.6),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.background,
                            width: 2.5,
                          ),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Shop name editable field
            Center(
              child: SizedBox(
                width: 220,
                child: TextField(
                  controller: _shopNameController,
                  focusNode: _shopNameFocus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Shop Name',
                    hintStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colors.inputHint,
                    ),
                    suffixIcon: Icon(
                      Icons.edit_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'POS BILLING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: colors.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Section: BRANDING ──
            _buildSectionHeader('BRANDING'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.cardBorder,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Shop Logo Row
                  _buildSettingRow(
                    icon: Icons.storefront_rounded,
                    iconColor: colors.primary,
                    title: 'Shop Logo',
                    subtitle: hasLogo ? 'Logo uploaded' : 'Add your shop logo',
                    trailing: hasLogo
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(settings?.shopLogoPath ?? ''),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add_photo_alternate_outlined, size: 20, color: colors.primary),
                          ),
                    onTap: () => _showImageSourceSheet(true),
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: colors.divider,
                  ),
                  // QR Code Row
                  _buildSettingRow(
                    icon: Icons.qr_code_2_rounded,
                    iconColor: colors.success,
                    title: 'Payment QR Code',
                    subtitle: hasQr ? 'QR code uploaded' : 'Add UPI/payment QR',
                    trailing: hasQr
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(settings?.qrImagePath ?? ''),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.success.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add_photo_alternate_outlined, size: 20, color: colors.success),
                          ),
                    onTap: () => _showImageSourceSheet(false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Section: APPEARANCE ──
            _buildSectionHeader('APPEARANCE'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.cardBorder,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.appearanceIconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        colors.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        size: 22,
                        color: colors.appearanceIconColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            colors.isDarkMode ? 'Dark Mode' : 'Light Mode',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            colors.isDarkMode ? 'Easier on the eyes' : 'Classic bright theme',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoSwitch(
                      value: colors.isDarkMode,
                      activeTrackColor: colors.primary,
                      onChanged: (val) {
                        ref.read(themeModeProvider.notifier).state =
                            val ? ThemeMode.dark : ThemeMode.light;
                        ref.read(settingsProvider.notifier).updateThemeMode(val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Section: ABOUT ──
            _buildSectionHeader('ABOUT'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.cardBorder,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.info_outline_rounded, size: 22, color: colors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.appName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: colors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    final colors = AppColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              trailing,
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.inputHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
