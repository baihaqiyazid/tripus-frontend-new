import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "../../../../helpers/theme.dart";

class CategoryList extends StatefulWidget {
  final void Function(String selectedCategory) onCategorySelected;
  String selectedValue;

  CategoryList({required this.onCategorySelected, required this.selectedValue});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  _handleCategoryValueChanged(String value) {
    setState(() {
      widget.selectedValue = value;
    });
    widget.onCategorySelected(value);
  }

  List<Map<String, String>> categories = [
    {"image": "icon_alam.png", "name": "Alam", "code": "ALAM"},
    {"image": "icon_sejarah.png", "name": "Sejarah", "code": "SEJARAH"},
    {"image": "icon_budaya.png", "name": "Budaya", "code": "BUDAYA"},
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.map((e) {
        return RadioListTile(
          title: Row(
            children: [
              Image.asset(
                'assets/${e['image']}',
                width: 50,
                height: 50,
              ),
              SizedBox(width: 15),
              Text(
                e['name']!,
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: semibold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          value: e['code'],
          groupValue: widget.selectedValue,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            _handleCategoryValueChanged(value!);
          },
        );
      }).toList(),
    );
  }
}
