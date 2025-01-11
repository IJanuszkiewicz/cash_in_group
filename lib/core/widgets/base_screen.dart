import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    required this.title,
    required this.child,
    this.floatingActionButton,
    super.key,
  });

  final Widget child;
  final String title;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        title: Text(title),
      ),
      body: child,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.list),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.groups),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
