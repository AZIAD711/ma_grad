import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/other/login.dart';
import 'package:frontend/worker/project/step-1.dart';
import 'package:frontend/worker/chat-details.dart'; // Import your chat detail page
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  int _selectedTabIndex = 0;

  // User data
  String userName = 'Loading...';
  String userTitle = 'Worker';
  String projectsCount = '0';
  String hoursCount = '0';
  String reviewsCount = '0';
  String userEmail = '';
  String userPhone = '';
  String userRole = '';
  String userPhoto = '';
  Uint8List? userPhotoBytes;
  int userId = 0;
  String token = '';

  // Projects list
  List<Map<String, dynamic>> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token') ?? '';
    userId = prefs.getInt('user_id') ?? 0;

    print('=== PROFILE DEBUG ===');
    print(
      'Token: ${token.substring(0, token.length > 20 ? 20 : token.length)}...',
    );
    print('User ID: $userId');

    if (token.isNotEmpty && userId != 0) {
      await fetchUserProfile();
      await fetchUserProjects();
    } else {
      setState(() => isLoading = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  // Fix: Better base64 image decoding with error handling
  Uint8List? _base64ToImage(String base64String) {
    if (base64String.isEmpty) return null;

    try {
      String base64Image = base64String;
      // Remove data:image/jpeg;base64, prefix if present
      if (base64String.contains(',')) {
        base64Image = base64String.split(',').last;
      }
      return base64Decode(base64Image);
    } catch (e) {
      print('Error decoding base64 image: $e');
      return null;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('User Profile Response Status: ${response.statusCode}');
      print('User Profile Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> userData = data.containsKey('data')
            ? data['data']
            : data;

        print('User Data: $userData');
        print('Photo field: ${userData['photo']}');
        print('Photo length: ${userData['photo']?.length ?? 0}');

        setState(() {
          userName = userData['name'] ?? 'User';
          userEmail = userData['email'] ?? '';
          userPhone = userData['phoneNumber'] ?? '';
          userRole = userData['role'] ?? 'worker';
          userPhoto = userData['photo'] ?? '';

          // Try to decode the photo
          if (userPhoto.isNotEmpty) {
            userPhotoBytes = _base64ToImage(userPhoto);
            print('Photo decoded: ${userPhotoBytes != null}');
          } else {
            print('No photo found for user');
          }

          userTitle = userRole == 'worker' ? 'Professional Worker' : 'Client';
        });
      } else {
        print('Failed to fetch user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> fetchUserProjects() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/project/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Projects Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<dynamic> allProjects = [];

        if (responseData is List) {
          allProjects = responseData;
        } else if (responseData.containsKey('data') &&
            responseData['data'] is List) {
          allProjects = responseData['data'];
        }

        print('Total projects: ${allProjects.length}');

        final userProjects = allProjects.where((project) {
          int projectWorkerId =
              project['workerId'] ?? project['worker_id'] ?? 0;
          return projectWorkerId == userId;
        }).toList();

        print('User projects: ${userProjects.length}');

        setState(() {
          projects = userProjects.map((project) {
            return {
              'id': project['projectId'] ?? project['id'],
              'title': project['name'] ?? 'Untitled',
              'description': project['description'] ?? 'No description',
              'created_at': project['created_at'],
              'images': [],
            };
          }).toList();
          projectsCount = projects.length.toString();
        });

        for (var project in projects) {
          await fetchProjectMedia(project['id']);
        }

        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error loading projects: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchProjectMedia(int projectId) async {
    try {
      print('Fetching media for project ID: $projectId');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/project/media/$projectId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
        'Media Response Status for project $projectId: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        Map<String, dynamic> mediaData = {};

        if (responseData.containsKey('data') && responseData['data'] is Map) {
          mediaData = Map<String, dynamic>.from(responseData['data']);
        } else if (responseData is Map) {
          mediaData = Map<String, dynamic>.from(responseData);
        }

        final index = projects.indexWhere((p) => p['id'] == projectId);
        if (index != -1 && mediaData.isNotEmpty && mediaData['url'] != null) {
          setState(() {
            projects[index]['images'] = [
              {
                'url': mediaData['url'],
                'type': mediaData['type'],
                'projectMediaId': mediaData['projectMediaId'],
              },
            ];
          });
        }
      }
    } catch (e) {
      print('Error fetching media for project $projectId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Section
          Container(
            padding: EdgeInsets.all(20),
            color: Color.fromARGB(255, 3, 167, 170),
            child: Column(
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: userPhotoBytes != null
                      ? MemoryImage(userPhotoBytes!)
                      : null,
                  child: userPhotoBytes == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: Color.fromARGB(255, 3, 167, 170),
                        )
                      : null,
                ),
                SizedBox(height: 10),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  userTitle,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(projectsCount, 'Projects'),
                    _buildStat(hoursCount, 'Hours'),
                    _buildStat(reviewsCount, 'Reviews'),
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

          Expanded(child: _getTabContent()),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectEditorPage1(),
                  ),
                ).then((_) => fetchUserProjects());
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
      onTap: () => setState(() => _selectedTabIndex = index),
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

  // Work Tab - Display Projects with Images
  Widget _buildWorkTab() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color.fromARGB(255, 3, 167, 170)),
            SizedBox(height: 20),
            Text('Loading projects...'),
          ],
        ),
      );
    }

    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 80, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              'No projects yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              'Tap + button to create your first project',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(15),
      children: projects.map((project) => _buildProjectCard(project)).toList(),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    List<dynamic> images = project['images'] ?? [];
    String? firstImageUrl = images.isNotEmpty ? images[0]['url'] : null;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 3, 167, 170).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: firstImageUrl != null
                ? _buildImageFromBase64(firstImageUrl)
                : Icon(
                    Icons.image,
                    size: 40,
                    color: Color.fromARGB(255, 3, 167, 170),
                  ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  project['description'],
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                if (images.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.image, size: 14, color: Colors.grey[500]),
                      SizedBox(width: 5),
                      Text(
                        '1 image',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFromBase64(String base64String) {
    try {
      String base64Image = base64String;
      if (base64String.contains(',')) {
        base64Image = base64String.split(',').last;
      }
      Uint8List imageBytes = base64Decode(base64Image);
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        ),
      );
    } catch (e) {
      print('Error decoding image: $e');
      return Icon(Icons.broken_image, size: 40, color: Colors.grey[400]);
    }
  }

  // Info Tab
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Color.fromARGB(255, 3, 167, 170),
                  backgroundImage: userPhotoBytes != null
                      ? MemoryImage(userPhotoBytes!)
                      : null,
                  child: userPhotoBytes == null
                      ? Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt, size: 16),
                  label: Text('Change Photo'),
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 3, 167, 170),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Text(
            'About',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Professional worker with experience in various fields.',
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          SizedBox(height: 25),
          Text(
            'Contact Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildContactTile(Icons.person, userName),
          _buildContactTile(Icons.email, userEmail),
          _buildContactTile(Icons.phone, userPhone),
          _buildContactTile(
            Icons.work,
            userRole == 'worker' ? 'Worker' : 'Client',
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 3, 167, 170),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chat Tab - With Navigation to ChatDetailPage
  Widget _buildChatTab() {
    // List of chats - you can fetch this from API
    List<Map<String, dynamic>> chats = [
      {
        'name': 'Sarah Johnson',
        'isOnline': true,
        'lastMessage': 'Hello! How are you?',
        'time': '10:30 AM',
      },
      {
        'name': 'Michael Brown',
        'isOnline': false,
        'lastMessage': 'Can you help me with my project?',
        'time': 'Yesterday',
      },
      {
        'name': 'Emily Davis',
        'isOnline': true,
        'lastMessage': 'Great work!',
        'time': 'Yesterday',
      },
      {
        'name': 'David Wilson',
        'isOnline': false,
        'lastMessage': 'Thanks for your help',
        'time': '2 days ago',
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatItem(
          chat['name'],
          chat['isOnline'],
          chat['lastMessage'],
          chat['time'],
        );
      },
    );
  }

  // Updated chat item with navigation
  Widget _buildChatItem(
    String name,
    bool isOnline,
    String lastMessage,
    String time,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to Chat Detail Page using Navigator.push
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatDetailPage(name: name, isOnline: isOnline),
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
            // Chat Info
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
                  SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
