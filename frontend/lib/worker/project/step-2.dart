import 'package:flutter/material.dart';
import 'package:frontend/worker/profile.dart';
import 'package:frontend/worker/project/step-1.dart';

class ProjectEditorPage extends StatefulWidget {
  const ProjectEditorPage({super.key});

  @override
  State<ProjectEditorPage> createState() => _ProjectEditorPageState();
}

class _ProjectEditorPageState extends State<ProjectEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isTitleFocused = false;
  bool _isDescriptionFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button with icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectEditorPage1(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  // Title
                  Text(
                    'New Project',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  // Placeholder for symmetry
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
                    // Animated Title Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isTitleFocused
                              ? Color.fromARGB(255, 3, 167, 170)
                              : Colors.grey[200]!,
                          width: _isTitleFocused ? 2 : 1,
                        ),
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
                                fontWeight: FontWeight.w500,
                                color: _isTitleFocused
                                    ? Color.fromARGB(255, 3, 167, 170)
                                    : Colors.grey[500],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _titleController,
                            // onFocusChange: (focused) {
                            //   setState(() {
                            //     _isTitleFocused = focused;
                            //   });
                            // },
                            decoration: InputDecoration(
                              hintText: 'e.g., Mobile App Development',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Animated Description Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isDescriptionFocused
                              ? Color.fromARGB(255, 3, 167, 170)
                              : Colors.grey[200]!,
                          width: _isDescriptionFocused ? 2 : 1,
                        ),
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
                                fontWeight: FontWeight.w500,
                                color: _isDescriptionFocused
                                    ? Color.fromARGB(255, 3, 167, 170)
                                    : Colors.grey[500],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _descriptionController,
                            // onFocusChange: (focused) {
                            //   setState(() {
                            //     _isDescriptionFocused = focused;
                            //   });
                            // },
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: 'Describe your project details...',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Character Counter for Description
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_descriptionController.text.length} characters',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Next Button with Gradient
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
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(
                              255,
                              3,
                              167,
                              170,
                            ).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titleController.text.isEmpty) {
                            _showSnackBar(
                              'Please enter a project title',
                              Colors.red,
                            );
                            return;
                          }
                          if (_descriptionController.text.isEmpty) {
                            _showSnackBar(
                              'Please enter a description',
                              Colors.red,
                            );
                            return;
                          }

                          // Show success message then navigate
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Project created successfully!'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ),
                          );

                          // Navigate to your existing class after a short delay
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkerProfilePage(),
                              ), // Replace with your class name
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Create Project',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Optional tip
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                          255,
                          3,
                          167,
                          170,
                        ).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 20,
                            color: Color.fromARGB(255, 3, 167, 170),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tip: Be specific with your project title and description to attract the right workers.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
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
