import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'form_tab.dart';
import 'display_tab.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel currentUser;

  const HomeScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('EnviroSense (${currentUser.role})'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign Out',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.edit_note), text: 'บันทึกข้อมูล'),
              Tab(icon: Icon(Icons.dashboard), text: 'กระดานเฝ้าระวัง'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const FormTab(),
            DisplayTab(userRole: currentUser.role),
          ],
        ),
      ),
    );
  }
}