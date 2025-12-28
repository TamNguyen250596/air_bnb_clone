import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../commons/constants/app_constants.dart';
import '../../commons/constants/route_id.dart';

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
    RouteId.exploreScreen,
    RouteId.savedScreen,
    RouteId.tripsScreen,
    RouteId.inboxScreen,
    RouteId.accountScreen,
  ];

  // ========== Helper Methods ==========
  int _getSelectedIndex() {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _routes.length; i++) {
      if (currentLocation == _routes[i]) {
        return i;
      }
    }
    return 0; // Default to Explore
  }

  BottomNavigationBarItem _buildNavigationItem(int index, IconData iconData, String text) {
    final isSelected = _getSelectedIndex() == index;
    return BottomNavigationBarItem(
      icon: Icon(iconData, color: isSelected ? AppConstants.selectedIcon : AppConstants.nonselectedIcon),
      activeIcon: Icon(iconData, color: AppConstants.selectedIcon),
      label: text,
    );
  }

  void _onItemTapped(int index) {
    context.go(_routes[index]);
  }

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[selectedIndex]),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: widget.child, // Display the child route
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavigationItem(0, Icons.search, _pageTitles[0]),
          _buildNavigationItem(1, Icons.favorite_border, _pageTitles[1]),
          _buildNavigationItem(2, Icons.hotel, _pageTitles[2]),
          _buildNavigationItem(3, Icons.message, _pageTitles[3]),
          _buildNavigationItem(4, Icons.person_outline, _pageTitles[4]),
        ],
      ),
    );
  }
}
