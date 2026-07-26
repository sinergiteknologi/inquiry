import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive_layout.dart';

class StatusMessageCard extends StatelessWidget {
  const StatusMessageCard({
    super.key,
    required this.line1,
    this.line2,
    this.line3,
    this.compact = false,
  });

  final String line1;
  final String? line2;
  final String? line3;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final horizontal = ResponsiveLayout.horizontalPadding(context);
    final titleSize = ResponsiveLayout.value(
      context,
      mobile: 20,
      tablet: 22,
      landscapeTablet: compact ? 22 : 26,
    );
    final bodySize = ResponsiveLayout.value(
      context,
      mobile: 18,
      tablet: 19,
      landscapeTablet: compact ? 18 : 22,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 0 : horizontal,
        vertical: compact ? 0 : 12,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: compact ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 20 : 24,
          vertical: compact ? 24 : 32,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(compact ? 28 : 24),
          border: Border.all(color: AppColors.greenAccent.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenDark.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              compact ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(compact ? 14 : 16),
              decoration: const BoxDecoration(
                color: AppColors.greenLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: AppColors.greenPrimary,
                size: compact ? 28 : 32,
              ),
            ),
            SizedBox(height: compact ? 16 : 20),
            Text(
              line1,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: titleSize,
                color: AppColors.greenDark,
              ),
            ),
            if (line2 != null && line2!.isNotEmpty) ...[
              SizedBox(height: compact ? 6 : 8),
              Text(
                line2!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: bodySize,
                  color: AppColors.black,
                ),
              ),
            ],
            if (line3 != null && line3!.isNotEmpty) ...[
              SizedBox(height: compact ? 8 : 12),
              Text(
                line3!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 14 : 16,
                  color: AppColors.greenPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
