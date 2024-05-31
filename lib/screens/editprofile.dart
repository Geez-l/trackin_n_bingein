import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/buttons/buttons.dart';
import 'package:trackin_n_bingein/styling/styling.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required String email}) : super(key: key);
  
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late XFile? _profileImage = XFile('lib/assets/placeholder_profile.jpg');
  bool isSigning = false;


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> showImagePickerOption(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        print('Setting profile image: ${image.path}');
        _profileImage = image;
      });
    }
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        // to be adjusted
                        // Spacer(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Stack(
                              children: [
                              ClipOval(  
                                 child: Image(
                                    image: _profileImage != null
                                        ? FileImage(File(_profileImage!.path))
                                        : const AssetImage(
                                            'lib/assets/placeholder_profile.jpg')
                                            as ImageProvider<Object>,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                              ),
                                // SizedBox(height: 20),
                                Positioned(
                                    bottom: -3,
                                    left: 70,
                                    child: IconButton(
                                      onPressed: () {
                                        showImagePickerOption(context);
                                      },
                                      icon: const Icon(Icons.add_a_photo,
                                      color:Styling.textColor3),
                                    ),
                                  )
                              ]
                              )
                            ),
                          ),   
                      ],
                    ),
                  ),
                ],   
              ),
               const Center(
                 child: Text(
                  "kzlyr@gmail.com",
                  style: TextStyle(
                    fontSize: 20,
                    color: Styling.textColor3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               ),
        
              SizedBox(height: 50),
              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              // add text change password
              
              const Padding(
                padding: EdgeInsets.only(top: 25, right: 25),
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 20,
                    color: Styling.textColor3,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              SizedBox(height: 16),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 100),
                  Buttons.cancelButton(context),
                  Buttons.saveButton(context),
                ],
              ),
              ],
          ),
        ),
      ),
    );
  }
}
