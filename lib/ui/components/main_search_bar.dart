import 'package:flutter/material.dart';

class MainSearchBar extends StatefulWidget {
  const MainSearchBar({super.key, required this.controller, });
  final TextEditingController controller;


  @override
  State<MainSearchBar> createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(30),
            ),
            child:  TextField(
              style:  TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              controller: widget.controller,
              decoration:const InputDecoration(
                hintText: "Search your city...",
                hintStyle: TextStyle(),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
