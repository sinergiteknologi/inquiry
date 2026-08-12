import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive_layout.dart';
import '../providers/home_provider.dart';
import '../widgets/product_result_card.dart';
import '../widgets/scan_input_field.dart';
import '../widgets/status_message_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscapeTablet = ResponsiveLayout.isLandscapeTablet(context);

    return PopScope(
      canPop: false,
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _HomeHeader(compact: isLandscapeTablet),
                  ScanInputField(
                    controller: provider.scanController,
                    focusNode: provider.focusNode,
                    onChanged: provider.onScanChanged,
                    onSubmitted: provider.onScanSubmitted,
                    isLoading: provider.isFetching,
                    overlapHeader: false,
                  ),
                  Expanded(
                    child: isLandscapeTablet
                        ? _LandscapeBody(provider: provider)
                        : _PortraitBody(provider: provider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PortraitBody extends StatelessWidget {
  const _PortraitBody({required this.provider});

  final HomeProvider provider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          if (provider.hasMessages)
            StatusMessageCard(
              line1: provider.messageLine1,
              line2: provider.messageLine2,
              line3: provider.messageLine3,
            ),
          ...provider.products.map(
            (product) => ProductResultCard(
              product: product,
              formattedCode: provider.formattedCode,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _LandscapeBody extends StatelessWidget {
  const _LandscapeBody({required this.provider});

  final HomeProvider provider;

  @override
  Widget build(BuildContext context) {
    final hasProduct = provider.products.isNotEmpty;
    final hasMessage = provider.hasMessages;
    final showPlaceholder = !hasProduct && !hasMessage;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveLayout.horizontalPadding(context),
        8,
        ResponsiveLayout.horizontalPadding(context),
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: showPlaceholder
                ? _ScanPlaceholder()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (hasMessage)
                        Expanded(
                          child: StatusMessageCard(
                            line1: provider.messageLine1,
                            line2: provider.messageLine2,
                            line3: provider.messageLine3,
                            compact: true,
                          ),
                        ),
                      if (hasMessage && hasProduct) const SizedBox(width: 20),
                      if (hasProduct)
                        Expanded(
                          flex: hasMessage ? 2 : 1,
                          child: ProductResultCard(
                            product: provider.products.first,
                            formattedCode: provider.formattedCode,
                            landscape: true,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ScanPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.greenLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                size: 56,
                color: AppColors.greenPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Siap Scan',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.greenDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Arahkan scanner ke barcode produk\nInformasi harga akan tampil di sini',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        compact ? 24 : 20,
        compact ? 8 : 8,
        compact ? 24 : 20,
        compact ? 4 : 4,
      ),
      child: Align(
        alignment: compact ? Alignment.centerLeft : Alignment.centerRight,
        child: _LogoBadge(height: compact ? 36 : 38),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: height * 0.27),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.network(
        'http://totalbuah.id/wp-content/uploads/2018/10/logo-TBS-png_.png',
        height: height * 0.73,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.storefront_rounded,
          color: AppColors.greenPrimary,
          size: height * 0.62,
        ),
      ),
    );
  }
}
