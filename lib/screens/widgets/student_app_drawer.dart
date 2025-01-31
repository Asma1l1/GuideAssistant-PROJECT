import 'package:flutter/material.dart';
import 'package:muieen_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class StudentAppDrawer extends StatelessWidget {
  const StudentAppDrawer({
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
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
                  child: ListTile(
                    trailing: const Icon(Icons.home, color: Colors.black),
                    title: const Text(
                      'الملف الاكاديمي',
                      style: TextStyle(color: Colors.black),
                      textDirection: TextDirection.rtl,
                    ),
                    onTap: () {
                      // Handle navigation to home
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ),
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
                  child: ListTile(
                    trailing: const Icon(Icons.settings, color: Colors.black),
                    title: const Text(
                      'سجل الطلبات',
                      style: TextStyle(color: Colors.black),
                      textDirection: TextDirection.rtl,
                    ),
                    onTap: () {
                      // Handle navigation to settings
                      Navigator.pushNamed(
                        context,
                        "/Student_requests_log_screen",
                      ); // Close the drawer
                    },
                  ),
                ),
                // Add more ListTile items here
              ],
            ),
          ),
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
