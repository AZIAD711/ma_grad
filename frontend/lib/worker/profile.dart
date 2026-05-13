import 'package:flutter/material.dart';
import 'package:frontend/other/role-page.dart';

class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Name Section
          Container(
            padding: EdgeInsets.all(20),
            color: Color.fromARGB(255, 3, 167, 170),
            child: Column(
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color.fromARGB(255, 3, 167, 170),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Professional Worker',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('00', 'Projects'),
                    _buildStat('00', 'Hours'),
                    _buildStat('00', 'Reviews'),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Tab Bar - Work, Info, Chat
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('Work', true),
                _buildTab('Info', false),
                _buildTab('Chat', false),
              ],
            ),
          ),

          // Content Area - Projects
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                _buildProjectCard(),
                SizedBox(height: 10),
                _buildProjectCard(),
                SizedBox(height: 10),
                _buildProjectCard(),
              ],
            ),
          ),
        ],
      ),
      // Floating Plus Button at Bottom Center
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to your existing class/page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RolePage()),
          );
        },
        backgroundColor: Color.fromARGB(255, 3, 167, 170),
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive
                ? Color.fromARGB(255, 3, 167, 170)
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Color.fromARGB(255, 3, 167, 170) : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProjectCard() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Image/Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 3, 167, 170).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.image,
              size: 40,
              color: Color.fromARGB(255, 3, 167, 170),
            ),
          ),
          SizedBox(width: 15),
          // Project Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Title',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Project description goes here...',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 5),
                    Text('4.5', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 10),
                    Icon(Icons.people, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text('10 reviews', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
