import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/constants/app_constants.dart';
import '../../guest/home/current_user_cubit.dart';
import '../../../routing/route_id.dart';

class HostHomeScreen extends StatelessWidget {
  const HostHomeScreen({super.key, required this.child});

  final Widget child;

  static const _pageTitles = [
    'Bookings',
    'My Postings',
    'Inbox',
    'Earnings',
    'Profile',
  ];

  static final _routes = [
    RouteConstant.bookings,
    RouteConstant.myPostings,
    RouteConstant.hostInbox,
    RouteConstant.earnings,
    RouteConstant.hostAccount,
  ];

  static final _mainRoutes = [
    RouteConstant.bookingsPath,
    RouteConstant.myPostingsPath,
    RouteConstant.hostInboxPath,
    RouteConstant.earningsPath,
    RouteConstant.hostAccountPath,
  ];

  BottomNavigationBarItem _buildNavigationItem(int index, IconData iconData, String text) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      activeIcon: Icon(iconData),
      label: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final topRoute = routerState.topRoute?.path ?? "";
    final isMainRoute = _mainRoutes.contains(topRoute);
    final selectedIndex = _mainRoutes.indexOf(topRoute).clamp(0, _routes.length - 1);

    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, userState) {
        return Scaffold(
          body: child,
          bottomNavigationBar: isMainRoute
              ? BottomNavigationBar(
                  onTap: (index) => context.goNamed(_routes[index]),
                  currentIndex: selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedItemColor: AppConstants.selectedIcon,
                  unselectedItemColor: AppConstants.nonselectedIcon,
                  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  items: [
                    _buildNavigationItem(0, Icons.calendar_today, _pageTitles[0]),
                    _buildNavigationItem(1, Icons.home, _pageTitles[1]),
                    _buildNavigationItem(2, Icons.message, _pageTitles[2]),
                    _buildNavigationItem(3, Icons.currency_exchange, _pageTitles[3]),
                    _buildNavigationItem(4, Icons.person_outline, _pageTitles[4]),
                  ],
                )
              : null,
        );
      },
    );
  }
}
