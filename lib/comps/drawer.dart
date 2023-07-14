import 'package:flutter/material.dart';
import 'package:hangover/comps/list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? toProfile;
  const MyDrawer({super.key,
  required this.toProfile});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          const DrawerHeader(child: Icon(Icons.person, color: Colors.white,size:65,)),
          MyListTile(icon: Icons.home, text: 'H O M E', onTap: () => Navigator.pop(context) ,),
          MyListTile(icon: Icons.person_2, text: 'P R O F I L E', onTap: toProfile,),
        ],
      ),
    );
  }
}
