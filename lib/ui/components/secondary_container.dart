import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondaryContainer extends StatelessWidget {
  final String title;
  final String imgPath;
  final Widget content;

  const SecondaryContainer({
    super.key, required this.title, required this.imgPath, required this.content,

  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(5),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
              offset:  Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            SvgPicture.asset(
              imgPath,
              width: 50,
              colorFilter: const ColorFilter.mode(
                  Colors.blue, BlendMode.srcIn),
            ),
           content,
          ],
        ),
      ),
    );
  }
}
