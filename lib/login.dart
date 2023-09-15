import 'package:flutter/material.dart';
import 'package:mongodb_loginreg/database/mongodb_service.dart';
import 'package:mongodb_loginreg/Homescreen.dart';

class MyLogin extends StatefulWidget {
  MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MongoDBService _mongoDBService = MongoDBService();

  @override
  void initState() {
    super.initState();
    _mongoDBService.connect(); // Connect to MongoDB when the widget initializes
  }

  @override
  void dispose() {
    _mongoDBService
        .close(); // Close the MongoDB connection when the widget is disposed
    super.dispose();
  }

  void _loginUser() async {
    // Ensure email and password are not empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email or Password is empty.'),
        ),
      );
      return;
    }

    try {
      // Find the user by email
      final user = await _mongoDBService.findUserByEmail(_emailController.text);

      if (user != null) {
        // Check if the provided password matches the stored password
        if (user['password'] == _passwordController.text) {
          // User authentication successful

          // Get the username if it exists, or use a default value if it's null or empty
          final username = user['username'];

          if (username != null && username.isNotEmpty) {
            // Navigate to the home page and pass the username as a parameter
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(username: username),
            ));
          } else {
            // Username is empty or null, show a message without the username
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(username: ''),
            ));
          }
        } else {
          // Password is incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect password'),
            ),
          );
        }
      } else {
        // User not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found'),
          ),
        );
      }
    } catch (e) {
      // Handle any errors that occurred during login
      print('Error during login: $e');
      // You might want to show an error message to the user
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Login\nPage',
                style: TextStyle(color: Colors.white, fontSize: 33, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.black),
                            controller: _emailController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(),
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: _loginUser,
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'register');
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      // backgroundColor: Colors.blueGrey,
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}