import 'package:flutter/material.dart';
import 'package:frontend/other/login.dart';
import 'package:frontend/other/role-page.dart';
import 'package:frontend/worker/chat-details.dart';
import 'package:frontend/worker/project/step-1.dart';
// import 'chat_detail_page.dart'; // Import your chat detail page

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  int _selectedTabIndex = 0; // 0: Work, 1: Info, 2: Chat

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
                _buildTab('Work', 0),
                _buildTab('Info', 1),
                _buildTab('Chat', 2),
              ],
            ),
          ),

          // Content Area based on selected tab
          Expanded(child: _getTabContent()),
        ],
      ),
      // Floating Plus Button at Bottom Center
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectEditorPage1()),
                );
              },
              backgroundColor: Color.fromARGB(255, 3, 167, 170),
              child: Icon(Icons.add, size: 30, color: Colors.white),
            )
          : null,
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

  Widget _buildTab(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
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
      ),
    );
  }

  Widget _getTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildWorkTab();
      case 1:
        return _buildInfoTab();
      case 2:
        return _buildChatTab();
      default:
        return _buildWorkTab();
    }
  }

  // Work Tab - Projects
  Widget _buildWorkTab() {
    return ListView(
      padding: EdgeInsets.all(15),
      children: [
        _buildProjectCard(),
        SizedBox(height: 10),
        _buildProjectCard(),
        SizedBox(height: 10),
        _buildProjectCard(),
      ],
    );
  }

  // Info Tab
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Professional worker with 5+ years of experience in various fields.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          SizedBox(height: 25),

          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          _buildContactTile(Icons.person, 'John Doe'),
          _buildContactTile(Icons.email, 'johndoe@example.com'),
          _buildContactTile(Icons.phone, '+20 123 456 789'),
          _buildContactTile(Icons.location_on, 'Egypt, Cairo'),
        ],
      ),
    );
  }

  // Chat Tab
  Widget _buildChatTab() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        _buildChatItem('Sarah Johnson', true),
        _buildChatItem('Michael Brown', false),
        _buildChatItem('Emily Davis', true),
        _buildChatItem('David Wilson', false),
        _buildChatItem('Jessica Lee', true),
        _buildChatItem('Chris Martin', false),
        _buildChatItem('Anna White', true),
        _buildChatItem('Robert Taylor', false),
      ],
    );
  }

  Widget _buildChatItem(String name, bool isOnline) {
    return InkWell(
      onTap: () {
        // Navigate to Chat Detail Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(name: name, isOnline: true),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[100]!, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 3, 167, 170),
                        Color.fromARGB(255, 2, 140, 143),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 15),

            // Name and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 13,
                      color: isOnline ? Colors.green : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 3, 167, 170).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: Color.fromARGB(255, 3, 167, 170),
              ),
            ),
          ],
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

  Widget _buildContactTile(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 3, 167, 170).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Color.fromARGB(255, 3, 167, 170),
            ),
          ),
          SizedBox(width: 15),
          Text(text, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
