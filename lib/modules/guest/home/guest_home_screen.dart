import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'current_user_cubit.dart';
import '../../../routing/route_id.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key, required this.child});

  final Widget child;

  @override
  State<GuestHomeScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestHomeScreen> {
  // ========== Properties ==========
  final List<String> _pageTitles = [
    'Explore',
    'Favorites',
    'Trips',
    'Inbox',
    'Profile',
  ];

  final List<String> _routes = [
    RouteConstant.explorePath,
    RouteConstant.saved,
    RouteConstant.trips,
    RouteConstant.inbox,
    RouteConstant.account,
  ];
  int _selectedIndex = 0;
  late final List<BottomNavigationBarItem> _items = [
    _buildNavigationItem(0, Icons.search, _pageTitles[0]),
    _buildNavigationItem(1, Icons.favorite_border, _pageTitles[1]),
    _buildNavigationItem(2, Icons.hotel, _pageTitles[2]),
    _buildNavigationItem(3, Icons.message, _pageTitles[3]),
    _buildNavigationItem(4, Icons.person_outline, _pageTitles[4]),
  ];

  // ========== Helper Methods ==========
  BottomNavigationBarItem _buildNavigationItem(int index, IconData iconData, String text) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      activeIcon: Icon(iconData),
      label: text,
    );
  }

  void _onItemTapped(int index) {
    context.goNamed(_routes[index]);
    setState(() {
      _selectedIndex = index;
    });
  }

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final topRoute = routerState.topRoute?.path ?? "";

    final mainRoutes = [
      RouteConstant.explorePath,
      RouteConstant.savedPath,
      RouteConstant.tripsPath,
      RouteConstant.inboxPath,
      RouteConstant.accountPath,
    ];

    final isMainRoute = mainRoutes.contains(topRoute);

    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, userState) {
        return Scaffold(
          body: widget.child, // Display the child route
          bottomNavigationBar: isMainRoute ? BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: _items,
      ) : null,
        );
      },
    );
  }
}
