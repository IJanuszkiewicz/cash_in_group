import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({required this.groupName, required this.groupId, super.key});

  final String groupName;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/groups/$groupId');
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: CircleAvatar(
                  radius: 30,
                  child: FlutterLogo(
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  groupName,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
