class ProductModel {
  const ProductModel({
    this.prodCode,
    this.prodName,
    this.packingName,
    this.sellingPrice,
    this.disc,
  });

  final String? prodCode;
  final String? prodName;
  final String? packingName;
  final int? sellingPrice;
  final int? disc;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      prodCode: json['ProdCode']?.toString(),
      prodName: json['ProdName']?.toString(),
      packingName: json['PackingName']?.toString(),
      sellingPrice: json['SellingPrice'] is int
          ? json['SellingPrice'] as int
          : int.tryParse(json['SellingPrice']?.toString() ?? ''),
      disc: _parseDisc(json['Disc']),
    );
  }

  static int? _parseDisc(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.round();
    return int.tryParse(value.toString());
  }

  int get normalPrice => sellingPrice ?? 0;

  bool get hasDiscount => disc != null && disc! > 0;

  int get discountedPrice {
    if (!hasDiscount) return normalPrice;
    return (normalPrice * (100 - disc!) / 100).round();
  }

  String formattedCode({int maxLength = 14}) {
    final code = prodCode ?? '';
    if (code.length >= maxLength) return code;
    return code.padLeft(maxLength, '0');
  }
}
