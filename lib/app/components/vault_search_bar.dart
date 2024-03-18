import 'package:flutter/material.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({super.key, required this.searchController});

  // searchController is disposed by provider
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SearchBar(
        controller: searchController,
        leading: const Icon(Icons.search),
        hintText: 'Search in vault',
        trailing: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: searchController.clear,
          )
        ],
      ),
    );
  }
}
