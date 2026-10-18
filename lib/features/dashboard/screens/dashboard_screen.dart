import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../models/rabbit_model.dart';
import '../../../models/breeding_model.dart';

import '../../../models/inventory_model.dart';
import '../../../providers/rabbit_provider.dart';
import '../../../providers/farm_providers.dart';
import '../../../widgets/common_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farm = ref.watch(currentFarmProvider).valueOrNull;
    final user = ref.watch(currentUserProvider).valueOrNull;
    final rabbits = ref.watch(rabbitsStreamProvider).valueOrNull ?? [];
    final breedings = ref.watch(breedingsStreamProvider).valueOrNull ?? [];

    final sales = ref.watch(salesStreamProvider).valueOrNull ?? [];
    final expenses = ref.watch(expensesStreamProvider).valueOrNull ?? [];
    final inventory = ref.watch(inventoryStreamProvider).valueOrNull ?? [];
    final vaccinations =
        ref.watch(upcomingVaccinationsStreamProvider).valueOrNull ?? [];

    // Stats calculations
    final totalRabbits = rabbits.length;
    final bucks = rabbits.where((r) => r.gender == RabbitGender.male).length;
    final does = rabbits.where((r) => r.gender == RabbitGender.female).length;
    final pregnantDoes =
        rabbits.where((r) => r.status == RabbitStatus.pregnant).length;
    final sickRabbits =
        rabbits.where((r) => r.status == RabbitStatus.sick).length;
    final soldRabbits = rabbits.where((r) => r.status == RabbitStatus.sold).length;
    final activeBreedings = breedings
        .where((b) => b.status == BreedingStatus.active)
        .length;

    final now = DateTime.now();
    final thisMonthSales = sales
        .where((s) =>
            s.saleDate.year == now.year && s.saleDate.month == now.month)
        .fold(0.0, (sum, s) => sum + s.totalPrice);
    final thisMonthExpenses = expenses
        .where((e) =>
            e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
    final totalRevenue = sales.fold(0.0, (sum, s) => sum + s.totalPrice);
    final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final profit = totalRevenue - totalExpenses;

    final lowStockItems = inventory
        .where((i) => i.stockStatus == StockStatus.lowStock)
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            backgroundColor: AppColors.primaryDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_greeting()}, ${user?.fullName.split(' ').first ?? 'Farmer'}! 👋',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              farm?.farmName ?? 'My Farm',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => context.go('/notifications'),
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white70,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/profile'),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.2),
                                child: Text(
                                  (user?.fullName.isNotEmpty == true
                                          ? user!.fullName[0]
                                          : 'F')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _FinancialMiniCard(
                          label: 'This Month Revenue',
                          value: AppUtils.formatCurrency(thisMonthSales),
                          icon: Icons.trending_up,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FinancialMiniCard(
                          label: 'This Month Expenses',
                          value: AppUtils.formatCurrency(thisMonthExpenses),
                          icon: Icons.trending_down,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _FinancialMiniCard(
                    label: 'Net Profit (All Time)',
                    value: AppUtils.formatCurrency(profit),
                    icon: profit >= 0
                        ? Icons.account_balance_wallet
                        : Icons.warning_amber,
                    color:
                        profit >= 0 ? AppColors.success : AppColors.error,
                    isWide: true,
                  ),

                  const SizedBox(height: 20),

                  // Rabbit Stats
                  const SectionHeader(title: 'Rabbit Overview'),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                    children: [
                      StatCard(
                        label: 'Total',
                        value: '$totalRabbits',
                        icon: Icons.pets,
                        color: AppColors.primary,
                        compact: true,
                        onTap: () => context.go('/rabbits'),
                      ),
                      StatCard(
                        label: 'Bucks',
                        value: '$bucks',
                        icon: Icons.male,
                        color: AppColors.info,
                        compact: true,
                      ),
                      StatCard(
                        label: 'Does',
                        value: '$does',
                        icon: Icons.female,
                        color: AppColors.accentOrange,
                        compact: true,
                      ),
                      StatCard(
                        label: 'Pregnant',
                        value: '$pregnantDoes',
                        icon: Icons.favorite,
                        color: AppColors.statusPregnant,
                        compact: true,
                        onTap: () => context.go('/breeding'),
                      ),
                      StatCard(
                        label: 'Sick',
                        value: '$sickRabbits',
                        icon: Icons.local_hospital_outlined,
                        color: AppColors.error,
                        compact: true,
                        onTap: () => context.go('/health'),
                      ),
                      StatCard(
                        label: 'Sold',
                        value: '$soldRabbits',
                        icon: Icons.sell_outlined,
                        color: AppColors.statusSold,
                        compact: true,
                        onTap: () => context.go('/sales'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Active Alerts
                  if (sickRabbits > 0 || lowStockItems > 0 || vaccinations.isNotEmpty || activeBreedings > 0) ...[
                    const SectionHeader(title: 'Active Alerts'),
                    const SizedBox(height: 10),
                    if (sickRabbits > 0)
                      _AlertTile(
                        icon: Icons.local_hospital,
                        color: AppColors.error,
                        title: '$sickRabbits sick rabbit${sickRabbits > 1 ? 's' : ''}',
                        subtitle: 'Requires immediate attention',
                        onTap: () => context.go('/health'),
                      ),
                    if (lowStockItems > 0)
                      _AlertTile(
                        icon: Icons.inventory_2,
                        color: AppColors.warning,
                        title: '$lowStockItems low stock item${lowStockItems > 1 ? 's' : ''}',
                        subtitle: 'Inventory running low',
                        onTap: () => context.go('/inventory'),
                      ),
                    if (vaccinations.isNotEmpty)
                      _AlertTile(
                        icon: Icons.vaccines,
                        color: AppColors.info,
                        title: '${vaccinations.length} upcoming vaccination${vaccinations.length > 1 ? 's' : ''}',
                        subtitle: 'Due within next 7 days',
                        onTap: () => context.go('/vaccination'),
                      ),
                    if (activeBreedings > 0)
                      _AlertTile(
                        icon: Icons.favorite,
                        color: AppColors.statusPregnant,
                        title: '$activeBreedings active pregnanc${activeBreedings > 1 ? 'ies' : 'y'}',
                        subtitle: 'Monitor upcoming kindlings',
                        onTap: () => context.go('/breeding'),
                      ),
                    const SizedBox(height: 8),
                  ],

                  // Quick Actions
                  const SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                  _QuickActionsGrid(),

                  const SizedBox(height: 20),

                  // Population Chart
                  const SectionHeader(title: 'Population by Status'),
                  const SizedBox(height: 12),
                  _PopulationChart(rabbits: rabbits),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

class _FinancialMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isWide;

  const _FinancialMiniCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: isWide
          ? Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: color)),
                    Text(label, style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 8),
                Text(value,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color)),
                Text(label,
                    style: AppTextStyles.bodySmall, maxLines: 2),
              ],
            ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AlertTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.titleLarge
                          .copyWith(fontSize: 14)),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      _QuickAction(icon: Icons.add_circle_outline, label: 'Add Rabbit', path: '/rabbits/add'),
      _QuickAction(icon: Icons.favorite_outline, label: 'Record Breeding', path: '/breeding/add'),
      _QuickAction(icon: Icons.child_care_outlined, label: 'Record Kindling', path: '/kindling/add'),
      _QuickAction(icon: Icons.medical_services_outlined, label: 'Health Record', path: '/health/add'),
      _QuickAction(icon: Icons.vaccines_outlined, label: 'Vaccination', path: '/vaccination/add'),
      _QuickAction(icon: Icons.restaurant_outlined, label: 'Record Feeding', path: '/feeding/add'),
      _QuickAction(icon: Icons.receipt_outlined, label: 'Add Expense', path: '/expenses/add'),
      _QuickAction(icon: Icons.inventory_2_outlined, label: 'Add Inventory', path: '/inventory/add'),
      _QuickAction(icon: Icons.sell_outlined, label: 'Record Sale', path: '/sales/add'),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.0,
      children: actions.map((action) => GestureDetector(
        onTap: () => context.go(action.path),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: AppColors.primary, size: 26),
              const SizedBox(height: 6),
              Text(
                action.label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String path;
  const _QuickAction({required this.icon, required this.label, required this.path});
}

class _PopulationChart extends StatelessWidget {
  final List<RabbitModel> rabbits;

  const _PopulationChart({required this.rabbits});

  @override
  Widget build(BuildContext context) {
    final statuses = {
      'Active': rabbits.where((r) => r.status == RabbitStatus.active).length,
      'Pregnant': rabbits.where((r) => r.status == RabbitStatus.pregnant).length,
      'Sick': rabbits.where((r) => r.status == RabbitStatus.sick).length,
      'Sold': rabbits.where((r) => r.status == RabbitStatus.sold).length,
      'Deceased': rabbits.where((r) => r.status == RabbitStatus.deceased).length,
    };

    final hasData = statuses.values.any((v) => v > 0);

    if (!hasData) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 40, color: AppColors.textHint),
              SizedBox(height: 8),
              Text('No data yet', style: TextStyle(color: AppColors.textHint)),
            ],
          ),
        ),
      );
    }

    final colors = [
      AppColors.success,
      AppColors.statusPregnant,
      AppColors.error,
      AppColors.statusSold,
      AppColors.statusDeceased,
    ];

    final sections = statuses.entries.where((e) => e.value > 0).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                sections: List.generate(sections.length, (i) {
                  final entry = sections[i];
                  final color = colors[statuses.keys.toList().indexOf(entry.key)];
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: color,
                    title: '${entry.value}',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                }),
                sectionsSpace: 2,
                centerSpaceRadius: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(sections.length, (i) {
                final entry = sections[i];
                final color = colors[statuses.keys.toList().indexOf(entry.key)];
                final pct = rabbits.isEmpty
                    ? 0.0
                    : (entry.value / rabbits.length * 100);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary),
                        ),
                      ),
                      Text(
                        '${entry.value} (${pct.toStringAsFixed(0)}%)',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
