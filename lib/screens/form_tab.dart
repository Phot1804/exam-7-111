import 'package:flutter/material.dart';
import '../models/aqi_model.dart';
import '../controllers/aqi_controller.dart';

class FormTab extends StatefulWidget {
  const FormTab({super.key});

  @override
  State<FormTab> createState() => _FormTabState();
}

class _FormTabState extends State<FormTab> {
  final _formKey = GlobalKey<FormState>();
  final _aqiController = AqiController();

  final _stationIdController = TextEditingController();
  final _zoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _aqiValController = TextEditingController();
  final _pm25Controller = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newStation = AqiModel(
        stationId: _stationIdController.text.trim(),
        zone: _zoneController.text.trim(),
        safetyEmail: _emailController.text.trim(),
        aqi: double.parse(_aqiValController.text),
        pm25: double.parse(_pm25Controller.text),
      );

      await _aqiController.addStation(newStation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึกข้อมูลสถานีตรวจวัดสำเร็จ!')),
        );
        _formKey.currentState!.reset();
        _stationIdController.clear();
        _zoneController.clear();
        _emailController.clear();
        _aqiValController.clear();
        _pm25Controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _stationIdController,
              decoration: const InputDecoration(
                labelText: 'รหัสสถานีตรวจวัด (Sensor Station ID)',
                hintText: 'เช่น STATION-IND-EAST',
                border: OutlineInputBorder(),
              ),
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'กรุณาระบุรหัสสถานี' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _zoneController,
              decoration: const InputDecoration(
                labelText: 'บริเวณที่ตั้งในโรงงาน (Zone / Plant Area)',
                border: OutlineInputBorder(),
              ),
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'กรุณาระบุบริเวณที่ตั้ง' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'อีเมลเจ้าหน้าที่ความปลอดภัย (จป.)',
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return 'กรุณาระบุอีเมล';
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(val)) return 'รูปแบบอีเมลไม่ถูกต้อง';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _aqiValController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ดัชนีคุณภาพอากาศ (AQI: 0–500)',
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return 'กรุณาระบุค่า AQI';
                final num? aqiNum = num.tryParse(val);
                if (aqiNum == null || aqiNum < 0 || aqiNum > 1000) {
                  return 'ค่า AQI ต้องอยู่ระหว่าง 0–500';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pm25Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ค่าความเข้มข้น PM2.5 (µg/m³)',
                border: OutlineInputBorder(),
              ),
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'กรุณาระบุค่า PM2.5' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.save),
              label: const Text('บันทึกข้อมูลสถานี'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}