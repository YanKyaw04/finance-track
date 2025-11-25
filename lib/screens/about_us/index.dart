import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';

// class AboutUsScreen extends ConsumerWidget {
//   const AboutUsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundLight,
//       appBar: AppBar(
//         title: const Text('About Us', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hero section
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(24),
//                 gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
//                 boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.08 * 255).toInt()), blurRadius: 12, offset: const Offset(0, 6))],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Budget Buddy",
//                     style: AppTextStyles.title.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Your premium finance companion to track income, expenses, and stay in control of your financial health.",
//                     style: AppTextStyles.body.copyWith(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Our Mission
//             _buildSectionCard(
//               title: "Our Mission",
//               content:
//                   "To empower individuals and businesses with smart, easy-to-use financial tracking tools that help them make better decisions and achieve financial freedom.",
//               icon: Icons.track_changes,
//             ),
//             const SizedBox(height: 16),

//             // Our Vision
//             _buildSectionCard(
//               title: "Our Vision",
//               content:
//                   "To be the most trusted and premium finance management platform, providing insights and clarity into financial life with elegance and simplicity.",
//               icon: Icons.visibility,
//             ),
//             const SizedBox(height: 16),

//             // Our Team
//             _buildSectionCard(
//               title: "Our Team",
//               content:
//                   "A dedicated group of finance enthusiasts, developers, and designers committed to delivering the best experience for our users.",
//               icon: Icons.group,
//             ),
//             const SizedBox(height: 16),

//             // Contact Info
//             _buildSectionCard(
//               title: "Contact Us",
//               content: "Email: support@budgetbuddy.com\nPhone: +95 123 456 789\nWebsite: www.budgetbuddy.com",
//               icon: Icons.contact_mail,
//             ),
//             const SizedBox(height: 32),

//             // Footer
//             Center(
//               child: Text("© 2025 Budget Buddy. All rights reserved.", style: AppTextStyles.body.copyWith(color: Colors.grey[500], fontSize: 12)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionCard({required String title, required String content, required IconData icon}) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.cardLight,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).toInt()), blurRadius: 8, offset: const Offset(0, 4))],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 22,
//             backgroundColor: AppColors.primary.withAlpha((0.15 * 255).toInt()),
//             child: Icon(icon, color: AppColors.primary),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
//                 const SizedBox(height: 6),
//                 Text(content, style: AppTextStyles.body.copyWith(color: Colors.grey[700], fontSize: 14)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gradient logo with soft shadow
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.1 * 255).toInt()), blurRadius: 16, offset: const Offset(0, 8))],
              ),
              child: const Center(
                child: Text(
                  "BD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 2))],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Budget Buddy",
              style: AppTextStyles.title.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              "A premium finance tracking app built to simplify your income and expense management.",
              style: AppTextStyles.body.copyWith(color: Colors.grey[700], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Glassmorphic style info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardLight.withAlpha((0.9 * 255).toInt()),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withAlpha((0.1 * 255).toInt()), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).toInt()), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text("Developer", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 8),
                      Text("( Future Hub )", style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.flutter_dash, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text("Built with Flutter & Riverpod", style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text("09-123-123-123", style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.email, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text("budgetbuddy@gmail.com", style: AppTextStyles.body.copyWith(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Divider(color: Colors.grey[300], thickness: 1),

            const SizedBox(height: 16),
            // Version Info
            Text("Version 1.0.0", style: AppTextStyles.body.copyWith(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 8),
            Text("© 2025 BudgetBuddy. All rights reserved.", style: AppTextStyles.body.copyWith(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
