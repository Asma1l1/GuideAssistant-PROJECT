import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/firstPage.png'), // خلفية الصفحة الرئيسية
            fit: BoxFit.cover,
          ),
        ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // محاذاة العناصر في المنتصف عموديًا
          children: [
            //Icon(Icons.school, size: 100, color: Colors.teal), // أيقونة التطبيق
            SizedBox(height: 20),
            Text(
              'معين',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // محاذاة الأزرار في المنتصف أفقيًا
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginStudent'); // الانتقال إلى شاشة تسجيل الطالب
                  },
                  child: Text('طالب'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginAdvisor'); // الانتقال إلى شاشة تسجيل المرشد
                  },
                  child: Text('مرشد'),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
// class FirstPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // محاذاة العناصر في المنتصف عموديًا
//           children: [
//             Icon(Icons.school, size: 100, color: Colors.teal), // أيقونة التطبيق
//             SizedBox(height: 20),
//             Text(
//               'معين',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center, // محاذاة الأزرار في المنتصف أفقيًا
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/loginStudent'); // الانتقال إلى شاشة تسجيل الطالب
//                   },
//                   child: Text('طالب'),
//                 ),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/loginAdvisor'); // الانتقال إلى شاشة تسجيل المرشد
//                   },
//                   child: Text('مرشد'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
