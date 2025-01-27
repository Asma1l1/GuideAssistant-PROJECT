import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/requests_provider.dart';

class AssociativeRequestScreen extends StatelessWidget {
  final DocumentReference studentRef;

  const AssociativeRequestScreen({Key? key, required this.studentRef})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('نموذج الطلبات الارتباطية'),
        backgroundColor: Color(0xFF3A6EA5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(
              context, '/StudentHomePage',
              arguments: studentRef),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/stHome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'هنا سوف تقوم بإنشاء طلبات تعتمد على بعضها بالترتيب لتحقيق طلب معين',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              SizedBox(height: 16),
              Text(
                'اختر نوع الطلب (${requestProvider.associativeRequests.length + 1}):',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                items: ['حذف مادة', 'إضافة مادة', 'تعديل شعبة']
                    .map((String value) =>
                        DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
                onChanged: (value) async {
                  if (value != null) {
                    requestProvider.createAssociativeRequest(studentRef, value);
                    Navigator.pushNamed(context, '/addRequestDetails',
                        arguments: {'type': value, 'studentRef': studentRef});
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    requestProvider.reorderAssociativeRequests(
                        oldIndex, newIndex);
                  },
                  children: requestProvider.associativeRequests
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    var request = entry.value;
                    return ListTile(
                      key: ValueKey(index),
                      title: Text('الطلب ${index + 1} - ${request['type']}'),
                      subtitle: Text(request['details'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          requestProvider.removeAssociativeRequest(index);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: requestProvider.associativeRequests.length >= 2
                    ? () async {
                        if (requestProvider.isValidAssociativeOrder()) {
                          await requestProvider
                              .submitAssociativeRequest(studentRef);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم إرسال الطلبات بنجاح')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'الرجاء إعادة ترتيب الطلبات لتجنب التعارض')),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      requestProvider.associativeRequests.length < 2
                          ? Colors.grey
                          : Color(0xFF3A6EA5),
                ),
                child: Text('إتمام',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/RequestFormScreen');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
