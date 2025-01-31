import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muieen_project/models/request_model.dart';
import 'package:muieen_project/providers/courses_provider.dart';
import 'package:muieen_project/providers/request_group_provider.dart';
import 'package:muieen_project/screens/widgets/student_app_drawer.dart';
import 'package:muieen_project/screens/widgets/customAppBar.dart';
import 'package:provider/provider.dart';

class StudentRequestsPage extends StatefulWidget {
  const StudentRequestsPage({super.key});

  @override
  State<StudentRequestsPage> createState() => _StudentRequestsPageState();
}

class _StudentRequestsPageState extends State<StudentRequestsPage> {
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    final requests =
        Provider.of<RequestGroupProvider>(context).currentGroup?.requests;

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
                const SizedBox(height: 75),
                // List of requests
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    child: requests != null
                        ? ReorderableListView.builder(
                            footer: ElevatedButton(
                              onPressed: () {
                                Provider.of<RequestGroupProvider>(context,
                                        listen: false)
                                    .submitToDatabase();
                              },
                              child: Text("ارسال للمرشد"),
                            ),
                            header: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: CheckboxListTile(
                                title: const Text(
                                  "الطلبات ارتباطية",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                checkColor: Colors
                                    .white, // Color of the checkmark when checked
                                activeColor:
                                    Colors.blue, // Fill color when checked
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blue.withOpacity(
                                        0.1); // Optional: Overlay color when checked
                                  }
                                  return Colors
                                      .transparent; // No overlay when unchecked
                                }),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4.0), // Optional: Border radius for the tile
                                ),
                                side: MaterialStateBorderSide.resolveWith(
                                    (states) {
                                  // Set the border color to white for all states
                                  return const BorderSide(
                                    color: Colors
                                        .white, // White border for both checked and unchecked states
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  );
                                }),
                                value: checkedValue,
                                onChanged: (newValue) {
                                  Provider.of<RequestGroupProvider>(context,
                                          listen: false)
                                      .setOrdered(ordered: newValue!);
                                  setState(() {
                                    checkedValue = newValue;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, // Checkbox on the left
                              ),
                            ),
                            shrinkWrap: true,
                            itemCount: requests.length,
                            itemBuilder: (BuildContext context, int index) {
                              final request = requests[index];
                              var statusColor = Colors.black;
                              if (request.status == RequestStatus.approved) {
                                statusColor = Colors.green;
                              } else if (request.status ==
                                  RequestStatus.pending) {
                                statusColor = Colors.yellow;
                              } else if (request.status ==
                                  RequestStatus.rejected) {
                                statusColor = Colors.red;
                              } else {
                                statusColor = Colors.black;
                              }
                              return customCard(
                                context,
                                request,
                                statusColor,
                                index,
                                key: ValueKey(index), // Use index as the key
                              );
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              // Handle reordering logic here
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final RequestModel request =
                                  requests.removeAt(oldIndex);
                              requests.insert(newIndex, request);
                              // Notify the provider or update the state as needed
                              Provider.of<RequestGroupProvider>(context,
                                      listen: false)
                                  .updateRequests(requests);
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
}

Widget customCard(
    BuildContext context, RequestModel request, Color borderColor, int index,
    {Key? key}) {
  return Card(
    key: key, // Pass the key to the Card
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
            'رقم الطلب: $index',
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
                  _showDetailsDialog(context, request, index);
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
              request.status == RequestStatus.pending
                  ? ElevatedButton(
                      onPressed: () {
                        // تأكيد button action
                        _showCancelDialog(context, index);
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
                      child: const Text('تراجع'),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    ),
  );
}

// Show details dialog
Future<void> _showDetailsDialog(
    BuildContext context, RequestModel request, int index) async {
  final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
  final courseData =
      await coursesProvider.fetchCourseData(request.courseRef.courseRef);

  // Cast the request to the appropriate type based on its type
  dynamic specificRequest;
  if (request.type == RequestType.add) {
    specificRequest = request as AddRequestModel;
  } else if (request.type == RequestType.edit) {
    specificRequest = request as EditRequestModel;
  } else if (request.type == RequestType.delete) {
    specificRequest = request as DeleteRequestModel;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            "تفاصيل الطلب",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
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
              "رقم الطلب: $index",
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
                        "سبب الحذف: ${specificRequest.reason}",
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
                        "الشعبة المرادة: شعبة ${specificRequest.section}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "الشعبة البديلة: شعبة ${specificRequest.alternativeSection}",
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
void _showCancelDialog(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'تراجع عن الطلب',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('هل أنت متأكد من أنك تريد التراجع عن هذا الطلب؟'),
        actions: [
          ElevatedButton(
            onPressed: () {
              final requests = Provider.of<RequestGroupProvider>(
                context,
                listen: false,
              );
              
              requests.removeRequest(
                index: index,
              );

              if (requests.requests.isEmpty) {
                requests.clear();
              }

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم التراجع عن الطلب بنجاح'),
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
            child: const Text('إلغاء'),
          ),
        ],
      );
    },
  );
}
