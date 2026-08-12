import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive_layout.dart';

class ScanInputField extends StatelessWidget {
  const ScanInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onSubmitted,
    this.isLoading = false,
    this.overlapHeader = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isLoading;
  final bool overlapHeader;

  void _submit() {
    onSubmitted?.call(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscapeTablet = ResponsiveLayout.isLandscapeTablet(context);
    final horizontal = ResponsiveLayout.horizontalPadding(context);
    final verticalOffset = overlapHeader && !isLandscapeTablet ? -24.0 : 0.0;
    final topMargin = overlapHeader && !isLandscapeTablet ? 0.0 : 4.0;

    return Container(
      margin: EdgeInsets.fromLTRB(horizontal, topMargin, horizontal, 0),
      transform: Matrix4.translationValues(0, verticalOffset, 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(isLandscapeTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenDark.withValues(alpha: 0.15),
            blurRadius: isLandscapeTablet ? 28 : 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(isLandscapeTablet ? 12 : 10),
            padding: EdgeInsets.all(isLandscapeTablet ? 14 : 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.greenLight,
                  AppColors.greenLight.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: isLoading
                ? SizedBox(
                    width: isLandscapeTablet ? 28 : 24,
                    height: isLandscapeTablet ? 28 : 24,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.greenPrimary,
                    ),
                  )
                : Icon(
                    Icons.qr_code_scanner_rounded,
                    color: AppColors.greenPrimary,
                    size: isLandscapeTablet ? 32 : 26,
                  ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              enabled: !isLoading,
              onChanged: onChanged,
              onSubmitted: (_) => _submit(),
              onEditingComplete: _submit,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              style: GoogleFonts.poppins(
                fontSize: isLandscapeTablet ? 18 : 15,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Scan atau ketik kode barcode...',
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.hint,
                  fontSize: isLandscapeTablet ? 16 : 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: isLandscapeTablet ? 22 : 18,
                ),
              ),
            ),
          ),
          if (!isLoading)
            IconButton(
              onPressed: _submit,
              tooltip: 'Cari',
              icon: Icon(
                Icons.search_rounded,
                color: AppColors.greenPrimary,
                size: isLandscapeTablet ? 28 : 24,
              ),
            ),
        ],
      ),
    );
  }
}
