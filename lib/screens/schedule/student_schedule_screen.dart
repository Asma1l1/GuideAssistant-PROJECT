import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/schedule_model.dart';
import '../../providers/schedule_provider.dart';

class ScheduleScreen extends StatefulWidget {
  final DocumentReference studentRef;

  ScheduleScreen({required this.studentRef});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleProvider>(context, listen: false)
          .fetchSchedule(widget.studentRef);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final scheduleList = scheduleProvider.scheduleList;

    return Scaffold(
      appBar: AppBar(
        title: Text('الجدول الدراسي'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: scheduleProvider.scheduleList.isEmpty
          ? Center(child: Text('لا يوجد جدول دراسي متاح حالياً'))
          : Column(
              children: [
                _buildScheduleHeader(),
                Expanded(
                  child: ListView.builder(
                    itemCount: scheduleList.length,
                    itemBuilder: (context, index) {
                      final course = scheduleList[index];
                      return _buildCourseCard(course);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildScheduleHeader() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.teal.shade700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس']
            .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCourseCard(ScheduleModel course) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              course.courseRef.path.split('/').last,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                _showCourseDetails(course);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseDetails(ScheduleModel course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل المادة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('المحاضر', course.instructor),
            _buildDetailRow('الموقع', course.location),
            _buildDetailRow('اليوم', course.day),
            _buildDetailRow('الوقت', course.time),
            _buildDetailRow('النوع', course.type),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
