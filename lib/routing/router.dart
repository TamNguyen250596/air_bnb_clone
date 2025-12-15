import 'package:air_bnb_clone/commons/constants/route_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../data/repositories/auth_repository.dart';
import '../modules/auth/log_in/login_screen.dart';
import '../modules/auth/log_in/login_viewmodel.dart';
import '../modules/auth/sign_up/signup_screen.dart';
import '../modules/auth/sign_up/signup_viewmodel.dart';
import '../modules/guest/guest_screen.dart';
import 'package:go_router/go_router.dart';


// ========== App Routes ==========
GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: RouteId.guestScreen,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: RouteId.logInScreen,
      builder: (context, state) {
        return LogInScreen(
          viewModel: LoginViewModel(
            authResultRepository: context.read()
          ),
        );
      },
      routes: [
        GoRoute(
          path: RouteId.signUpScreen,
            builder: (context, state) {
              return SignUpScreen(
                viewModel: SignupViewModel(
                  mediaRepository: context.read(),
                  authResultRepository: context.read()
                ),
              );
            }
        )
      ]
    ),
    GoRoute(
      path: RouteId.guestScreen,
      builder: (context, state) {
        return const GuestScreen();
      },
    )
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == RouteId.logInScreen;
  if (!loggedIn) {
    return RouteId.logInScreen;
  }

  if (loggingIn) {
    return RouteId.guestScreen;
  }
  return null;
}