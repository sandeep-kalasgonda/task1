import 'package:flutter/material.dart';
import 'package:task1/JsonModels/users.dart';
import 'package:task1/SQlite/sqlite.dart';
import 'package:task1/auth/signup.dart';
import 'package:task1/componets/Profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isVisible = false;
  bool isLoginTrue = false;
  final db = DatabaseHelper();

  void login() async {
    // Validate form fields
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      // Show error message if fields are empty
      setState(() {
        isLoginTrue = true;
      });
      return;
    }

    // Retrieve username and password from text controllers
    String username = usernameController.text;
    String password = passwordController.text;

    // Attempt to authenticate user using DatabaseHelper
    bool isAuthenticated = await db.login(username, password);

    if (isAuthenticated) {
      // Navigate to profile screen if authentication is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    } else {
      // Show error message if authentication fails
      setState(() {
        isLoginTrue = true;
      });
    }
  }


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username or Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username or email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: !isVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Call login method to authenticate user
                      login();
                    }
                  },
                  child: const Text('Login'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to the sign-up screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Signup()),
                        );
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
                if (isLoginTrue)
                  const Text(
                    "Username or password is incorrect",
                    style: TextStyle(color: Colors.deepOrange),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
