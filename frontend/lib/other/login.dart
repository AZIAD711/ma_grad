import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/client/home-page.dart';
import 'package:frontend/other/role-page.dart';
import 'package:frontend/worker/profile.dart' hide WorkerProfilePage;
// import 'package:frontend/client/home-page.dart'; // Import your client home page
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _login(String email, String password) async {
    const String apiUrl = 'http://10.0.2.2:3000/user/login';

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract token, user data, and role from your specific response structure
        String? token;
        int? userId;
        String? userName;
        String? userRole;

        // Navigate through the nested structure
        if (responseData.containsKey('data')) {
          final firstData = responseData['data'];

          if (firstData.containsKey('token')) {
            token = firstData['token'];
          }

          if (firstData.containsKey('data')) {
            final userData = firstData['data'];
            userId = userData['userId'];
            userName = userData['name'];
            userRole = userData['role']; // Extract role from API response
          }
        }

        print('Extracted Token: $token');
        print('Extracted User ID: $userId');
        print('User Name: $userName');
        print('User Role: $userRole');

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setInt('user_id', userId ?? 0);
          await prefs.setString('user_name', userName ?? '');
          await prefs.setString('user_role', userRole ?? ''); // Save role

          // Verify save was successful
          final verifyToken = await prefs.getString('auth_token');
          print('Verification - Token saved: ${verifyToken != null}');

          return {
            'success': true,
            'role': userRole,
            'userId': userId,
            'userName': userName,
          };
        } else {
          print('ERROR: Token extraction failed');
          return {'success': false, 'error': 'No token received from server'};
        }
      } else {
        return {'success': false, 'error': 'Invalid credentials'};
      }
    } catch (e) {
      print('Network Error: $e');
      return {'success': false, 'error': 'Connection failed'};
    }
  }

  // Helper function to recursively search for token in nested maps
  String? _findTokenInMap(Map<String, dynamic> map) {
    if (map.containsKey('token') && map['token'] is String) {
      return map['token'];
    }

    for (var value in map.values) {
      if (value is Map<String, dynamic>) {
        final found = _findTokenInMap(value);
        if (found != null) return found;
      }
    }
    return null;
  }

  // Helper function to find role in nested maps
  String? _findRoleInMap(Map<String, dynamic> map) {
    if (map.containsKey('role') && map['role'] is String) {
      return map['role'];
    }

    for (var value in map.values) {
      if (value is Map<String, dynamic>) {
        final found = _findRoleInMap(value);
        if (found != null) return found;
      }
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Get the user role from the result
        String? userRole = result['role'];

        print('Navigating based on role: $userRole');

        // Navigate based on role
        if (userRole != null && userRole.toLowerCase() == 'client') {
          // Client role - Navigate to Client Home Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(), // Your client home page
            ),
          );
        } else if (userRole != null && userRole.toLowerCase() == 'worker') {
          // Worker role - Navigate to Worker Profile Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WorkerProfilePage()),
          );
        } else {
          // Default or unknown role - Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown role: $userRole'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
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
        toolbarHeight: 210,
        centerTitle: true,
        leading: const SizedBox(),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 10),
            Text(
              "Login",
              style: TextStyle(
                color: Colors.black,
                fontSize: 46,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Sign in to continue",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: 390,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 3, 167, 170),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 3, 167, 170),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 390,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 3, 167, 170),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 3, 167, 170),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 167, 170),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
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
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RolePage(),
                                ),
                              );
                            },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 167, 170),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
