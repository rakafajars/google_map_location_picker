import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_location_picker/generated/l10n.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  SearchInput(
    this.onSearchInput, {
    Key key,
    this.searchInputKey,
    this.boxDecoration,
    this.hintText,
    this.hintStyle,
  }) : super(key: key);

  final ValueChanged<String> onSearchInput;
  final Key searchInputKey;
  final BoxDecoration boxDecoration;
  final String hintText;
  final TextStyle hintStyle;

  @override
  State<StatefulWidget> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  TextEditingController editController = TextEditingController();

  static MediaQueryData _mediaQueryData;

  Timer debouncer;

  bool hasSearchEntry = false;

  @override
  void initState() {
    super.initState();
    editController.addListener(onSearchInputChange);
  }

  @override
  void dispose() {
    editController.removeListener(onSearchInputChange);
    editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (editController.text.isEmpty) {
      debouncer?.cancel();
      widget.onSearchInput(editController.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer.cancel();
    }

    debouncer = Timer(Duration(milliseconds: 500), () {
      widget.onSearchInput(editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 36,
      decoration: new BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Colors.white,
        borderRadius: new BorderRadius.all(
          new Radius.circular(
            10.0,
          ),
        ),
      ),
      child: TextField(
        controller: editController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText:
              widget.hintText ?? S.of(context)?.search_place ?? 'Cari Apotek',
          border: InputBorder.none,
          hintStyle: widget.hintStyle,
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFFB8BCC6),
            size: 20,
          ),
        ),
        onChanged: (value) {
          setState(() {
            hasSearchEntry = value.isNotEmpty;
          });
        },
      ),
    );
  }
}
