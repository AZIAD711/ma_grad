import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/worker/profile.dart';
import 'package:frontend/worker/project/step-1.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectEditorPage extends StatefulWidget {
  final List<int> mediaIds;
  const ProjectEditorPage({super.key, this.mediaIds = const []});

  @override
  State<ProjectEditorPage> createState() => _ProjectEditorPageState();
}

class _ProjectEditorPageState extends State<ProjectEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCreating = false;
  String token = '';
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadToken();
    print('Media IDs to update: ${widget.mediaIds}');
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token') ?? '';
    userId = prefs.getInt('user_id') ?? 0;
  }

  Future<Map<String, dynamic>> _createProject() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/project/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'workerId': userId,
      }),
    );

    print('Create Project Status: ${response.statusCode}');
    print('Create Project Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      int projectId = 0;

      if (data.containsKey('data') && data['data'].containsKey('projectId')) {
        projectId = data['data']['projectId'];
      } else if (data.containsKey('projectId')) {
        projectId = data['projectId'];
      }

      return {'success': true, 'projectId': projectId};
    }
    return {'success': false, 'error': 'Failed to create project'};
  }

  Future<Map<String, dynamic>> _updateProjectMedia(
    int mediaId,
    int projectId,
  ) async {
    print('Updating media ID $mediaId with project ID $projectId');

    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/project/media/update/$mediaId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'projectId': projectId}),
    );

    print('Update Media $mediaId Status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true};
    }
    return {'success': false};
  }

  Future<void> _handleCreateProject() async {
    if (_titleController.text.isEmpty) {
      _showSnackBar('Please enter a project title', Colors.red);
      return;
    }
    if (_descriptionController.text.isEmpty) {
      _showSnackBar('Please enter a description', Colors.red);
      return;
    }

    setState(() => _isCreating = true);

    try {
      // Step 1: Create Project
      final projectResult = await _createProject();
      if (!projectResult['success']) throw Exception(projectResult['error']);

      int projectId = projectResult['projectId'];
      print('✅ Project created with ID: $projectId');

      // Step 2: Update all media with project ID
      int updateCount = 0;
      for (var mediaId in widget.mediaIds) {
        final updateResult = await _updateProjectMedia(mediaId, projectId);
        if (updateResult['success']) {
          updateCount++;
          print('✅ Media ID $mediaId updated');
        } else {
          print('❌ Failed to update media ID $mediaId');
        }
      }

      print('Updated $updateCount/${widget.mediaIds.length} media records');

      _showSnackBar('Project created successfully!', Colors.green);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WorkerProfilePage()),
        );
      });
    } catch (e) {
      print('Error: $e');
      _showSnackBar('Error: ${e.toString()}', Colors.red);
      setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProjectEditorPage1(),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  Text(
                    'New Project',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                          255,
                          3,
                          167,
                          170,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Color.fromARGB(255, 3, 167, 170),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${widget.mediaIds.length} image(s) uploaded',
                            style: TextStyle(
                              color: Color.fromARGB(255, 3, 167, 170),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Title Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16, top: 12),
                            child: Text(
                              'Project Title',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          TextField(
                            controller: _titleController,
                            enabled: !_isCreating,
                            decoration: InputDecoration(
                              hintText: 'e.g., Mobile App Development',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Description Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16, top: 12),
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 6,
                            enabled: !_isCreating,
                            decoration: InputDecoration(
                              hintText: 'Describe your project details...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),

                    // Create Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 3, 167, 170),
                            Color.fromARGB(255, 2, 140, 143),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        onPressed: _isCreating ? null : _handleCreateProject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: _isCreating
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Create Project',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
