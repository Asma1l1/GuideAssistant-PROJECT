import 'package:flutter/material.dart';
import 'package:muieen_project/models/request_model.dart';
import 'package:muieen_project/providers/courses_provider.dart';
import 'package:muieen_project/providers/request_group_provider.dart';
import 'package:muieen_project/screens/widgets/student_app_drawer.dart';
import 'package:muieen_project/screens/widgets/customAppBar.dart';
import 'package:provider/provider.dart';

class StudentRequestsLogDetailsPage extends StatelessWidget {
  final RequestGroupModel group;

  const StudentRequestsLogDetailsPage({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    final requests = group.requests;
    return Scaffold(
      backgroundColor: const Color(0xFFe1e5e6),
      endDrawer: const StudentAppDrawer(),
      body: Stack(
        children: [
          // Background shape
          Positioned(
            top: -5,
            left: -20,
            right: -5,
            child: Image.asset(
              'assets/icons/bgShape.png',
              fit: BoxFit.fill,
              height: 200,
            ),
          ),

          // AppBar
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: CustomAppBar(
              title: const Text(
                'سجل الطلبات',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ),

          // Main content
          Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                // List of requests
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.76,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: requests != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: requests?.length,
                            itemBuilder: (BuildContext context, int index) {
                              final request = requests?[index];
                              var statusColor = Colors.black;
                              if (request?.status == RequestStatus.approved) {
                                statusColor = Colors.green;
                              } else if (request?.status ==
                                  RequestStatus.pending) {
                                statusColor = Colors.yellow;
                              } else if (request?.status ==
                                  RequestStatus.rejected) {
                                statusColor = Colors.red;
                              } else {
                                statusColor = Colors.black;
                              }
                              return customCard(
                                  context, request!, statusColor, index, group);
                            },
                          )
                        : Center(
                            child: Text(
                              'لا يوجد طلبات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
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

  Widget customCard(
    BuildContext context,
    RequestModel request,
    Color borderColor,
    int index,
    RequestGroupModel group,
  ) {
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: borderColor, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'نوع الطلب: ${request.type == RequestType.add ? 'إضافة' : request.type == RequestType.edit ? 'تعديل' : 'حذف'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'حالة الطلب: ${request.status == RequestStatus.pending ? 'قيد الانتظار' : request.status == RequestStatus.approved ? 'مقبول' : request.status == RequestStatus.rejected ? 'مرفوض' : 'غير معروف'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'رقم الطلب: ${request.dateSubmitted}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: request.status == RequestStatus.pending
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // تفاصيل button action
                    _showDetailsDialog(context, request, index, group);
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color(0xFF1a3b47),
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  child: const Text('تفاصيل'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show details dialog
  Future<void> _showDetailsDialog(
    BuildContext context,
    RequestModel request,
    int index,
    RequestGroupModel group,
  ) async {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    final courseData =
        await coursesProvider.fetchCourseData(request.courseRef.courseRef);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'تفاصيل الطلب',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end, // Align text to start
            children: [
              const SizedBox(height: 16),
              Text(
                'نوع الطلب: ${request.type == RequestType.add ? 'إضافة' : request.type == RequestType.edit ? 'تعديل' : 'حذف'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'حالة الطلب: ${request.status == RequestStatus.pending ? 'قيد الانتظار' : request.status == RequestStatus.approved ? 'مقبول' : request.status == RequestStatus.rejected ? 'مرفوض' : 'غير معروف'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "رقم الطلب: ${index}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "المادة: ${courseData['courseName']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              request.type == RequestType.delete
                  ? Column(
                      children: [
                        Text(
                          "سبب الحذف: ${(request as DeleteRequestModel).reason}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          "الشعبة المرادة: شعبة ${(request as AddRequestModel).section}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "الشعبة البديلة: شعبة ${(request as AddRequestModel).alternativeSection}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('إغلاق'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show cancel dialog
  void _showCompletionDialog(
    BuildContext context,
    RequestModel request,
    int index,
    RequestGroupModel group,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'اتمام الطلب',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('هل أنت متأكد من أنك تريد اتمام هذا الطلب؟'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  const Color(0xFF1a3b47),
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: const Text('الغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Perform acceptance action here
                group.requests[index].status = RequestStatus.approved;
                final requestsProvider =
                    Provider.of<RequestGroupProvider>(context, listen: false)
                        .updateToDatabase(
                  group,
                );
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم اتمام الطلب بنجاح'),
                  ),
                );
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  const Color(0xFF1a3b47),
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }
}
