import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';
import 'package:fintrack/providers/common.dart';
import 'package:fintrack/providers/report.dart';
import 'package:fintrack/router.dart';
import 'package:fintrack/screens/home/index.dart';
import 'package:fintrack/screens/profile/index.dart';
import 'package:fintrack/screens/report/index.dart';
import 'package:fintrack/screens/transactions/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  final List<Widget> _pages = const [HomeScreen(), TransactionScreen(), ReportScreen(), ProfileScreen()];

  final List<String> _titles = const ["BudgetBuddy", "Transactions", "Reports", "Profile"];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[currentIndex], style: AppTextStyles.title),
        backgroundColor: AppColors.primary,
        //  foregroundColor: AppColors.cardLight,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (currentIndex == 2) ...[
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => ref.read(reportProvider.notifier).refresh(),
            ),
            IconButton(
              icon: const Icon(Icons.download_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ],
      ),
      drawer: _buildDrawer(context),
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(homeTabProvider.notifier).state = index,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Transactions"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundLight,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.cardLight,
                  child: Icon(Icons.account_circle, size: 50, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Text("Mr. Johnson", style: AppTextStyles.title.copyWith(color: Colors.white)),
                Text("info@gmail.com", style: AppTextStyles.body.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Category"),
            onTap: () {
              context.push(AppRoute.category.path);
              context.pop();
            },
          ),
          ListTile(leading: const Icon(Icons.backup), title: const Text("Backup / Restore"), onTap: () => context.pop()),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              context.push(AppRoute.aboutUs.path);
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
