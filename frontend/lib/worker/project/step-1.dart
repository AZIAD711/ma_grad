import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/worker/project/step-2.dart';

class ProjectEditorPage1 extends StatefulWidget {
  const ProjectEditorPage1({super.key});

  @override
  State<ProjectEditorPage1> createState() => _ProjectEditorPageState();
}

class _ProjectEditorPageState extends State<ProjectEditorPage1> {
  List<File> selectedImages = [];
  List<int> uploadedMediaIds = [];
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool isUploading = false;

  String token = '';
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token') ?? '';
    userId = prefs.getInt('user_id') ?? 0;
    print('Token loaded: ${token.isNotEmpty}');
    print('User ID: $userId');
  }

  Future<Map<String, dynamic>> _uploadImage(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/project/media/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'type': 'image', 'url': base64Image}),
      );

      print('Upload Response Status: ${response.statusCode}');
      print('Upload Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        int mediaId = 0;

        if (responseData.containsKey('data') &&
            responseData['data'].containsKey('projectMediaId')) {
          mediaId = responseData['data']['projectMediaId'];
        } else if (responseData.containsKey('projectMediaId')) {
          mediaId = responseData['projectMediaId'];
        }

        return {'success': true, 'mediaId': mediaId};
      } else {
        return {'success': false, 'error': 'Failed to upload image'};
      }
    } catch (e) {
      print('Error uploading image: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> _uploadAllImages() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      List<int> mediaIds = [];
      int successCount = 0;

      for (var image in selectedImages) {
        final result = await _uploadImage(image);
        if (result['success']) {
          successCount++;
          if (result['mediaId'] != 0) {
            mediaIds.add(result['mediaId']);
          }
          print('✅ Image uploaded, Media ID: ${result['mediaId']}');
        }
      }

      if (successCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$successCount image(s) uploaded!'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectEditorPage(mediaIds: mediaIds),
            ),
          );
        });
      } else {
        setState(() {
          isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: isUploading ? null : () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
                Text(
                  'Upload Images',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: isUploading ? null : _uploadAllImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 3, 167, 170),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isUploading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Next', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading || isUploading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color.fromARGB(255, 3, 167, 170),
                        ),
                        SizedBox(height: 20),
                        Text(
                          isUploading ? 'Uploading images...' : 'Loading...',
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Images',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add images to your project',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                              255,
                              3,
                              167,
                              170,
                            ).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color.fromARGB(
                                255,
                                3,
                                167,
                                170,
                              ).withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Images',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _showImagePickerOptions(),
                                    icon: Icon(Icons.camera_alt),
                                    label: Text('Add Images'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        3,
                                        167,
                                        170,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              selectedImages.isEmpty
                                  ? _buildEmptyState()
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            childAspectRatio: 1,
                                          ),
                                      itemCount: selectedImages.length,
                                      itemBuilder: (context, index) =>
                                          _buildImageCard(index),
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
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 60, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              'No images selected',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              'Tap the Add Images button to select photos',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(selectedImages[index], fit: BoxFit.cover),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => setState(() => selectedImages.removeAt(index)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Images',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(Icons.camera_alt, 'Camera', Colors.blue, () {
                  Navigator.pop(context);
                  _takePhoto();
                }),
                _buildPickerOption(
                  Icons.photo_library,
                  'Gallery',
                  Colors.green,
                  () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                _buildPickerOption(
                  Icons.collections,
                  'Multiple',
                  Colors.orange,
                  () {
                    Navigator.pop(context);
                    _pickMultipleImages();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) setState(() => selectedImages.add(File(photo.path)));
  }

  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) setState(() => selectedImages.add(File(image.path)));
  }

  Future<void> _pickMultipleImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty)
      setState(() => selectedImages.addAll(images.map((e) => File(e.path))));
  }
}
