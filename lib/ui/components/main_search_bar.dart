import 'package:flutter/material.dart';

class MainSearchBar extends StatefulWidget {
  const MainSearchBar({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<MainSearchBar> createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(30),
      ),
      child:  TextField(
        style: TextStyle(color: Colors.black),
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search_sharp,
          ),
          hintText: "Search your city...",
          hintStyle: TextStyle(),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
