import 'package:flutter/material.dart';
import 'package:material_pass/app/components/vault_search_bar.dart';
import 'package:material_pass/models/destinations.dart';

class MyNavDrawer extends StatelessWidget {
  const MyNavDrawer({
    super.key,
    this.searchController,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final List<Destination> destinations;
  // if searchController is provided, then it is disposed by the provider
  final TextEditingController? searchController;
  final void Function(int) onDestinationSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      children: [
        DrawerHeader(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Material Pass',
                  style: TextStyle(fontSize: 20.0),
                ),
                if (searchController != null && selectedIndex == 0)
                  VaultSearchBar(searchController: searchController!),
              ],
            ),
          ),
        ),
        ...destinations.map((destination) {
          return NavigationDrawerDestination(
            icon: destination.iconWrapped,
            selectedIcon: destination.selectedIconWrapped,
            label: destination.labelWrapped,
          );
        }),
      ],
    );
  }
}
