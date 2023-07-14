import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isliked;
  void Function()?onTap;
  LikeButton({
    super.key,
    required this.onTap,
    required this.isliked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isliked? Icons.favorite:Icons.favorite_border,
        color: isliked? Colors.redAccent:Colors.grey,
      ),
    );
  }
}
