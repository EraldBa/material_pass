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
  bool _isFABVisible = true;

  void _filterAndSearch() {
    _vaultItemListsByType[_selectedCategory] ??= HiveHelper.vaultItems
        .where((vaultItem) => vaultItem.category == _selectedCategory)
        .toList();

    final text = widget.searchController.text;

    var items = _vaultItemListsByType[_selectedCategory]!;

    // perform the search only when search text is not empty
    // for efficiency purposes
    if (text.isNotEmpty) {
      items = items.where((item) {
        return item.websiteName.toLowerCase().containsAll(text.toLowerCase());
      }).toList();
    }

    setState(() {
      _filteredVaultItems = items;
    });
  }

  void _resetItems() {
    setState(() {
      _vaultItemListsByType.clear();
      _vaultItemListsByType[''] = HiveHelper.vaultItems.toList();
      _filterAndSearch();
    });
  }

  void _setIsFABVisible(bool value) {
    setState(() {
      _isFABVisible = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _filteredVaultItems =
        _vaultItemListsByType[''] = HiveHelper.vaultItems.toList();

    widget.searchController.addListener(_filterAndSearch);

    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.reverse) {
        _setIsFABVisible(false);
      } else if (direction == ScrollDirection.forward) {
        _setIsFABVisible(true);
      }
    });
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_filterAndSearch);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _setIsFABVisible(true);
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
                  children: HiveHelper.categories.map(
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

                                _filterAndSearch();
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
        floatingActionButton: _isFABVisible
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
