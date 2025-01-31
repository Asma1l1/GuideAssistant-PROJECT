import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muieen_project/models/advisor_model.dart';
import 'package:muieen_project/models/request_model.dart';
import 'package:muieen_project/providers/advisor_provider.dart';
import 'package:muieen_project/providers/auth_provider.dart';
import 'package:muieen_project/screens/widgets/student_app_drawer.dart';
import 'package:muieen_project/screens/widgets/customAppBar.dart';
import 'package:provider/provider.dart';

import '../widgets/advisor_app_drawer.dart';

class AdvisorHomePage extends StatelessWidget {
  const AdvisorHomePage({super.key});

  // Fetch data from Firestore
  Future<List<RequestGroupModel>> fetchRequests(AdvisorModel advisor) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where(
            "advisorRef.email", // Query based on the email field in the advisorRef map
            isEqualTo: advisor.email, // Compare with the advisor's email
          )
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return RequestGroupModel.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print("🔥 Error fetching requests: $e");
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).user;
    final advisor =
        Provider.of<AdvisorProvider>(context, listen: false).advisor;
    print(advisor!.email.toString());
    // if (advisor == null) {
    //   return const Scaffold(
    //     body: Center(
    //       child: Text('يرجى تسجيل الدخول'),
    //     ),
    //   );
    // }

    return Scaffold(
      backgroundColor: const Color(0xFFe1e5e6),
      endDrawer: const AdvisorAppDrawer(),
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
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: CustomAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/StudentNotificationsScreen");
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.yellow,
                ),
              ),
              title: const Text(
                'الصفحة الرئيسية',
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
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
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
                // Fetch and display requests
                Expanded(
                  child: FutureBuilder<List<RequestGroupModel>>(
                    future: fetchRequests(advisor!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'لا يوجد طلبات',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      } else {
                        final requestGroups = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.all(30),
                          itemCount: requestGroups.length,
                          itemBuilder: (context, index) {
                            final requestGroup = requestGroups[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/StudentAcademicProfilePage',
                                  arguments: requestGroup.studentRef,
                                );
                              },
                              child: CustomWidget(
                                requestGroup: requestGroup,
                                numberOfGroups: requestGroup.requests.length,
                              ),
                            );
                          },
                        );
                      }
                    },
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

class CustomWidget extends StatelessWidget {
  const CustomWidget({
    super.key,
    required this.requestGroup,
    required this.numberOfGroups,
  });

  final RequestGroupModel requestGroup;
  final int numberOfGroups;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // info
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الاسم: ${requestGroup.studentRef.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "الرقم الجامعي: ${requestGroup.studentRef.studentNumber}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "المستوى: ${requestGroup.studentRef.level}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "حالة الطالب: ${requestGroup.studentRef.studentStatus}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // cards
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/AdvisorRequestsLogPage',
                    arguments: requestGroup,
                  );
                },
                child: MiniCards(
                  numberOfGroups: numberOfGroups,
                  header: const Text(
                    "عدد الطلبات",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  footer: Text(
                    numberOfGroups.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              MiniCards(
                numberOfGroups: numberOfGroups,
                header: const Text(
                  "طلب ارتباطي",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                footer: Icon(
                  requestGroup.isOrdered ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class MiniCards extends StatelessWidget {
  const MiniCards({
    super.key,
    required this.numberOfGroups,
    required this.header,
    required this.footer,
  });

  final int numberOfGroups;
  final Widget header;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A5E71),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            header,
            const SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Container(
                color: const Color(0xFF1F4553),
                padding: const EdgeInsets.all(5), // Adjust padding as needed
                child: footer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
