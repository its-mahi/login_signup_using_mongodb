import 'package:flutter/material.dart';
import 'package:mongodb_loginreg/database/mongodb_service.dart';

class MyRegister extends StatefulWidget {
  MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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

  void _registerUser() async {
    // Ensure email and password are not empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Either email or password is Empty !'),
        ),
      );
      return;
    }

    // Create a user map with the necessary fields
    Map<String, dynamic> user = {
      'email': _emailController.text,
      'password': _passwordController.text,
      // ... other fields ...
    };

    try {
      // Check if the user already exists with the provided email
      final existingUser =
      await _mongoDBService.findUserByEmail(_emailController.text);
      if (existingUser != null) {
        // User with the same email already exists
        // Handle this scenario (show an error message, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists !'),
          ),
        );
        return;
      }

      // If the user doesn't exist, proceed with registration
      await _mongoDBService.registerUser(user);

      // Registration successful, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User registered successfully'),
        ),
      );

      // Clear the text fields after successful registration
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      // Handle any errors that occurred during registration
      print('Error during registration: $e');
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.black, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.black),
                            controller: _nameController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Name",
                              hintStyle: TextStyle(color: Colors.black), // Change hint text color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none, // Remove the border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black), // Add a focused border
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white), // Add an enabled border
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.black),
                            controller: _emailController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.black), // Change hint text color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none, // Remove the border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black), // Add a focused border
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white), // Add an enabled border
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.black),
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.black), // Change hint text color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none, // Remove the border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black), // Add a focused border
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white), // Add an enabled border
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: _registerUser,
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
                                  Navigator.pushNamed(context, 'login');
                                },
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
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