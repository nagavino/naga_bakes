import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared_widgets/app_numeric_keypad.dart';
import '../../../../shared_widgets/app_snackbar.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_list_provider.dart';
import '../widgets/product_photo_picker.dart';

@RoutePage()
class AddEditItemScreen extends ConsumerStatefulWidget {
  final ProductEntity? product;

  const AddEditItemScreen({super.key, this.product});

  @override
  ConsumerState<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends ConsumerState<AddEditItemScreen> {
  late TextEditingController _nameController;
  String? _imagePath;
  String _priceInput = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _imagePath = widget.product?.imagePath;
    if (widget.product != null && widget.product!.price > 0) {
      _priceInput = widget.product!.price.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onKeyPress(String val) {
    if (_priceInput.length >= 6) return;
    setState(() {
      _priceInput += val;
    });
  }

  void _onDelete() {
    if (_priceInput.isNotEmpty) {
      setState(() {
        _priceInput = _priceInput.substring(0, _priceInput.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _priceInput = '';
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.showError(context, 'Please enter product name');
      return;
    }

    final price = double.tryParse(_priceInput) ?? 0.0;

    setState(() {
      _isSaving = true;
    });

    final isEdit = widget.product != null;
    final item = ProductEntity(
      id: widget.product?.id ?? const Uuid().v4(),
      name: name,
      imagePath: _imagePath,
      price: price,
      isActive: true,
      createdAt: widget.product?.createdAt ?? DateTime.now(),
    );

    final notifier = ref.read(productListProvider.notifier);
    final success = isEdit ? await notifier.editProduct(item) : await notifier.addProduct(item);

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      if (success) {
        AppSnackbar.showSuccess(context, isEdit ? 'Item updated!' : 'Item added!');
        context.router.maybePop();
      } else {
        AppSnackbar.showError(context, 'Failed to save item');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textStyles = AppTextStyles.of(context);
    final displayPrice = double.tryParse(_priceInput) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product != null ? AppStrings.editItem : AppStrings.addItem,
          style: textStyles.headline,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: AppSizes.iconMd),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Step 1: Photo Picker ──
            ProductPhotoPicker(
              imagePath: _imagePath,
              onImageSelected: (path) {
                setState(() {
                  _imagePath = path;
                });
              },
            ),
            const SizedBox(height: 20),

            // ── Step 2: Name Input ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colors.cardBorder,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _nameController,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: AppStrings.productName,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                  hintText: 'e.g. Filter Tea',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colors.inputHint,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.local_cafe_rounded,
                      color: colors.primary.withValues(alpha: 0.5),
                      size: 22,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 34),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Step 3: Price Display + Keypad ──
            Container(
              padding: const EdgeInsets.all(20),
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
                  // Price label
                  Text(
                    AppStrings.productPrice,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price value
                  Text(
                    CurrencyFormatter.format(displayPrice),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: displayPrice > 0
                          ? colors.success
                          : colors.inputHint,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    color: colors.divider,
                  ),
                  const SizedBox(height: 16),
                  AppNumericKeypad(
                    onKeyPress: _onKeyPress,
                    onDelete: _onDelete,
                    onClear: _onClear,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Step 4: Save Button ──
            Container(
              height: 54,
              decoration: BoxDecoration(
                gradient: AppGradients.success(context),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colors.success.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: _isSaving ? null : _save,
                  borderRadius: BorderRadius.circular(14),
                  child: Center(
                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 22),
                              SizedBox(width: 10),
                              Text(
                                'Save Item',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
