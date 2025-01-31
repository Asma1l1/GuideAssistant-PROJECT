import 'package:flutter/material.dart';
import 'package:muieen_project/screens/widgets/customAppBar.dart';
import '../../models/notification_model.dart';

class StudentNotificationsScreen extends StatelessWidget {
  static const String screenRoute = '/StudentNotificationsScreen';

  const StudentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // محاذاة النصوص من اليمين إلى اليسار
      child: Scaffold(
        backgroundColor: const Color(0xFFe1e5e6),
        body: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              left: 20,
              child: CustomAppBar(
                title: const Text(
                  'الإشعارات',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        // Open the drawer
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.home_outlined,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/icons/bgFooter.png', // Replace with your image path
                fit: BoxFit.fill,
                height: 250, // Adjust the height as needed
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 100,
              ),
              child: FutureBuilder<List<NotificationModel>>(
                future: _fetchFakeNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'حدث خطأ أثناء جلب الإشعارات. يرجى المحاولة لاحقاً.',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'لا توجد إشعارات حالياً.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final notifications = snapshot.data!;

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: const Placeholder(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ListTile(
  //                         leading: Icon(
  //                           notification.isRead
  //                               ? Icons.notifications
  //                               : Icons.notifications_active,
  //                           color:
  //                               notification.isRead ? Colors.grey : Colors.teal,
  //                         ),
  //                         title: Text(
  //                           notification.message,
  //                           style: const TextStyle(
  //                               fontSize: 14, fontWeight: FontWeight.bold),
  //                         ),
  //                         subtitle: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'التاريخ: ${notification.timestamp}',
  //                               style: const TextStyle(
  //                                   fontSize: 12, color: Colors.grey),
  //                             ),
  //                             Text(
  //                               'الحالة: ${notification.status}',
  //                               style: const TextStyle(
  //                                   fontSize: 12, color: Colors.blue),
  //                             ),
  //                           ],
  //                         ),
  //                         trailing: IconButton(
  //                           onPressed: () {
  //                             showDialog(
  //                               context: context,
  //                               builder: (context) {
  //                                 return Dialog(
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(20),
  //                                   ),
  //                                   child: Container(
  //                                     padding: const EdgeInsets.symmetric(
  //                                       vertical: 16,
  //                                       horizontal: 22,
  //                                     ),
  //                                     child: Column(
  //                                       mainAxisSize: MainAxisSize.min,
  //                                       crossAxisAlignment: CrossAxisAlignment
  //                                           .end, // Align text to start
  //                                       children: [
  //                                         const Center(
  //                                           child: Text(
  //                                             "تفاصيل الطلب",
  //                                             style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                             textAlign: TextAlign
  //                                                 .center, // Center the title text
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 16),
  //                                         const Text(
  //                                           "نوع الطلب: تعديل",
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 8),
  //                                         const Text(
  //                                           "حالة الطلب: منفذ",
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 8),
  //                                         const Text(
  //                                           "رقم الطلب: 1",
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 8),
  //                                         const Text(
  //                                           "المادة: الجودة والمعايير",
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 8),
  //                                         const Text(
  //                                           "الشعبة المرادة: شعبة 3",
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 8),
  //                                         const Text(
  //                                           "الشعبة البديلة: شعبة 1",
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                         const SizedBox(height: 16),
  //                                         Center(
  //                                           child: ElevatedButton(
  //                                             onPressed: () {
  //                                               Navigator.of(context)
  //                                                   .pop(); // Close the dialog
  //                                             },
  //                                             child: const Text('إغلاق'),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             );
  //                           },
  //                           icon: const Icon(
  //                             Icons.remove_red_eye,
  //                           ),
  //                         ),
  //                       )

  Future<List<NotificationModel>> _fetchFakeNotifications() async {
    return Future.delayed(const Duration(seconds: 1), () {
      return [
        // NotificationModel(
        //   id: '1',
        //   status: 'جديد',
        //   message: 'إشعار ١: مرحباً بكم في تطبيقنا!',
        //   timestamp: DateTime.now(),
        //   isRead: false,
        // ),
        // NotificationModel(
        //   id: '2',
        //   status: 'مكتمل',
        //   message: 'إشعار ٢: تم قبول طلبك.',
        //   timestamp: DateTime.now(),
        //   isRead: true,
        // ),
        // NotificationModel(
        //   id: '3',
        //   status: 'قيد المعالجة',
        //   message: 'إشعار ٣: طلبك قيد المراجعة.',
        //   timestamp: DateTime.now(),
        //   isRead: false,
        // ),
        // NotificationModel(
        //   id: '3',
        //   status: 'قيد المعالجة',
        //   message: 'إشعار ٣: طلبك قيد المراجعة.',
        //   timestamp: DateTime.now(),
        //   isRead: false,
        // ),
      ];
    });
  }
}
