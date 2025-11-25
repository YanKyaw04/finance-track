import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/providers/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger splash timer
    ref.watch(splashProvider(context));

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size.height * 0.25,
              child: Container(
                width: size.width * 0.9,
                height: size.width * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withAlpha(38),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withAlpha(102),
                      blurRadius: 80,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),

            // Logo & text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.cardLight,
                  size: size.width * 0.25,
                ),
                const SizedBox(height: 20),
                Text(
                  "BudgetBuddy",
                  style: GoogleFonts.poppins(
                    color: AppColors.cardLight,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Manage your money effortlessly",
                  style: GoogleFonts.urbanist(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
