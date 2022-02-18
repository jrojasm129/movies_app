import 'package:flutter/material.dart';

class CustomListTitle extends StatelessWidget {
  const CustomListTitle({
    Key? key,
    required this.title,
    this.padding = const EdgeInsets.only(left: 10, bottom: 20), 
    this.fontSize = 20,
  }) : super(key: key);

  final String title;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Text(
        title, 
        style: TextStyle(  
          color: Colors.white,
          fontSize: fontSize, 
          fontWeight: FontWeight.w500
        )
      ),
    );
  }
}



































