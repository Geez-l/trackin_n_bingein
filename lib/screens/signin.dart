import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:trackin_n_bingein/authentication/user_auth.dart';
import 'package:trackin_n_bingein/global/common/toast.dart';
import 'package:trackin_n_bingein/screens/navigation.dart';
import 'package:trackin_n_bingein/screens/signup.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  final FirebaseAuthentication _auth = FirebaseAuthentication();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isSigning = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container
          Container(
            height: 250,
            width: double.infinity,
            color: Color(0xFFB0C4DE),
            child: Padding(
              padding: const EdgeInsets.only(top: 20), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/logoname.png', 
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
          // White Container
          Padding(
            padding: const EdgeInsets.only(top: 250),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome Back Text
                    Text(
                      'Welcome back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Make it work, make it right, make it fast.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Username Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                    ),
                    SizedBox(height: 10),
                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Forgot password?'),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _signIn();
                          },
                        //onPressed: _signIn, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB0C4DE),
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSigning
                          ? CircularProgressIndicator(color: Colors.white) // loading indicator
                          : Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold,),),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Sign Up Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: Text('Sign Up'),
                        ),
                      ],
                    ),
                    // Divider with OR
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Continue with Google Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: Image.asset(
                          'lib/assets/google.png',
                          height: 24,
                        ),
                        label: Text('Continue with Google'),
                        onPressed: () {
                          _signInWithGoogle();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFB0C4DE)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async{

    setState(() {
      isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInwithEmailandPassword(email, password);

    setState(() {
      isSigning = false;
    });
      
    if (user != null) {
      showToast(message: 'Signed in successfully.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigation(email: email,)),
      );
    } else {
      showToast(message: 'Incorrect email or password.');
    }
  }

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Access the user's email
        String email = userCredential.user!.email!;

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Navigation(email: email)),
        );
      }
    } catch (e) {
      showToast(message: 'Sign in with Google failed.');
    }
  }
}