import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive_layout.dart';
import '../models/product_model.dart';

class ProductResultCard extends StatelessWidget {
  const ProductResultCard({
    super.key,
    required this.product,
    required this.formattedCode,
    this.landscape = false,
  });

  final ProductModel product;
  final String? formattedCode;
  final bool landscape;

  String _formatPrice(int amount) {
    final currency = NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    return currency.format(amount).replaceFirst('Rp', 'Rp ').trim();
  }

  @override
  Widget build(BuildContext context) {
    final horizontal = ResponsiveLayout.horizontalPadding(context);
    final nameSize = ResponsiveLayout.value(
      context,
      mobile: 28,
      tablet: 34,
      landscapeTablet: 40,
    );
    final priceSize = ResponsiveLayout.value(
      context,
      mobile: 44,
      tablet: 52,
      landscapeTablet: 64,
    );
    final normalPriceSize = ResponsiveLayout.value(
      context,
      mobile: 20,
      tablet: 22,
      landscapeTablet: 26,
    );
    final unitSize = ResponsiveLayout.value(
      context,
      mobile: 18,
      tablet: 20,
      landscapeTablet: 24,
    );

    if (landscape) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal * 0.4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.greenDark.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Badge(label: 'Informasi Produk'),
                    const SizedBox(height: 20),
                    Text(
                      product.prodName ?? '-',
                      style: GoogleFonts.poppins(
                        fontSize: nameSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (formattedCode != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          formattedCode!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.greenLight,
                        AppColors.greenLight.withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.greenAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: _PriceDisplay(
                    product: product,
                    priceSize: priceSize,
                    normalPriceSize: normalPriceSize,
                    unitSize: unitSize,
                    formatPrice: _formatPrice,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenDark.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const _Badge(label: 'Informasi Produk'),
            const SizedBox(height: 20),
            Text(
              product.prodName ?? '-',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: nameSize,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.greenLight,
                    AppColors.greenLight.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.greenAccent.withValues(alpha: 0.3),
                ),
              ),
              child: _PriceDisplay(
                product: product,
                priceSize: priceSize,
                normalPriceSize: normalPriceSize,
                unitSize: unitSize,
                formatPrice: _formatPrice,
              ),
            ),
            if (formattedCode != null) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  formattedCode!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PriceDisplay extends StatelessWidget {
  const _PriceDisplay({
    required this.product,
    required this.priceSize,
    required this.normalPriceSize,
    required this.unitSize,
    required this.formatPrice,
  });

  final ProductModel product;
  final double priceSize;
  final double normalPriceSize;
  final double unitSize;
  final String Function(int amount) formatPrice;

  @override
  Widget build(BuildContext context) {
    final packing = product.packingName;

    if (product.hasDiscount) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            product.discountLabel ?? 'Harga Diskon',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.greenPrimary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  formatPrice(product.discountedPrice),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: priceSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenDark,
                  ),
                ),
              ),
              if (packing != null) ...[
                const SizedBox(width: 8),
                Text(
                  '/ $packing',
                  style: GoogleFonts.poppins(
                    fontSize: unitSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greenPrimary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            formatPrice(product.normalPrice),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: normalPriceSize,
              fontWeight: FontWeight.w500,
              color: AppColors.red,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.red,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            formatPrice(product.normalPrice),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: priceSize,
              fontWeight: FontWeight.w800,
              color: AppColors.greenDark,
            ),
          ),
        ),
        if (packing != null) ...[
          const SizedBox(width: 8),
          Text(
            '/ $packing',
            style: GoogleFonts.poppins(
              fontSize: unitSize,
              fontWeight: FontWeight.w500,
              color: AppColors.greenPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.greenLight,
            AppColors.greenLight.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.greenPrimary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
