import 'package:discord_nav_bar/discord_theme.dart';
import 'package:discord_nav_bar/server_navigation_rail.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ServerNavigationRail(
          items: _serverItems,
          selectedIndex: _selectedIndex.value,
          onChanged: (index) => _selectedIndex.value = index,
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, selectedIndex, _) => Scaffold(
              backgroundColor: DiscordTheme.background3,
              body: Center(
                child: Text(
                  'Page $selectedIndex',
                  style: TextStyle(color: DiscordTheme.white),
                ),
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
    muted: true,
  ),
  ServerItem(
    name: 'Rive',
    imageUrl: 'assets/images/server2.jpg',
    muted: true,
  ),
  ServerItem(
    name: 'Animal Crossing',
  ),
];
