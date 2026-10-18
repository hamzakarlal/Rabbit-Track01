import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/farm_setup_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/home/screens/home_shell.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/rabbits/screens/rabbits_list_screen.dart';
import '../../features/rabbits/screens/add_rabbit_screen.dart';
import '../../features/rabbits/screens/rabbit_detail_screen.dart';
import '../../features/rabbits/screens/rabbit_qr_screen.dart';
import '../../features/rabbits/screens/qr_scanner_screen.dart';
import '../../features/breeding/screens/breeding_list_screen.dart';
import '../../features/breeding/screens/add_breeding_screen.dart';
import '../../features/breeding/screens/breeding_detail_screen.dart';
import '../../features/kindling/screens/kindling_list_screen.dart';
import '../../features/kindling/screens/add_kindling_screen.dart';
import '../../features/kindling/screens/kindling_detail_screen.dart';
import '../../features/health/screens/health_list_screen.dart';
import '../../features/health/screens/add_health_record_screen.dart';
import '../../features/vaccination/screens/vaccination_list_screen.dart';
import '../../features/vaccination/screens/add_vaccination_screen.dart';
import '../../features/feeding/screens/feeding_list_screen.dart';
import '../../features/feeding/screens/add_feeding_screen.dart';
import '../../features/expenses/screens/expenses_list_screen.dart';
import '../../features/expenses/screens/add_expense_screen.dart';
import '../../features/inventory/screens/inventory_list_screen.dart';
import '../../features/inventory/screens/add_inventory_screen.dart';
import '../../features/sales/screens/sales_list_screen.dart';
import '../../features/sales/screens/add_sale_screen.dart';
import '../../features/sales/screens/sale_detail_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(currentUserProvider, (_, _) => refresh.value++);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final userAsync = ref.read(currentUserProvider);
      final location = state.matchedLocation;
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = location.startsWith('/auth');
      final isFarmSetup = location == '/auth/farm-setup';

      if (location == '/splash') return null;

      if (!isAuthenticated) {
        return isAuthRoute ? null : '/auth/login';
      }

      // Wait for the user document before deciding on farm setup.
      if (userAsync.isLoading || userAsync.hasError) return null;

      final hasFarm = userAsync.valueOrNull?.farmId.isNotEmpty ?? false;
      
      // If we are still on the register screen, stay there until the background registration finishes
      // and hasFarm becomes true, at which point we'll redirect to '/'.
      if (location == '/auth/register') {
        if (hasFarm) return '/';
        return null; // Stay on register screen while loading documents
      }
      
      if (!hasFarm) return isFarmSetup ? null : '/auth/farm-setup';

      return isAuthRoute ? '/' : null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(path: '/auth', redirect: (context, state) => '/auth/login'),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/farm-setup',
        builder: (context, state) => const FarmSetupScreen(),
      ),

      // Main shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/rabbits',
            builder: (context, state) => const RabbitsListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  return AddRabbitScreen(parentId: extra?['parentId']);
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    RabbitDetailScreen(rabbitId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'qr',
                    builder: (context, state) =>
                        RabbitQrScreen(rabbitId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/breeding',
            builder: (context, state) => const BreedingListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddBreedingScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => BreedingDetailScreen(
                  breedingId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/kindling',
            builder: (context, state) => const KindlingListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddKindlingScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => KindlingDetailScreen(
                  kindlingId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/health',
            builder: (context, state) => const HealthListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddHealthRecordScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/vaccination',
            builder: (context, state) => const VaccinationListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddVaccinationScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/feeding',
            builder: (context, state) => const FeedingListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddFeedingScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/expenses',
            builder: (context, state) => const ExpensesListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddExpenseScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddInventoryScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/sales',
            builder: (context, state) => const SalesListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddSaleScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    SaleDetailScreen(saleId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // QR Scanner (full screen)
      GoRoute(
        path: '/qr-scanner',
        builder: (context, state) => const QrScannerScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Page not found: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
