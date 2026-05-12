import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Password visibility
  bool _obscurePassword = true;

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // API Service method
  Future<Map<String, dynamic>> _login(String email, String password) async {
    // Replace with your actual API endpoint
    const String apiUrl = 'http://10.0.2.2:3000/user/login';

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Save token to SharedPreferences
        if (data.containsKey('token')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);

          // Save user data if needed
          if (data.containsKey('user')) {
            await prefs.setString('user_data', jsonEncode(data['user']));
          }
        }

        return {'success': true, 'data': data};
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Invalid Email or Password !',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  // Handle login button press
  Future<void> _handleLogin() async {
    // Validate form
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
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to home screen (create this screen)
        // Navigator.pushReplacementNamed(context, '/home');
        // Or use: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        // Show error message
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
    // STATUS BAR CONTROL
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF000041),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // APPBAR CONTENT
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 210,
        centerTitle: true,
        leading: const SizedBox(),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // TITLE MESSAGE
            const Text(
              "Login",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 46,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // SUB TITLE
            const Text(
              "Sign in to continue",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      // BODY CONTENT
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // EMAIL INPUT
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
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 2, 240, 197),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
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
              const SizedBox(height: 50),
              // PASSWORD INPUT
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
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
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
                    filled: true,
                    fillColor: const Color.fromARGB(255, 2, 240, 197),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
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
              const SizedBox(height: 20),
              const SizedBox(height: 60),
              // LOGIN BUTTON
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 3, 172, 141),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    iconColor: Color(0xFF000041),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.login,
                              color: Color.fromARGB(255, 240, 240, 240),
                            ),
                            const SizedBox(width: 10),
                            const Text('Login'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 30),
              // CREATE ACCOUNT LINK
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        // Navigate to registration page
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration feature coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have account ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Text(
                      " New Create Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
