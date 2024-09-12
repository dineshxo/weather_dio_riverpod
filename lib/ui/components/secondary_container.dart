import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondaryContainer extends StatelessWidget {
  final String title;
  final String imgPath;
  final Widget content;
  final Gradient? gradient;
  final Color? titleColor;

  const SecondaryContainer({
    super.key, required this.title, required this.imgPath, required this.content, this.gradient, this.titleColor

  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(5),
        height: 170,
        decoration: BoxDecoration(
         gradient: gradient ?? LinearGradient(
           colors: [Colors.blue.shade100, Colors.blue.shade300],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
         ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow:  [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 3.0,
              offset: const Offset(0, 1),
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
                color: titleColor?? Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            SvgPicture.asset(
              imgPath,
              width: 50,
              colorFilter: const ColorFilter.mode(
                  Colors.black54, BlendMode.srcIn),
            ),
            const SizedBox(height: 5),
           content,
          ],
        ),
      ),
    );
  }
}
