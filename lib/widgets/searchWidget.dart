import 'package:flutter/material.dart';
import '../utils/utils/colors.dart';

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;
  final EdgeInsetsGeometry padding;

  const SearchWidget({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search...',
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Color.fromARGB(255, 254, 255, 255)),
        decoration: InputDecoration(
          labelText: widget.hintText,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 252, 252, 252)),
          hintStyle: TextStyle(
              color: const Color.fromARGB(255, 248, 250, 249).withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search,
              color: Color.fromARGB(255, 244, 248, 247)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: mainBackgroundColor,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 98, 99, 100)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 98, 81, 100)),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
