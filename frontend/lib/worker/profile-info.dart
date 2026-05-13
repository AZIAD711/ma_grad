import 'package:flutter/material.dart';
import 'package:frontend/other/login.dart';
import 'package:frontend/worker/profile-chat.dart';
import 'package:frontend/worker/profile.dart';

class WorkerProfilePageInfo extends StatefulWidget {
  const WorkerProfilePageInfo({super.key});

  @override
  State<WorkerProfilePageInfo> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePageInfo> {
  int _selectedTabIndex = 1; // Start with Info tab (index 1)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Color.fromARGB(255, 3, 167, 170),
            child: Column(
              children: [
                SizedBox(height: 40),
                // Profile Image
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Color.fromARGB(255, 3, 167, 170),
                  ),
                ),
                SizedBox(height: 15),
                // Name
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Professional Worker',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('00', 'Projects'),
                    _buildStatColumn('00', 'Hours'),
                    _buildStatColumn('00', 'Reviews'),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Tab Bar
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

          // Content Area
          Expanded(child: _getTabContent()),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (title == 'Work') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkerProfilePage()),
          );
        } else if (title == 'Chat') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkerProfilePageChat()),
          );
        } else {
          setState(() {
            _selectedTabIndex = index;
          });
        }
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
        return _buildInfoTab();
    }
  }

  // Work Tab
  Widget _buildWorkTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'No work yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
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
          _buildContactTile(Icons.person, 'John doe'),
          _buildContactTile(Icons.email, 'johndoe@example.com'),
          _buildContactTile(Icons.phone, '+20 123 456 789'),
          _buildContactTile(Icons.location_on, 'Egypt, Cairo'),
          _buildContactTile(Icons.card_travel, '12345678910'),
          _buildContactTile(Icons.group_work, 'Painter'),

          SizedBox(height: 30),

          // Centered Button
          Center(
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 3, 167, 170),
                    Color.fromARGB(255, 2, 140, 143),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 3, 167, 170).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkerProfilePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Chat Tab
  Widget _buildChatTab() {
    return ListView(
      padding: EdgeInsets.all(15),
      children: [
        _buildChatMessage(
          'Sarah Johnson',
          'Hello, interested in your work...',
          '10:30 AM',
          true,
        ),
        _buildChatMessage(
          'Michael Brown',
          'Can you help me with my project?',
          'Yesterday',
          false,
        ),
        _buildChatMessage(
          'Emily Davis',
          'Great portfolio! Let\'s work together',
          'Yesterday',
          true,
        ),
        _buildChatMessage(
          'David Wilson',
          'Price negotiation for the project',
          '2 days ago',
          false,
        ),
      ],
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

  Widget _buildChatMessage(
    String name,
    String message,
    String time,
    bool isOnline,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Color.fromARGB(
                  255,
                  3,
                  167,
                  170,
                ).withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Color.fromARGB(255, 3, 167, 170),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
