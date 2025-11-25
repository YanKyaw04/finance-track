import 'package:fintrack/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final title = GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);

  static final sectionTitle = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  static final body = GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  static final amount = GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
}
