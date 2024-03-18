import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_pass/app/components/vault_item_tile.dart';
import 'package:material_pass/extensions/string_extension.dart';
import 'package:material_pass/helpers/hive_helper.dart';
import 'package:material_pass/helpers/show_helper.dart';
import 'package:material_pass/models/vault_item.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key, required this.searchController});

  // searchController is disposed by provider
  final TextEditingController searchController;

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final Map<String, List<VaultItem>> _vaultItemListsByType = {};
  final _scrollController = ScrollController();

  late List<VaultItem> _filteredVaultItems;

  String _selectedCategory = '';
  bool _isVisible = true;

  void _searchListener() {
    _search(widget.searchController.text);
  }

  void _search(String text) {
    setState(() {
      if (text.isEmpty) {
        _filterItems();
      } else {
        _searchForItem(_vaultItemListsByType[_selectedCategory]!, text);
      }
    });
  }

  void _searchForItem(List<VaultItem> items, String text) {
    _filteredVaultItems = items.where((item) {
      return item.websiteName.toLowerCase().containsAll(text.toLowerCase());
    }).toList();
  }

  void _filterItems() {
    _vaultItemListsByType[_selectedCategory] ??= HiveHelper.instance.vaultItems
        .where((vaultItem) => vaultItem.category == _selectedCategory)
        .toList();

    _filteredVaultItems = _vaultItemListsByType[_selectedCategory]!;
  }

  void _resetItems() {
    setState(() {
      _vaultItemListsByType.clear();
      _vaultItemListsByType[''] = HiveHelper.instance.vaultItems.toList();
      _filterItems();
    });
  }

  void _setIsVisible(bool value) {
    setState(() {
      _isVisible = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _filteredVaultItems =
        _vaultItemListsByType[''] = HiveHelper.instance.vaultItems.toList();

    widget.searchController.addListener(_searchListener);

    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse) {
        _setIsVisible(false);
      } else if (direction == ScrollDirection.forward) {
        _setIsVisible(true);
      }
    });
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_searchListener);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: HiveHelper.instance.categories.map(
                    (category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory =
                                    _selectedCategory != category
                                        ? category
                                        : '';

                                _filterItems();
                              });
                            }),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredVaultItems.length,
                itemBuilder: (context, index) {
                  final vaultItem = _filteredVaultItems[index];
                  return VaultItemTile(
                    vaultItem: vaultItem,
                    onDelete: _resetItems,
                    onEdit: _resetItems,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _isVisible
            ? FloatingActionButton(
                onPressed: () {
                  ShowHelper.vaultItemScreen(context).then((added) {
                    if (added) {
                      _resetItems();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password added!'),
                        ),
                      );
                    }
                  });
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
