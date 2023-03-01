import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/features/seller_order/seller_view_order_page.dart';
import 'package:tocopedia/presentation/pages/features/user/user_page.dart';

class SellerNavBar extends StatefulWidget {
  const SellerNavBar({Key? key}) : super(key: key);

  @override
  State<SellerNavBar> createState() => _SellerNavBarState();
}

class _SellerNavBarState extends State<SellerNavBar> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    Scaffold(appBar: AppBar(title: const Text("Products"))),
    const SellerViewOrderPage(),
    const UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            selectedIcon: Icon(Icons.inventory_rounded),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}
