import 'package:flutter/material.dart';
import 'package:shopping_list/models/auth.dart';
import 'package:shopping_list/screens/auth_screen.dart';
import 'package:shopping_list/widgets/grocery_list.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return const GroceryList();
        }else{
          return AuthScreen();
        }
      },
    );
  }
}
