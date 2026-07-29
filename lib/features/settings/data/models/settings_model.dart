import '../../domain/entities/settings_entity.dart';

class SettingsModel {
  final String shopName;
  final String? shopLogoPath;
  final String? qrImagePath;
  final int invoiceCounter;
  final bool isDarkMode;

  const SettingsModel({
    required this.shopName,
    this.shopLogoPath,
    this.qrImagePath,
    required this.invoiceCounter,
    this.isDarkMode = true,
  });

  SettingsModel copyWith({
    String? shopName,
    String? shopLogoPath,
    String? qrImagePath,
    int? invoiceCounter,
    bool? isDarkMode,
  }) {
    return SettingsModel(
      shopName: shopName ?? this.shopName,
      shopLogoPath: shopLogoPath ?? this.shopLogoPath,
      qrImagePath: qrImagePath ?? this.qrImagePath,
      invoiceCounter: invoiceCounter ?? this.invoiceCounter,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  factory SettingsModel.fromMap(Map<dynamic, dynamic> map) {
    return SettingsModel(
      shopName: map['shopName'] as String? ?? 'Naga Bakes',
      shopLogoPath: map['shopLogoPath'] as String?,
      qrImagePath: map['qrImagePath'] as String?,
      invoiceCounter: (map['invoiceCounter'] as num?)?.toInt() ?? 1,
      isDarkMode: map['isDarkMode'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'shopLogoPath': shopLogoPath,
      'qrImagePath': qrImagePath,
      'invoiceCounter': invoiceCounter,
      'isDarkMode': isDarkMode,
    };
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      shopName: shopName,
      shopLogoPath: shopLogoPath,
      qrImagePath: qrImagePath,
      invoiceCounter: invoiceCounter,
      isDarkMode: isDarkMode,
    );
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      shopName: entity.shopName,
      shopLogoPath: entity.shopLogoPath,
      qrImagePath: entity.qrImagePath,
      invoiceCounter: entity.invoiceCounter,
      isDarkMode: entity.isDarkMode,
    );
  }
}
