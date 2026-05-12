import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/other/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class WorkerSignUpPage extends StatefulWidget {
  const WorkerSignUpPage({super.key});

  @override
  State<WorkerSignUpPage> createState() => _WorkerSignUpPageState();
}

class _WorkerSignUpPageState extends State<WorkerSignUpPage> {
  // Controllers for all fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController(); // ✅ NEW

  // Dropdown values
  // int? _selectedNationalityId;
  String? _selectedJobTitle;

  // Loading state
  bool _isLoading = false;

  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Options for job titles
  final List<String> _jobTitles = [
    'Painter',
    'Air Conditioning Technician',
    'Electrician',
    'Plumber',
    'Carpenter',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _licenseNumberController.dispose(); // ✅ NEW
    super.dispose();
  }

  // Get base URL for API
  String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000';
    } else {
      return 'http://192.168.1.100:3000';
    }
  }

  // Worker sign up API call
  Future<Map<String, dynamic>> _signUpWorker() async {
    final String apiUrl = '${getBaseUrl()}/user/register';

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
              'phoneNumber': _phoneController.text.trim(),
              'location': _locationController.text.trim(),
              'natiolityId': _licenseNumberController.text.trim(), // ✅ NEW
              'jobTitle': _selectedJobTitle,
              'role': 'worker',
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        String errorMessage = 'Sign up failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage =
              errorData['message'] ?? errorData['error'] ?? 'Sign up failed';
        } catch (e) {
          errorMessage = 'Sign up failed with status: ${response.statusCode}';
        }
        return {'success': false, 'error': errorMessage};
      }
    } catch (e) {
      print('Error: $e');
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  // Handle sign up
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _signUpWorker();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Worker account created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back to login page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF000041),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 180,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 10),
            Text(
              "Worker Sign Up",
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Create worker account",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // NAME INPUT
                _buildTextField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person,
                  hint: "Enter worker's full name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // EMAIL INPUT
                _buildTextField(
                  controller: _emailController,
                  label: "Email Address",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  hint: "worker@example.com",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // PASSWORD INPUT
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  hint: "Minimum 6 characters",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // CONFIRM PASSWORD INPUT
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  hint: "Re-enter password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // PHONE NUMBER INPUT
                _buildTextField(
                  controller: _phoneController,
                  label: "Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  hint: "05XXXXXXXX",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // LOCATION INPUT
                _buildTextField(
                  controller: _locationController,
                  label: "Location",
                  icon: Icons.location_on,
                  hint: "City, Area, Address",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // LICENSE NUMBER INPUT ✅ NEW
                _buildTextField(
                  controller: _licenseNumberController,
                  label: "License Number",
                  icon: Icons.badge,
                  hint: "Enter professional license number",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter license number';
                    }
                    if (value.length < 5) {
                      return 'Please enter a valid license number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // NATIONALITY ID DROPDOWN
                // _buildNationalityDropdown(),
                const SizedBox(height: 20),

                // JOB TITLE DROPDOWN
                _buildDropdown(
                  value: _selectedJobTitle,
                  label: "Job Title",
                  icon: Icons.work,
                  items: _jobTitles,
                  hint: "Select job title",
                  onChanged: (value) {
                    setState(() {
                      _selectedJobTitle = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select job title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // SIGN UP BUTTON
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 172, 141),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleSignUp,
                    label: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add),
                              SizedBox(width: 10),
                              Text('Create Worker Account'),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // BACK TO LOGIN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 172, 141),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 390,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: !_isLoading,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color.fromARGB(255, 2, 240, 197),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),
        validator: validator,
      ),
    );
  }

  // Helper method to build dropdown
  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 390,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: const Color.fromARGB(255, 2, 240, 197),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        hint: Text(
          hint,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.normal,
          ),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        dropdownColor: const Color.fromARGB(255, 2, 240, 197),
        isExpanded: true,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: _isLoading ? null : onChanged,
        validator: validator,
      ),
    );
  }
}
