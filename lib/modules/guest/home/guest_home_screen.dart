import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'current_user_cubit.dart';
import '../../../routing/route_id.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key, required this.child});

  final Widget child;

  static const _pageTitles = [
    'Explore',
    'Favorites',
    'Trips',
    'Inbox',
    'Profile',
  ];

  static final _routes = [
    RouteConstant.explorePath,
    RouteConstant.saved,
    RouteConstant.trips,
    RouteConstant.inbox,
    RouteConstant.account,
  ];

  static final _mainRoutes = [
    RouteConstant.explorePath,
    RouteConstant.savedPath,
    RouteConstant.tripsPath,
    RouteConstant.inboxPath,
    RouteConstant.accountPath,
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
                  items: [
                    _buildNavigationItem(0, Icons.search, _pageTitles[0]),
                    _buildNavigationItem(1, Icons.favorite_border, _pageTitles[1]),
                    _buildNavigationItem(2, Icons.hotel, _pageTitles[2]),
                    _buildNavigationItem(3, Icons.message, _pageTitles[3]),
                    _buildNavigationItem(4, Icons.person_outline, _pageTitles[4]),
                  ],
                )
              : null,
        );
      },
    );
  }
}
