// lib/config/routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/announcement/screens/home_screen.dart';
import '../features/announcement/screens/announcement_details_screen.dart';
import '../features/announcement/screens/create_announcement_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/booking/screens/booking_screen.dart';
import '../core/storage/local_storage.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final token = await LocalStorage.getToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      
      final currentPath = state.uri.path;
      final isGoingToAuth = currentPath == '/login' || 
                           currentPath == '/signup' || 
                           currentPath == '/forgot-password';

      // Si l'utilisateur n'est pas connecté et n'essaie pas d'accéder à une page d'authentification
      if (!isLoggedIn && !isGoingToAuth) {
        return '/login';
      }
      
      // Si l'utilisateur est connecté et essaie d'accéder à une page d'authentification
      if (isLoggedIn && isGoingToAuth) {
        return '/';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
        // builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/announcement/:id',
        builder: (context, state) => AnnouncementDetailsScreen(
          id: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/create-announcement',
        builder: (context, state) => const CreateAnnouncementScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const BookingScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Erreur'),
      ),
      body: Center(
        child: Text('Page non trouvée: ${state.uri.path}'),
      ),
    ),
  );
}