import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../commons/constants/app_constants.dart';
import '../../routing/route_id.dart';

class HostHomeScreen extends StatefulWidget {
  const HostHomeScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {

  // ========== Properties ==========
  final List<String> _pageTitles = [
    'Bookings',
    'My Postings',
    'Inbox',
    'Earnings',
    'Profile',
  ];

  final List<String> _routes = [
    RouteConstant.bookings,
    RouteConstant.myPostings,
    RouteConstant.hostInbox,
    RouteConstant.earnings,
    RouteConstant.hostAccount,
  ];
  int _selectedIndex = 0;
  late final List<BottomNavigationBarItem> _items = [
    _buildNavigationItem(0, Icons.calendar_today, _pageTitles[0]),
    _buildNavigationItem(1, Icons.home, _pageTitles[1]),
    _buildNavigationItem(2, Icons.message, _pageTitles[2]),
    _buildNavigationItem(3, Icons.currency_exchange, _pageTitles[3]),
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
      RouteConstant.bookingsPath,
      RouteConstant.myPostingsPath,
      RouteConstant.hostInboxPath,
      RouteConstant.earningsPath,
      RouteConstant.hostAccountPath,
    ];

    final isMainRoute = mainRoutes.contains(topRoute);
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: isMainRoute ? BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppConstants.selectedIcon,
        unselectedItemColor: AppConstants.nonselectedIcon,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: _items,
      ) : null,
    );
  }
}

