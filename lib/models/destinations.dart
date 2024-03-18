import 'package:flutter/material.dart';

class Destination {
  final IconData _icon;
  final IconData _selectedIcon;
  final String _label;

  const Destination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  })  : _icon = icon,
        _selectedIcon = selectedIcon,
        _label = label;

  IconData get icon => _icon;
  IconData get selectedIcon => _selectedIcon;
  String get label => _label;
  Icon get iconWrapped => Icon(_icon);
  Icon get selectedIconWrapped => Icon(_selectedIcon);
  Text get labelWrapped => Text(_label);
}