import 'package:air_bnb_clone/routing/route_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/place_repository.dart';
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
import '../modules/host/search_property_location/search_property_location_screen.dart';
import '../modules/host/search_property_location/search_property_location_viewmodel.dart';
import '../modules/host/update_posting/update_posting_screen.dart';
import '../modules/host/update_posting/update_posting_viewmodel.dart';


// ========== App Routes ==========
GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: RouteConstant.explorePath,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: RouteConstant.logInPath,
      builder: (context, state) {
        return LogInScreen(
          viewModel: LoginViewModel(
            authResultRepository: context.read()
          ),
        );
      },
      routes: [
        _route(
          RouteConstant.signUp,
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
          path: RouteConstant.explorePath,
          name: RouteConstant.explorePath,
          builder: (context, state) {
            return ExploreScreen(
              viewModel: ExploreViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.savedPath,
          name: RouteConstant.saved,
          builder: (context, state) {
            return SavedScreen(
              viewModel: SavedViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.tripsPath,
          name: RouteConstant.trips,
          builder: (context, state) {
            return TripsScreen(
              viewModel: TripsViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.inboxPath,
          name: RouteConstant.inbox,
          builder: (context, state) {
            return InboxScreen(
              viewModel: InboxViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.accountPath,
          name: RouteConstant.account,
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
          path: RouteConstant.bookingsPath,
          name: RouteConstant.bookings,
          builder: (context, state) {
            return BookingsPage(
              viewModel: BookingsViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.myPostingsPath,
          name: RouteConstant.myPostings,
          builder: (context, state) {
            return MyPostingsPage(
              viewModel: MyPostingsViewModel(),
            );
          },
          routes: [
            _route(
              RouteConstant.updatePosting,
              builder: (context, state) {
                return UpdatePostingScreen(
                  viewModel: UpdatePostingViewmodel(
                    postingRepository: context.read(),
                    mediaRepository: context.read(),
                  ),
                );
              },
              routes: [
                _route(
                  RouteConstant.searchPropertyLocation,
                  builder: (context, state) {
                    return SearchPropertyLocationScreen(
                      viewModel: SearchPropertyLocationViewModel(
                        placeRepository: context.read<PlaceRepository>(),
                      ),
                    );
                  }
                )
              ]
            )
          ]
        ),
        GoRoute(
          path: RouteConstant.hostInboxPath,
          name: RouteConstant.hostInbox,
          builder: (context, state) {
            return InboxScreen(
              viewModel: InboxViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.earningsPath,
          name: RouteConstant.earnings,
          builder: (context, state) {
            return EarningsPage(
              viewModel: EarningsViewModel(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.hostAccountPath,
          name: RouteConstant.hostAccount,
          builder: (context, state) {
            return AccountScreen(
              viewModel: AccountViewModel(
                userRepository: context.read(),
                authRepository: context.read(),
                isInHostModel: true,
              ),
            );
          },
        ),
      ],
    )
  ],
);

GoRoute _route(
    String tag, {
      GoRouterWidgetBuilder? builder,
      GoRouterPageBuilder? pageBuilder,
      List<RouteBase> routes = const [],
      GlobalKey<NavigatorState>? parentNavigatorKey,
      GoRouterRedirect? redirect,
      ExitCallback? onExit,
      bool caseSensitive = true,
    }) {
  return GoRoute(
    path: tag,
    name: tag,
    builder: builder,
    pageBuilder: pageBuilder,
    parentNavigatorKey: parentNavigatorKey,
    redirect: redirect,
    onExit: onExit,
    caseSensitive: caseSensitive,
    routes: routes,
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  if (state.matchedLocation != RouteConstant.logInPath &&
      state.matchedLocation != RouteConstant.explorePath) {
    return null;
  }

  return loggedIn ? RouteConstant.explorePath : RouteConstant.logInPath;
}