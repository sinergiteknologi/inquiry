import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/responsive_layout.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isConnected,
    required this.child,
    this.leading,
  });

  final String title;
  final String subtitle;
  final bool isConnected;
  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final isLandscapeTablet = ResponsiveLayout.isLandscapeTablet(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.greenDark,
              AppColors.greenPrimary,
              AppColors.greenAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: isLandscapeTablet
              ? _LandscapeLayout(
                  title: title,
                  subtitle: subtitle,
                  isConnected: isConnected,
                  leading: leading,
                  child: child,
                )
              : _PortraitLayout(
                  title: title,
                  subtitle: subtitle,
                  isConnected: isConnected,
                  leading: leading,
                  child: child,
                ),
        ),
      ),
    );
  }
}

class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({
    required this.title,
    required this.subtitle,
    required this.isConnected,
    required this.child,
    this.leading,
  });

  final String title;
  final String subtitle;
  final bool isConnected;
  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveLayout.isTablet(context) ? 32 : 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.contentMaxWidth(context),
          ),
          child: Column(
            children: [
              if (leading != null) ...[
                Align(alignment: Alignment.centerLeft, child: leading!),
                const SizedBox(height: 16),
              ],
              _AuthCard(
                title: title,
                subtitle: subtitle,
                isConnected: isConnected,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({
    required this.title,
    required this.subtitle,
    required this.isConnected,
    required this.child,
    this.leading,
  });

  final String title;
  final String subtitle;
  final bool isConnected;
  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: _BrandingPanel(
              title: title,
              subtitle: subtitle,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (leading != null) ...[
                    Align(alignment: Alignment.centerLeft, child: leading!),
                    const SizedBox(height: 12),
                  ],
                  _AuthCard(
                    title: title,
                    subtitle: subtitle,
                    isConnected: isConnected,
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.price_check_rounded,
              size: 48,
              color: AppColors.greenPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Mode Tablet Landscape',
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.title,
    required this.subtitle,
    required this.isConnected,
    required this.child,
  });

  final String title;
  final String subtitle;
  final bool isConnected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLandscapeTablet = ResponsiveLayout.isLandscapeTablet(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isLandscapeTablet ? 32 : 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: isLandscapeTablet ? 28 : 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusDot(isConnected: isConnected),
            ],
          ),
          SizedBox(height: isLandscapeTablet ? 32 : 28),
          child,
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isConnected ? AppColors.greenDark : AppColors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isConnected ? AppColors.greenAccent : AppColors.red)
                .withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
