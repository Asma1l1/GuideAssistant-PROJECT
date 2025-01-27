import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestFormScreen extends StatefulWidget {
  final String type;
  final DocumentReference studentRef;

  const RequestFormScreen({Key? key, required this.type, required this.studentRef}) : super(key: key);

  @override
  _RequestFormScreenState createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCourse;
  String? reason;
  String? newSection;

  List<String> courses = ['601101', '140111', '605101'];
  List<String> sections = ['S1', 'S2', 'S3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نموذج طلب ${widget.type}'),
        backgroundColor: Color(0xFF3A6EA5),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_pattern.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.type == 'حذف مادة'
                      ? 'حدد المادة التي ترغب في حذفها:'
                      : widget.type == 'إضافة مادة'
                          ? 'حدد المادة التي ترغب في إضافتها:'
                          : 'حدد المادة التي ترغب في تغيير شعبتها:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  items: courses.map((String course) {
                    return DropdownMenuItem(value: course, child: Text(course));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCourse = value;
                    });
                  },
                  decoration: InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  validator: (value) => value == null ? 'يرجى اختيار المادة' : null,
                ),
                if (widget.type == 'تعديل شعبة') ...[
                  SizedBox(height: 20),
                  Text(
                    'اختر الشعبة الجديدة:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<String>(
                    items: sections.map((String section) {
                      return DropdownMenuItem(value: section, child: Text(section));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        newSection = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  ),
                ],
                if (widget.type == 'حذف مادة') ...[
                  SizedBox(height: 20),
                  Text(
                    'ادخل سبب الحذف:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        reason = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'سبب الحذف',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال السبب' : null,
                  ),
                ],
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await FirebaseFirestore.instance.collection('requests').add({
                        'studentRef': widget.studentRef,
                        'type': widget.type,
                        'course': selectedCourse,
                        'reason': reason,
                        'newSection': newSection,
                        'status': 'قيد التنفيذ',
                        'dateSubmitted': Timestamp.now(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال الطلب بنجاح')));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3A6EA5),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('إتمام', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
