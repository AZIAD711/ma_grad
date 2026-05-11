import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    //  STATUS BAR CONTROL
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
        leading: SizedBox(),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            // TITLE MESSAGE
            Text(
              "Login",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 46,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // SUB TITLE
            Text(
              "Sign in to continue",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),

      // BODY CONTENT
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            // EMAIL INPUT
            SizedBox(
              width: 390,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 2, 240, 197),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            // PASSWORD INPUT
            SizedBox(
              width: 390,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 2, 240, 197),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // // FORGET PASSWORD LINK
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Loginpage()),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.transparent,
            //       shadowColor: Colors.transparent,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(0),
            //         side: BorderSide(color: Colors.transparent),
            //       ),
            //     ),

            //     child: Text(
            //       "Forget Password ?",
            //       style: TextStyle(
            //         color: const Color.fromARGB(255, 4, 4, 4),
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 60),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                label: Row(
                  children: [
                    Icon(
                      Icons.login,
                      color: Color.fromARGB(255, 240, 240, 240),
                    ),
                    SizedBox(width: 90),
                    Text('Login'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // CREATE ACCOUNT LINK
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
    );
  }
}
