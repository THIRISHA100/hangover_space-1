import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String SectionName;
  final void Function()? onPressed;

  const MyTextBox({super.key,
  required this.SectionName,
  required this.text,
  required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.only(left: 15,bottom: 15, top: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(SectionName,style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),),

              IconButton(onPressed: onPressed, icon: Icon(Icons.edit))
            ],
          ),

          Text(text, style: TextStyle(fontFamily: 'Poppins'),)
        ],
      ),
    );
  }
}
