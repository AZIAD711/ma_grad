import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  // User data from users table
  Map<String, dynamic> _userData = {};

  // Client data from clients table
  Map<String, dynamic> _clientData = {};

  bool _isLoading = true;
  bool _isEditing = false;
  String? _errorMessage;

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  String? _selectedGender;
  String? _selectedIncomeLevel;

  // Store the actual IDs
  int? _userId;
  int? _clientId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get token and user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      final int? userId = prefs.getInt('user_id');

      print('=== Loading Profile ===');
      print('Token: $token');
      print('User ID from SharedPrefs: $userId');

      if (token == null || userId == null) {
        setState(() {
          _errorMessage = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      _userId = userId;

      // Fetch user data from API (users table)
      await _fetchUserData(token, userId);

      // Fetch client data from API (clients table)
      await _fetchClientData(token);
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _errorMessage = 'Failed to load user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData(String token, int userId) async {
    try {
      // Try different endpoint formats
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('User API Response Status: ${response.statusCode}');
      print('User API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        // Handle different response structures
        Map<String, dynamic> userData;
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('data')) {
            userData = responseData['data'];
          } else {
            userData = responseData;
          }
        } else {
          userData = {};
        }

        setState(() {
          _userData = userData;
          _nameController.text = userData['name']?.toString() ?? '';
          _emailController.text = userData['email']?.toString() ?? '';
          _phoneNumberController.text =
              userData['phoneNumber']?.toString() ??
              userData['phone_number']?.toString() ??
              '';
        });
      } else {
        throw Exception(
          'Failed to load user data (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  Future<void> _fetchClientData(String token) async {
    try {
      // Try to get client data using user_id
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:3000/client/user/${_userId}',
        ), // Try this endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Client API Response Status: ${response.statusCode}');
      print('Client API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        Map<String, dynamic> clientData;
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('data')) {
            clientData = responseData['data'];
          } else {
            clientData = responseData;
          }
        } else {
          clientData = {};
        }

        setState(() {
          _clientData = clientData;
          _clientId = clientData['clientId'] ?? clientData['client_id'];
          _selectedGender =
              clientData['gender']?.toString() ?? 'Prefer not to say';
          _salaryController.text = clientData['salary']?.toString() ?? '';
          _selectedIncomeLevel =
              clientData['incomeLevel']?.toString() ??
              clientData['income_level']?.toString() ??
              'Middle';
        });
      } else if (response.statusCode == 404) {
        print('Client profile not found, will create on save');
        setState(() {
          _selectedGender = 'Prefer not to say';
          _selectedIncomeLevel = 'Middle';
        });
      } else {
        print('Client data not available (Status: ${response.statusCode})');
        setState(() {
          _selectedGender = 'Prefer not to say';
          _selectedIncomeLevel = 'Middle';
        });
      }
    } catch (e) {
      print('Error fetching client data: $e');
      // Don't throw, client data might be optional
      setState(() {
        _selectedGender = 'Prefer not to say';
        _selectedIncomeLevel = 'Middle';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      final int? userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        throw Exception('User not logged in');
      }

      // Update user data (users table)
      final userResponse = await http.put(
        Uri.parse('http://10.0.2.2:3000/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
        }),
      );

      print('Update User Response: ${userResponse.statusCode}');
      print('Update User Body: ${userResponse.body}');

      if (userResponse.statusCode == 200) {
        // Update or create client data (clients table)
        final Map<String, dynamic> clientBody = {
          'gender': _selectedGender,
          'incomeLevel': _selectedIncomeLevel,
          'userId': userId,
        };

        // Add salary if not empty
        if (_salaryController.text.isNotEmpty) {
          clientBody['salary'] = double.tryParse(_salaryController.text) ?? 0;
        }

        final clientResponse = await http.put(
          Uri.parse('http://10.0.2.2:3000/client/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(clientBody),
        );

        print('Update Client Response: ${clientResponse.statusCode}');
        print('Update Client Body: ${clientResponse.body}');

        if (clientResponse.statusCode == 200 ||
            clientResponse.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Reload data
          await _loadUserData();

          setState(() {
            _isEditing = false;
          });
        } else {
          // Even if client update fails, user update succeeded
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'User data updated, but client data may be incomplete',
              ),
              backgroundColor: Colors.orange,
            ),
          );
          setState(() {
            _isEditing = false;
          });
        }
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  // Navigate to login page
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null) return 'Not available';
    try {
      if (dateString is String) {
        DateTime date = DateTime.parse(dateString);
        return '${date.day}/${date.month}/${date.year}';
      }
      return dateString.toString();
    } catch (e) {
      return dateString.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: _isLoading
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
                    Text('Loading profile...'),
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
                      onPressed: _loadUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 167, 170),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header with Gradient
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 46, 46, 45),
                            Color.fromARGB(255, 39, 39, 39),
                            Color.fromARGB(255, 3, 167, 170),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // Profile Image
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        3,
                                        167,
                                        170,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (!_isEditing)
                              Text(
                                _userData['name']?.toString() ?? 'Client',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _userData['role']?.toString() ?? 'Client',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Edit/Save Button
                            ElevatedButton.icon(
                              onPressed: _isEditing
                                  ? _updateProfile
                                  : () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                              icon: Icon(_isEditing ? Icons.save : Icons.edit),
                              label: Text(
                                _isEditing ? 'Save Profile' : 'Edit Profile',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  3,
                                  167,
                                  170,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Profile Information Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: Color.fromARGB(255, 3, 167, 170),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),

                            // Full Name Field
                            _buildProfileField(
                              icon: Icons.person,
                              label: 'Full Name',
                              value: _userData['name']?.toString() ?? '',
                              controller: _nameController,
                              isEditing: _isEditing,
                            ),

                            // Email Field
                            _buildProfileField(
                              icon: Icons.email,
                              label: 'Email Address',
                              value: _userData['email']?.toString() ?? '',
                              controller: _emailController,
                              isEditing: _isEditing,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            // Phone Number Field
                            _buildProfileField(
                              icon: Icons.phone,
                              label: 'Phone Number',
                              value:
                                  _userData['phoneNumber']?.toString() ??
                                  _userData['phone_number']?.toString() ??
                                  '',
                              controller: _phoneNumberController,
                              isEditing: _isEditing,
                              keyboardType: TextInputType.phone,
                            ),

                            // Gender Selection
                            _buildGenderField(
                              icon: Icons.people,
                              label: 'Gender',
                              value: _selectedGender ?? 'Prefer not to say',
                              isEditing: _isEditing,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),

                            // Monthly Salary Field
                            _buildProfileField(
                              icon: Icons.attach_money,
                              label: 'Monthly Salary',
                              value: _clientData['salary']?.toString() ?? '',
                              controller: _salaryController,
                              isEditing: _isEditing,
                              keyboardType: TextInputType.number,
                            ),

                            // Income Level Field
                            _buildIncomeLevelField(
                              icon: Icons.trending_up,
                              label: 'Income Level',
                              value: _selectedIncomeLevel ?? 'Middle',
                              isEditing: _isEditing,
                              onChanged: (value) {
                                setState(() {
                                  _selectedIncomeLevel = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Account Statistics Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.analytics_outlined,
                                    color: Color.fromARGB(255, 3, 167, 170),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Account Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),

                            _buildStatItem(
                              icon: Icons.assignment_ind,
                              label: 'User ID',
                              value:
                                  _userData['userId']?.toString() ??
                                  _userData['user_id']?.toString() ??
                                  'N/A',
                              color: Colors.blue,
                            ),
                            _buildStatItem(
                              icon: Icons.verified_user,
                              label: 'Client ID',
                              value:
                                  _clientData['clientId']?.toString() ??
                                  _clientData['client_id']?.toString() ??
                                  'Not set',
                              color: Colors.green,
                            ),
                            _buildStatItem(
                              icon: Icons.calendar_today,
                              label: 'Member Since',
                              value: _formatDate(
                                _userData['created_at'] ??
                                    _userData['createdAt'],
                              ),
                              color: Colors.orange,
                            ),
                            _buildStatItem(
                              icon: Icons.update,
                              label: 'Last Updated',
                              value: _formatDate(
                                _userData['updated_at'] ??
                                    _userData['updatedAt'],
                              ),
                              color: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Settings Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings_outlined,
                                    color: Color.fromARGB(255, 3, 167, 170),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),

                            _buildSettingsItem(
                              icon: Icons.lock_outline,
                              title: 'Change Password',
                              onTap: () {
                                _showChangePasswordDialog(context);
                              },
                            ),
                            _buildSettingsItem(
                              icon: Icons.no_accounts,
                              title: 'Notification Settings',
                              onTap: () {
                                _showMessage(context, 'Notification Settings');
                              },
                            ),
                            _buildSettingsItem(
                              icon: Icons.language,
                              title: 'Language',
                              subtitle: 'English',
                              onTap: () {
                                _showMessage(context, 'Language Settings');
                              },
                            ),
                            _buildSettingsItem(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              onTap: () {
                                _showMessage(context, 'Privacy Policy');
                              },
                            ),
                            _buildSettingsItem(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              onTap: () {
                                _showMessage(context, 'Help & Support');
                              },
                            ),
                            _buildSettingsItem(
                              icon: Icons.logout,
                              title: 'Logout',
                              isDestructive: true,
                              onTap: _logout,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
    required TextEditingController controller,
    required bool isEditing,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                isEditing
                    ? TextFormField(
                        controller: controller,
                        keyboardType: keyboardType,
                        maxLines: maxLines,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 3, 167, 170),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        value.isEmpty ? 'Not provided' : value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderField({
    required IconData icon,
    required String label,
    required String value,
    required bool isEditing,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                isEditing
                    ? DropdownButtonFormField<String>(
                        value: value,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 3, 167, 170),
                            ),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(
                            value: 'Female',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'Prefer not to say',
                            child: Text('Prefer not to say'),
                          ),
                        ],
                        onChanged: onChanged,
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeLevelField({
    required IconData icon,
    required String label,
    required String value,
    required bool isEditing,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                isEditing
                    ? DropdownButtonFormField<String>(
                        value: value,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 3, 167, 170),
                            ),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Low', child: Text('Low')),
                          DropdownMenuItem(
                            value: 'Middle',
                            child: Text('Middle'),
                          ),
                          DropdownMenuItem(value: 'High', child: Text('High')),
                        ],
                        onChanged: onChanged,
                      )
                    : Text(
                        value.isEmpty ? 'Not set' : value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isDestructive ? Colors.red : Colors.grey.shade600,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDestructive ? Colors.red : Colors.black87,
                ),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
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
              onPressed: () async {
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  // Call API to change password
                  final prefs = await SharedPreferences.getInstance();
                  final String? token = prefs.getString('auth_token');
                  final int? userId = prefs.getInt('user_id');

                  // Implement password change API call here

                  Navigator.pop(context);
                  _showMessage(context, 'Password changed successfully!');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 167, 170),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}
