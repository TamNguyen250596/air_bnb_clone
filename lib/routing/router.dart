import 'package:air_bnb_clone/commons/constants/route_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../data/repositories/auth_repository.dart';
import '../modules/auth/log_in/login_screen.dart';
import '../modules/auth/log_in/login_viewmodel.dart';
import '../modules/auth/sign_up/signup_screen.dart';
import '../modules/auth/sign_up/signup_viewmodel.dart';
import '../modules/guest/guest_home_screen.dart';
import '../modules/guest/explore/explore_screen.dart';
import '../modules/guest/explore/explore_viewmodel.dart';
import '../modules/guest/saved/saved_screen.dart';
import '../modules/guest/saved/saved_viewmodel.dart';
import '../modules/guest/trips/trips_screen.dart';
import '../modules/guest/trips/trips_viewmodel.dart';
import '../modules/guest/inbox/inbox_screen.dart';
import '../modules/guest/inbox/inbox_viewmodel.dart';
import '../modules/guest/account/account_screen.dart';
import '../modules/guest/account/account_viewmodel.dart';
import '../modules/host/host_home_screen.dart';
import '../modules/host/bookings/bookings_screen.dart';
import '../modules/host/bookings/bookings_viewmodel.dart';
import '../modules/host/my_postings/my_postings_screen.dart';
import '../modules/host/my_postings/my_postings_viewmodel.dart';
import '../modules/host/earnings/earnings_screen.dart';
import '../modules/host/earnings/earnings_viewmodel.dart';
import 'package:go_router/go_router.dart';


// ========== App Routes ==========
GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: RouteId.exploreScreen,
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
    ShellRoute(
      builder: (context, state, child) {
        return GuestHomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: RouteId.exploreScreen,
          builder: (context, state) {
            return ExploreScreen(
              viewModel: ExploreViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.savedScreen,
          builder: (context, state) {
            return SavedScreen(
              viewModel: SavedViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.tripsScreen,
          builder: (context, state) {
            return TripsScreen(
              viewModel: TripsViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.inboxScreen,
          builder: (context, state) {
            return InboxScreen(
              viewModel: InboxViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.accountScreen,
          builder: (context, state) {
            return AccountScreen(
              viewModel: AccountViewModel(
                userRepository: context.read(),
                authRepository: context.read(),
              ),
            );
          },
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return HostHomeScreen(child: child);
      },
      routes: [
        GoRoute(
          path: RouteId.bookingsScreen,
          builder: (context, state) {
            return BookingsPage(
              viewModel: BookingsViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.myPostingsScreen,
          builder: (context, state) {
            return MyPostingsPage(
              viewModel: MyPostingsViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.hostInboxScreen,
          builder: (context, state) {
            return InboxScreen(
              viewModel: InboxViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.earningsScreen,
          builder: (context, state) {
            return EarningsPage(
              viewModel: EarningsViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteId.hostAccountScreen,
          builder: (context, state) {
            return AccountScreen(
              viewModel: AccountViewModel(
                userRepository: context.read(),
                authRepository: context.read()
              ),
            );
          },
        ),
      ],
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
    return RouteId.exploreScreen;
  }
  return null;
}