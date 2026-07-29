class SettingsEntity {
  final String shopName;
  final String? shopLogoPath;
  final String? qrImagePath;
  final int invoiceCounter;
  final bool isDarkMode;

  const SettingsEntity({
    this.shopName = 'Naga Bakes',
    this.shopLogoPath,
    this.qrImagePath,
    this.invoiceCounter = 1,
    this.isDarkMode = true,
  });

  SettingsEntity copyWith({
    String? shopName,
    String? shopLogoPath,
    String? qrImagePath,
    int? invoiceCounter,
    bool? isDarkMode,
  }) {
    return SettingsEntity(
      shopName: shopName ?? this.shopName,
      shopLogoPath: shopLogoPath ?? this.shopLogoPath,
      qrImagePath: qrImagePath ?? this.qrImagePath,
      invoiceCounter: invoiceCounter ?? this.invoiceCounter,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
