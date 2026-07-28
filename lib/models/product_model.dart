class ProductModel {
  const ProductModel({
    this.prodCode,
    this.prodName,
    this.packingName,
    this.sellingPrice,
    this.disc,
    this.discountM,
  });

  final String? prodCode;
  final String? prodName;
  final String? packingName;
  final int? sellingPrice;
  final int? disc;
  final int? discountM;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      prodCode: json['ProdCode']?.toString(),
      prodName: json['ProdName']?.toString(),
      packingName: json['PackingName']?.toString(),
      sellingPrice: _parseInt(json['SellingPrice']),
      disc: _parseInt(json['Disc']),
      discountM: _parseInt(json['DiscountM']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.round();
    return int.tryParse(value.toString());
  }

  int get normalPrice => sellingPrice ?? 0;

  bool get usesPercentageDiscount => disc != null && disc! > 0;

  bool get usesFixedDiscount =>
      !usesPercentageDiscount && discountM != null && discountM! > 0;

  bool get hasDiscount => usesPercentageDiscount || usesFixedDiscount;

  int get discountedPrice {
    if (usesPercentageDiscount) {
      return (normalPrice * (100 - disc!) / 100).round();
    }
    if (usesFixedDiscount) {
      return normalPrice - discountM!;
    }
    return normalPrice;
  }

  String? get discountLabel {
    if (usesPercentageDiscount) return 'Harga Diskon ($disc%)';
    if (usesFixedDiscount) return 'Harga Diskon';
    return null;
  }

  String formattedCode({int maxLength = 14}) {
    final code = prodCode ?? '';
    if (code.length >= maxLength) return code;
    return code.padLeft(maxLength, '0');
  }
}
