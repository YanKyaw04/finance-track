import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/const.dart';
import 'package:fintrack/core/constants/text_style.dart';
import 'package:fintrack/providers/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Functions {
  static void showCurrencyPicker(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.read(currencyProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardLight.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(5)),
            ),
            const SizedBox(height: 15),
            Text(
              'Select Currency',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: currencies.map((currency) {
                    final isSelected = selectedCurrency == currency['code'];
                    return ListTile(
                      leading: Text(
                        currency['symbol']!,
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      title: Text(
                        '${currency['name']} (${currency['code']})',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                      onTap: () async {
                        await ref.read(currencyProvider.notifier).setCurrency(currency['code']!);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
