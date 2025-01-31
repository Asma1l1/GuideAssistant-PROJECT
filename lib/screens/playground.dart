import 'package:flutter/material.dart';

import 'widgets/customAppBar.dart';
import 'widgets/student_app_drawer.dart';

class PlayGroundScreen extends StatelessWidget {
  const PlayGroundScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x1A4B4BC1),
      endDrawer: const StudentAppDrawer(),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: -5,
            left: -20,
            right: -5,
            child: Image.asset(
              'assets/icons/bgShape.png', // Replace with your image path
              fit: BoxFit.fill,
              height: 200, // Adjust the height as needed
            ),
          ),
          const Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: Placeholder(),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 230),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'مرحباً فلان الفلاني',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'مرشدك الأكاديمي: فلان الفلاني',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          blurRadius: 10, // Soften the shadow
                          spreadRadius: 2, // Extend the shadow
                          offset: const Offset(0, 5), // Shadow position (x, y)
                        ),
                      ],
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildGridButton(
                          context,
                          'نموذج الحذف',
                          () {
                            Navigator.pushNamed(
                              context,
                              '/delete_request_screen',
                              // arguments: widget.studentRef,
                            );
                          },
                        ),
                        _buildGridButton(
                          context,
                          'نموذج الإضافة',
                          () {
                            Navigator.pushNamed(
                              context,
                              '/delete_request_screen',
                              // arguments: widget.studentRef,
                            );
                          },
                        ),
                        _buildGridButton(
                          context,
                          'نموذج تغيير شعبة',
                          () {},
                        ),
                        _buildGridButton(
                          context,
                          'نموذج الطلبات الارتباطية',
                          () {},
                        ),
                        _buildGridButton(
                          context,
                          'الجدول الدراسي',
                          () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
