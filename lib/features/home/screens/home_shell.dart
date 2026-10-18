import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/farm_providers.dart';
import '../../../core/theme/app_theme.dart';

class HomeShell extends ConsumerWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  int _getIndex(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/rabbits')) return 1;
    if (location.startsWith('/breeding') || location.startsWith('/kindling')) return 2;
    if (location.startsWith('/health') || location.startsWith('/vaccination')) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _getIndex(location);
    final unreadCount = ref.watch(unreadNotificationCountProvider).valueOrNull ?? 0;

    const navItems = [
      _NavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, path: '/'),
      _NavItem(label: 'Rabbits', icon: Icons.pets_outlined, activeIcon: Icons.pets, path: '/rabbits'),
      _NavItem(label: 'Breeding', icon: Icons.favorite_outline, activeIcon: Icons.favorite, path: '/breeding'),
      _NavItem(label: 'Health', icon: Icons.medical_services_outlined, activeIcon: Icons.medical_services, path: '/health'),
      _NavItem(label: 'More', icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view, path: ''),
    ];

    void showMoreMenu() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => _MoreMenu(
          onNavigate: (path) {
            Navigator.pop(ctx);
            context.go(path);
          },
        ),
      );
    }

    void onTabTapped(int i) {
      if (i == 4) {
        showMoreMenu();
        return;
      }
      context.go(navItems[i].path);
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(navItems.length, (i) {
                final item = navItems[i];
                final isSelected = i == index;
                final isMore = i == 4;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabTapped(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected && !isMore
                                    ? AppColors.primarySurface
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isSelected ? item.activeIcon : item.icon,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textHint,
                                size: 22,
                              ),
                            ),
                            if (isMore && unreadCount > 0)
                              Positioned(
                                top: -2,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$unreadCount',
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  final void Function(String) onNavigate;

  const _MoreMenu({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final items = [
      const _MoreItem(icon: Icons.vaccines_outlined, label: 'Vaccination', path: '/vaccination'),
      const _MoreItem(icon: Icons.restaurant_outlined, label: 'Feeding', path: '/feeding'),
      const _MoreItem(icon: Icons.receipt_long_outlined, label: 'Expenses', path: '/expenses'),
      const _MoreItem(icon: Icons.inventory_2_outlined, label: 'Inventory', path: '/inventory'),
      const _MoreItem(icon: Icons.sell_outlined, label: 'Sales', path: '/sales'),
      const _MoreItem(icon: Icons.notifications_outlined, label: 'Notifications', path: '/notifications'),
      const _MoreItem(icon: Icons.bar_chart_outlined, label: 'Reports', path: '/reports'),
      const _MoreItem(icon: Icons.person_outline, label: 'Profile', path: '/profile'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'More Features',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            children: items.map((item) => _MoreMenuTile(
              item: item,
              onTap: () => onNavigate(item.path),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _MoreMenuTile extends StatelessWidget {
  final _MoreItem item;
  final VoidCallback onTap;

  const _MoreMenuTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });
}

class _MoreItem {
  final IconData icon;
  final String label;
  final String path;

  const _MoreItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}
