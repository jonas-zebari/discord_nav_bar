import 'package:discord_nav_bar/server_navigation_rail.dart';
import 'package:discord_nav_bar/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ServerNavigationRail(
          items: _serverItems,
          selectedIndex: _selectedIndex,
          onChanged: (index) => setState(() => _selectedIndex = index),
        ),
        Expanded(
          child: Scaffold(
            backgroundColor: DiscordTheme.background3,
            body: Center(
              child: Text(
                'Page $_selectedIndex',
                style: TextStyle(color: DiscordTheme.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const _serverItems = [
  ServerItem(
    name: 'Cool Folks Only',
    imageUrl: 'assets/images/server1.jpg',
  ),
  ServerItem(
    name: 'Rive',
    imageUrl: 'assets/images/server2.jpg',
  ),
  ServerItem(
    name: 'Animal Crossing',
  ),
];
