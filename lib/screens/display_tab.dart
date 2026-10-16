import 'package:flutter/material.dart';
import '../models/aqi_model.dart';
import '../controllers/aqi_controller.dart';

class DisplayTab extends StatelessWidget {
  final String userRole;
  final AqiController _aqiController = AqiController();

  DisplayTab({super.key, required this.userRole});

  // Dialog สำหรับปรับแต่งค่า Calibrate (เฉพาะ Admin)
  void _showEditDialog(BuildContext context, AqiModel item) {
    final aqiEditController = TextEditingController(text: item.aqi.toString());
    final pm25EditController = TextEditingController(text: item.pm25.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Calibrate ค่าเซนเซอร์: ${item.stationId}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: aqiEditController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ปรับค่า AQI'),
            ),
            TextField(
              controller: pm25EditController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ปรับค่า PM2.5'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              aqiEditController.dispose();
              pm25EditController.dispose();
              Navigator.of(ctx).pop();
            },
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedItem = AqiModel(
                id: item.id,
                stationId: item.stationId,
                zone: item.zone,
                safetyEmail: item.safetyEmail,
                aqi: double.tryParse(aqiEditController.text) ?? item.aqi,
                pm25: double.tryParse(pm25EditController.text) ?? item.pm25,
              );

              await _aqiController.updateStation(item.id!, updatedItem);
              
              aqiEditController.dispose();
              pm25EditController.dispose();

              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('บันทึกการปรับปรุง'),
          ),
        ],
      ),
    );
  }

  // Dialog ยืนยันการลบข้อมูล (เฉพาะ Admin)
  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบข้อมูล'),
        content: const Text('คุณต้องการลบรายการสถานีตรวจวัดนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _aqiController.deleteStation(docId);
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบข้อมูล', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // รองรับทั้ง Admin / admin
    final bool isAdmin = userRole.toLowerCase() == 'admin';

    return StreamBuilder<List<AqiModel>>(
      stream: _aqiController.getStationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('ยังไม่มีข้อมูลสถานีตรวจวัด'));
        }

        final stations = snapshot.data!;

        return ListView.builder(
          itemCount: stations.length,
          itemBuilder: (context, index) {
            final item = stations[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.aqi > 100 ? Colors.red : Colors.green,
                  child: Text(
                    '${item.aqi.toInt()}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                title: Text('${item.stationId} (${item.zone})'),
                subtitle: Text('PM2.5: ${item.pm25} µg/m³ | จป: ${item.safetyEmail}'),
                trailing: isAdmin
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(context, item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, item.id!),
                          ),
                        ],
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}