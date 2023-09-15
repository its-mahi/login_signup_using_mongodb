import 'package:flutter/material.dart';
import 'package:mongodb_loginreg/database/mongodb_service.dart';
import 'package:mongodb_loginreg/login.dart'; // Import your login screen file

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MongoDBService _mongoDBService = MongoDBService();

  // Function to handle logout
  void _logout() {
    // Close the MongoDB connection (if needed)
    _mongoDBService.close();

    // Navigate to the login page and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MyLogin(), // Replace MyLogin with your login screen
      ),
          (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // Path to your image
            fit: BoxFit.cover, // You can adjust the fit as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, user !',
                style: TextStyle(
                  fontSize: 24, // Make it bold
                  fontWeight: FontWeight.bold, // Add bold font
                ),
              ),
              SizedBox(height: 20), // Add spacing
              ElevatedButton(
                onPressed: _logout,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
