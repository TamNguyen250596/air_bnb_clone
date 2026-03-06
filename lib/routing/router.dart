import 'package:air_bnb_clone/routing/route_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../modules/guest/home/current_user_cubit.dart';
import '../data/models/realm_models/posting/posting.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/place_repository.dart';
import '../modules/auth/log_in/login_cubit.dart';
import '../modules/auth/log_in/login_screen.dart';
import '../modules/auth/sign_up/signup_cubit.dart';
import '../modules/auth/sign_up/signup_screen.dart';
import '../modules/guest/book_posting/book_posting_cubit.dart';
import '../modules/guest/book_posting/book_posting_screen.dart';
import '../modules/guest/explore/explore_cubit.dart';
import '../modules/guest/explore/explore_screen.dart';
import '../modules/guest/home/guest_home_screen.dart';
import '../modules/guest/saved/saved_cubit.dart';
import '../modules/guest/saved/saved_screen.dart';
import '../modules/guest/trips/trips_cubit.dart';
import '../modules/guest/trips/trips_screen.dart';
import '../modules/guest/inbox/inbox_cubit.dart';
import '../modules/guest/inbox/inbox_screen.dart';
import '../modules/guest/account/account_cubit.dart';
import '../modules/guest/account/account_screen.dart';
import '../modules/guest/view_posting/view_posting_cubit.dart';
import '../modules/guest/view_posting/view_posting_screen.dart';
import '../modules/host/home/host_home_screen.dart';
import '../modules/host/bookings/bookings_cubit.dart';
import '../modules/host/bookings/bookings_screen.dart';
import '../modules/host/my_postings/my_postings_cubit.dart';
import '../modules/host/my_postings/my_postings_screen.dart';
import '../modules/host/earnings/earnings_cubit.dart';
import '../modules/host/earnings/earnings_screen.dart';
import '../modules/host/search_property_location/search_property_location_cubit.dart';
import '../modules/host/search_property_location/search_property_location_screen.dart';
import '../modules/host/update_posting/update_posting_cubit.dart';
import '../modules/host/update_posting/update_posting_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: RouteConstant.explorePath,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: RouteConstant.logInPath,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => LoginCubit(authRepository: context.read()),
          child: const LogInScreen(),
        );
      },
      routes: [
        _route(
          RouteConstant.signUp,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => SignupCubit(
                mediaRepository: context.read(),
                authRepository: context.read(),
              ),
              child: const SignUpScreen(),
            );
          },
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => CurrentUserCubit(
            authRepository: context.read(),
            userRepository: context.read(),
          ),
          child: GuestHomeScreen(child: child),
        );
      },
      routes: [
        GoRoute(
          path: RouteConstant.explorePath,
          name: RouteConstant.explorePath,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => ExploreCubit(postingRepository: context.read()),
              child: const ExploreScreen(),
            );
          },
          routes: [
            _route(
              RouteConstant.viewPosting,
              builder: (context, state) {
                return BlocProvider(
                  create: (_) => ViewPostingCubit(
                    authRepository: context.read(),
                    posting: state.extra as Posting,
                  ),
                  child: const ViewPostingScreen(),
                );
              },
              routes: [
                _route(
                  RouteConstant.bookPosting,
                  builder: (context, state) {
                    final parameters = state.extra as Map<String, dynamic>;
                    return BlocProvider(
                      create: (_) => BookPostingCubit(
                          parameters: parameters,
                          authRepository: context.read(),
                          stripePaymentIntentRepository: context.read(),
                          bookingRepository: context.read(),
                          userRepository: context.read(),
                          conversationRepository: context.read(),
                          messageRepository: context.read(),
                      ),
                      child: const BookPostingScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RouteConstant.savedPath,
          name: RouteConstant.saved,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => SavedCubit(),
              child: const SavedScreen(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.tripsPath,
          name: RouteConstant.trips,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => TripsCubit(),
              child: const TripsScreen(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.inboxPath,
          name: RouteConstant.inbox,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => InboxCubit(),
              child: const InboxScreen(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.accountPath,
          name: RouteConstant.account,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => AccountCubit(
                userRepository: context.read(),
                authRepository: context.read(),
              ),
              child: const AccountScreen(),
            );
          },
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) => CurrentUserCubit(
            authRepository: context.read(),
            userRepository: context.read(),
          ),
          child: HostHomeScreen(child: child),
        );
      },
      routes: [
        GoRoute(
          path: RouteConstant.bookingsPath,
          name: RouteConstant.bookings,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => BookingsCubit(),
              child: const BookingsPage(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.myPostingsPath,
          name: RouteConstant.myPostings,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => MyPostingsCubit(
                postingRepository: context.read(),
                authRepository: context.read(),
              ),
              child: const MyPostingsPage(),
            );
          },
          routes: [
            _route(
              RouteConstant.updatePosting,
              builder: (context, state) {
                final posting = state.extra as Posting?;
                return BlocProvider(
                  create: (_) => UpdatePostingCubit(
                    postingRepository: context.read(),
                    mediaRepository: context.read(),
                    authRepository: context.read(),
                    posting: posting,
                  ),
                  child: const UpdatePostingScreen(),
                );
              },
              routes: [
                _route(
                  RouteConstant.searchPropertyLocation,
                  builder: (context, state) {
                    return BlocProvider(
                      create: (_) => SearchPropertyLocationCubit(
                        placeRepository: context.read<PlaceRepository>(),
                      ),
                      child: const SearchPropertyLocationScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RouteConstant.hostInboxPath,
          name: RouteConstant.hostInbox,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => InboxCubit(),
              child: const InboxScreen(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.earningsPath,
          name: RouteConstant.earnings,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => EarningsCubit(),
              child: const EarningsPage(),
            );
          },
        ),
        GoRoute(
          path: RouteConstant.hostAccountPath,
          name: RouteConstant.hostAccount,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => AccountCubit(
                userRepository: context.read(),
                authRepository: context.read(),
                isInHostMode: true,
              ),
              child: const AccountScreen(),
            );
          },
        ),
      ],
    ),
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
  final loggingIn = state.matchedLocation == RouteConstant.logInPath;
  if (!loggedIn) {
    if (RouteConstant.nonAuthPaths.contains(state.matchedLocation)) {
      return null;
    } else {
      return RouteConstant.logInPath;
    }
  }
  if (loggingIn) {
    return RouteConstant.explorePath;
  }
  return null;
}
