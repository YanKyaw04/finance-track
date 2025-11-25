import 'dart:ui';
import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';
import 'package:fintrack/core/utils/functions.dart';
import 'package:fintrack/providers/currency.dart';
import 'package:fintrack/providers/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 15),
          // Avatar with glow effect
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: isDark ? Colors.black : AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 2)],
            ),
            child: const CircleAvatar(radius: 65, backgroundImage: AssetImage('assets/images/avater.jpeg')),
          ),

          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: AppTextStyles.title.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
          ),
          Text('johndoe@email.com', style: AppTextStyles.body.copyWith(color: isDark ? Colors.white : AppColors.textSecondary)),

          const SizedBox(height: 30),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark.withValues(alpha: 1.5) : AppColors.cardLight.withValues(alpha: 1.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? Colors.black12 : Colors.white.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      context,
                      ref,
                      icon: Icons.currency_exchange_rounded,
                      title: 'Preferred Currency',
                      subtitle: ref.watch(currencyProvider),
                      onTap: () => Functions.showCurrencyPicker(context, ref),
                    ),

                    _buildSettingTile(
                      context,
                      ref,
                      icon: Icons.brightness_6_rounded,
                      title: 'Dark Mode',
                      trailing: Switch(
                        activeColor: AppColors.primary,
                        value: isDark,
                        onChanged: (value) => ref.read(isDarkModeProvider.notifier).setDarkMode(value),
                      ),
                    ),

                    _buildSettingTile(context, ref, icon: Icons.backup_rounded, title: 'Backup Data', onTap: () {}),
                    _buildSettingTile(
                      context,
                      ref,
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      onTap: () {},
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final isDark = ref.watch(isDarkModeProvider);

    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: isDark ? Colors.white : textColor ?? AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.body.copyWith(color: isDark ? Colors.white : AppColors.textSecondary)) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      onTap: onTap,
    );
  }
}
