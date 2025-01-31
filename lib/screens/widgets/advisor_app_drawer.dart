import 'package:flutter/material.dart';
import 'package:muieen_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AdvisorAppDrawer extends StatelessWidget {
  const AdvisorAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);

    return Drawer(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Close Icon at the top start
          Builder(builder: (context) {
            return Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                color: Colors.black,
                onPressed: () {
                  Scaffold.of(context).closeEndDrawer();
                },
                icon: const Icon(Icons.close),
              ),
            );
          }),
          // Scrollable List of Items

          // Logout Button Fixed at the Bottom
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey
                      .withOpacity(0.3), // Optional: Add a light border
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: ListTile(
              trailing: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                // Handle logout
                Provider.of<AuthProvider>(context, listen: false).signOut();
                Navigator.of(context).pushNamed('/'); // Close the drawer
              },
            ),
          ),
        ],
      ),
    );
  }
}
