import 'package:flutter/material.dart';
import 'package:material_pass/app/components/my_nav_drawer.dart';
import 'package:material_pass/app/components/vault_search_bar.dart';
import 'package:material_pass/app/screens/generate_password_screen.dart';
import 'package:material_pass/app/screens/settings_screen.dart';
import 'package:material_pass/app/screens/vault_screen.dart';
import 'package:material_pass/helpers/adaptive_screen.dart';
import 'package:material_pass/models/destinations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// VaultScreen is inserted in initState
  final List<Widget> _screens = [
    const GeneratePasswordScreen(),
    const SettingsScreen()
  ];

  static const List<Destination> _destinations = [
    Destination(
      icon: Icons.lock_outline,
      selectedIcon: Icons.lock,
      label: 'Vault',
    ),
    Destination(
      icon: Icons.refresh,
      selectedIcon: Icons.refresh,
      label: 'Generator',
    ),
    Destination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget? get _navigationBar {
    return AdaptiveScreen.isSmallScreen(context)
        ? NavigationBar(
            animationDuration: const Duration(milliseconds: 500),
            destinations: _destinations.map((destination) {
              return NavigationDestination(
                icon: destination.iconWrapped,
                selectedIcon: destination.selectedIconWrapped,
                label: destination.label,
              );
            }).toList(),
            overlayColor: MaterialStateColor.resolveWith((states) {
              return Colors.transparent;
            }),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _setSelectedIndex,
          )
        : null;
  }

  @override
  void initState() {
    super.initState();

    _screens.insert(
      0,
      VaultScreen(searchController: _searchController),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget title = _destinations[_selectedIndex].labelWrapped;
    final Widget screen = _screens[_selectedIndex];

    final bool isBigScreen = AdaptiveScreen.isBigScreen(context);
    final bool noSearchBarScreen = isBigScreen || _selectedIndex != 0;

    final Scaffold scaffold = Scaffold(
      appBar: noSearchBarScreen
          ? AppBar(
              centerTitle: !isBigScreen,
              title: title,
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(90.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 20.0,
                ),
                // color: Theme.of(context).appBarTheme.backgroundColor,
                child: VaultSearchBar(
                  searchController: _searchController,
                ),
              ),
            ),
      body: screen,
      bottomNavigationBar: _navigationBar,
    );

    return isBigScreen
        ? Row(
            children: [
              MyNavDrawer(
                selectedIndex: _selectedIndex,
                destinations: _destinations,
                searchController: _searchController,
                onDestinationSelected: _setSelectedIndex,
              ),
              Expanded(
                child: scaffold,
              )
            ],
          )
        : scaffold;
  }
}
