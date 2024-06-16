import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/watchlist.screen.dart';
import 'package:profitpulse/src/modules/asset/widgets/asset.list.widget.dart';
import 'package:profitpulse/src/modules/portfolio/screens/portfolio.screen.dart';
import 'package:profitpulse/src/modules/profile/profile.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Pairs'),
  //     ),
  //     body: const AssertList(),
  //   );
  // }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getScreen(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility_outlined),
            label: 'Watchlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return AssertList();
      case 1:
        return WatchlistScreen();
      case 2:
        return PortfolioScreen();
      case 3:
        return Center(child: Text('Insights'));
      case 4:
        return ProfileScreen();
      default:
        return AssertList();
    }
  }
}
