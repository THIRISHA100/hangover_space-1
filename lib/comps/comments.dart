import 'package:flutter/material.dart';

class Comments extends StatelessWidget {

  final String text;
  final String user;
  final String time;

  const Comments({
    super.key,
    required this.user,
    required this.time,
    required this.text}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5)
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:[

          Row(
            children: [
              Expanded(child: Text(text, style: TextStyle(fontFamily: 'Poppins'))),
            ],
          ),

          Row(
              children:[
                Text(user, style: TextStyle(fontFamily: 'Poppins'),),
                Text(" • • "),
                Text(time,style: TextStyle(fontFamily: 'Poppins'))
              ]
          )

        ]

      ),
    );
  }
}
