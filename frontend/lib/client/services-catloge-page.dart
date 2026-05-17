import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceCataloguePage extends StatefulWidget {
  const ServiceCataloguePage({super.key});

  @override
  State<ServiceCataloguePage> createState() => _ServiceCataloguePageState();
}

class _ServiceCataloguePageState extends State<ServiceCataloguePage> {
  List<Project> _projects = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _searchQuery;

  // Filter options
  String? _selectedCategory;
  final List<String> _categories = [
    'All',
    'AC Repair',
    'Painting',
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      print('=== Loading Projects ===');
      print('Token: $token');

      if (token == null) {
        setState(() {
          _errorMessage = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      // Fetch all projects
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/project'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Projects API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        List<dynamic> projectsData = [];

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          projectsData = responseData['data'];
        } else if (responseData is List) {
          projectsData = responseData;
        }

        List<Project> tempProjects = [];

        // Load worker and media data for each project
        for (var project in projectsData) {
          Project newProject = Project.fromJson(project);

          // Fetch worker data
          if (newProject.workerId != null) {
            await _fetchWorkerData(newProject, token);
          }

          // Fetch project media (single object with type and url)
          await _fetchProjectMedia(newProject, token);

          tempProjects.add(newProject);
        }

        setState(() {
          _projects = tempProjects;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      print('Error loading projects: $e');
      setState(() {
        _errorMessage = 'Failed to load projects: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWorkerData(Project project, String token) async {
    try {
      // Fetch user data first
      final userResponse = await http.get(
        Uri.parse('http://10.0.2.2:3000/user/${project.workerId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        Map<String, dynamic> userMap;

        if (userData is Map<String, dynamic> && userData.containsKey('data')) {
          userMap = userData['data'];
        } else {
          userMap = userData;
        }

        project.workerName = userMap['name'] ?? 'Unknown';
        project.workerEmail = userMap['email'] ?? '';
        project.workerPhone =
            userMap['phoneNumber'] ?? userMap['phone_number'] ?? '';
      }

      // Fetch worker specific data
      final workerResponse = await http.get(
        Uri.parse('http://10.0.2.2:3000/worker/${project.workerId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (workerResponse.statusCode == 200) {
        final workerData = jsonDecode(workerResponse.body);
        Map<String, dynamic> workerMap;

        if (workerData is Map<String, dynamic> &&
            workerData.containsKey('data')) {
          workerMap = workerData['data'];
        } else {
          workerMap = workerData;
        }

        project.workerSpecialization = workerMap['specialization'] ?? '';
        // Safely parse rating to double (could be int, double or string)
        var rawRating = workerMap['rating'] ?? 4.5;
        double parsedRating;
        if (rawRating is num) {
          parsedRating = rawRating.toDouble();
        } else {
          parsedRating = double.tryParse(rawRating.toString()) ?? 4.5;
        }
        project.workerRating = parsedRating;
        project.workerExperience = workerMap['experience'] ?? 'N/A';
      }
    } catch (e) {
      print('Error fetching worker data: $e');
    }
  }

  Future<void> _fetchProjectMedia(Project project, String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/project/media/${project.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Media API Response Status: ${response.statusCode}');
      print('Media API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final mediaData = jsonDecode(response.body);

        // Handle single media object with type and url
        if (mediaData is Map<String, dynamic>) {
          String? type = mediaData['type']?.toString();
          String? url = mediaData['url']?.toString();

          if (type == 'image' && url != null && url.isNotEmpty) {
            if (url.startsWith('data:image')) {
              // It's a base64 image
              project.base64Image = url;
            } else {
              // It's a regular URL
              project.imageUrl = url;
            }
          }
        }
      } else if (response.statusCode == 404) {
        print('No media found for project ${project.id}');
      }
    } catch (e) {
      print('Error fetching media: $e');
    }
  }

  List<Project> get _filteredProjects {
    var filtered = _projects;

    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered = filtered
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      filtered = filtered
          .where(
            (p) =>
                p.title.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
                p.description.toLowerCase().contains(
                  _searchQuery!.toLowerCase(),
                ) ||
                (p.workerName?.toLowerCase().contains(
                      _searchQuery!.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Service Catalogue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 46, 46, 45),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProjects),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search Bar
                Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 3, 167, 170),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Loading services...'),
                ],
              ),
            )
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProjects,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 167, 170),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Category Filter
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: const Color.fromARGB(255, 3, 167, 170),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Projects Grid
                Expanded(
                  child: _filteredProjects.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No services found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: _filteredProjects.length,
                          itemBuilder: (context, index) {
                            return _buildProjectCard(_filteredProjects[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return GestureDetector(
      onTap: () {
        _showProjectDetails(project);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: _buildProjectImage(project, height: 120),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        3,
                        167,
                        170,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      project.category,
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color.fromARGB(255, 3, 167, 170),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Text(
                    '\$${project.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // // Worker Info
                  // if (project.workerName != null)
                  //   Row(
                  //     children: [
                  //       const Icon(Icons.person, size: 12, color: Colors.grey),
                  //       const SizedBox(width: 4),
                  //       Expanded(
                  //         child: Text(
                  //           project.workerName!,
                  //           style: TextStyle(
                  //             fontSize: 10,
                  //             color: Colors.grey.shade600,
                  //           ),
                  //           maxLines: 1,
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //       ),
                  //     ],
                  //   ),

                  // // Rating
                  // if (project.workerRating != null)
                  //   Row(
                  //     children: [
                  //       const Icon(Icons.star, size: 12, color: Colors.amber),
                  //       const SizedBox(width: 4),
                  //       Text(
                  //         project.workerRating!.toString(),
                  //         style: TextStyle(
                  //           fontSize: 11,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.grey.shade700,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 4),
                  //       Text(
                  //         '(${project.workerExperience})',
                  //         style: TextStyle(
                  //           fontSize: 9,
                  //           color: Colors.grey.shade500,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectImage(Project project, {required double height}) {
    // Check if we have a base64 image
    if (project.base64Image != null && project.base64Image!.isNotEmpty) {
      try {
        String base64Data = _extractBase64Data(project.base64Image!);
        return Image.memory(
          base64Decode(base64Data),
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error decoding base64 image: $error');
            return _buildPlaceholderImage(height);
          },
        );
      } catch (e) {
        print('Error parsing base64 image: $e');
        return _buildPlaceholderImage(height);
      }
    }

    // Check if we have a URL image
    if (project.imageUrl != null && project.imageUrl!.isNotEmpty) {
      // Check if it's a full URL or relative path
      String imageUrl = project.imageUrl!.startsWith('http')
          ? project.imageUrl!
          : 'http://10.0.2.2:3000${project.imageUrl!}';

      return Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image: $error');
          return _buildPlaceholderImage(height);
        },
      );
    }

    // Default placeholder
    return _buildPlaceholderImage(height);
  }

  Widget _buildPlaceholderImage(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color.fromARGB(255, 3, 167, 170).withOpacity(0.1),
      child: const Icon(
        Icons.build,
        size: 40,
        color: Color.fromARGB(255, 3, 167, 170),
      ),
    );
  }

  String _extractBase64Data(String base64String) {
    // Extract the actual base64 data from "data:image/jpeg;base64,xxxxx"
    if (base64String.contains(',')) {
      return base64String.split(',').last;
    }
    return base64String;
  }

  void _showProjectDetails(Project project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Project Image (Full size)
                          _buildProjectImage(project, height: 250),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      3,
                                      167,
                                      170,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    project.category,
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        3,
                                        167,
                                        170,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Title
                                Text(
                                  project.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Price
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.attach_money,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Price: \$${project.price.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Description
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  project.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Worker Information
                                const Text(
                                  'Service Provider',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 25,
                                        child: Icon(Icons.person, size: 30),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              project.workerName ?? 'Unknown',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              project.workerSpecialization ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${project.workerRating} • ${project.workerExperience} exp',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Book Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showBookingDialog(project);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        3,
                                        167,
                                        170,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Book This Service',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
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
          },
        );
      },
    );
  }

  void _showBookingDialog(Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController dateController = TextEditingController();
        final TextEditingController messageController = TextEditingController();
        DateTime? selectedDate;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Book Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Booking: ${project.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                    dateController.text =
                        '${picked.day}/${picked.month}/${picked.year}';
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  prefixIcon: Icon(Icons.message),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: \$${project.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a date')),
                  );
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking request sent successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 167, 170),
              ),
              child: const Text('Confirm Booking'),
            ),
          ],
        );
      },
    );
  }
}

// Project Model
class Project {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final int? workerId;
  final String? status;
  final String? createdAt;

  // Worker information
  String? workerName;
  String? workerEmail;
  String? workerPhone;
  String? workerSpecialization;
  double? workerRating;
  String? workerExperience;

  // Media - Single image (not array)
  String? imageUrl; // Regular URL
  String? base64Image; // Base64 encoded image

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.workerId,
    this.status,
    this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? json['project_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      // Safely parse price which might be int, double or string
      price: (() {
        var raw = json['price'] ?? 0;
        if (raw is num) return raw.toDouble();
        return double.tryParse(raw.toString()) ?? 0.0;
      })(),
      category: json['category'] ?? 'Other',
      workerId: json['workerId'] ?? json['worker_id'],
      status: json['status'],
      createdAt: json['created_at'] ?? json['createdAt'],
    );
  }
}
