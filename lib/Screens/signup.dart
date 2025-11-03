import 'package:flutter/material.dart';
import 'package:bookswap/Forms/signupform.dart';
import 'package:bookswap/routes/routes.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  
  final SignupForm signupForm = SignupForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset('assets/images/books.jpg', fit: BoxFit.cover),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [const Color.fromARGB(255, 228, 80, 0).withOpacity(0.5), Colors.black.withOpacity(1)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book, size: 100, color: const Color.fromARGB(255, 255, 255, 255)),
                        Text('BookSwap', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),),
                        SizedBox(height: 20,),
                        Text('Create your account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),),
                        SizedBox(height: 20,),
                        Form(
                          key: signupForm.formKey,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: signupForm.firstNameController,
                                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                    prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 255, 255, 255)),
                                    fillColor: const Color.fromARGB(255, 0, 0, 0),
                                    filled: true,
                                  ),
                                  validator: signupForm.validateFirstName,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: signupForm.lastNameController,
                                  style: TextStyle(color: const Color.fromARGB(156, 255, 255, 255)),
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                    prefixIcon: Icon(Icons.person_outline, color: const Color.fromARGB(255, 255, 255, 255)),
                                    fillColor: const Color.fromARGB(255, 0, 0, 0),
                                    filled: true,
                                  ),
                                  validator: signupForm.validateLastName,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: signupForm.emailController,
                                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: const Color.fromARGB(153, 255, 255, 255)),
                                    prefixIcon: Icon(Icons.email, color: const Color.fromARGB(255, 255, 255, 255)),
                                    fillColor: const Color.fromARGB(255, 0, 0, 0),
                                    filled: true,
                                  ),
                                  validator: signupForm.validateEmail,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: signupForm.passwordController,
                                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: const Color.fromARGB(161, 255, 255, 255)),
                                    prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 255, 255, 255)),
                                    fillColor: const Color.fromARGB(255, 0, 0, 0),
                                    filled: true,
                                  ),
                                  obscureText: true,
                                  validator: signupForm.validatePassword,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: signupForm.confirmPasswordController,
                                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(color: const Color.fromARGB(112, 255, 255, 255)),
                                    prefixIcon: Icon(Icons.lock_outline, color: const Color.fromARGB(255, 255, 255, 255)),
                                    fillColor: const Color.fromARGB(255, 0, 0, 0),
                                    filled: true,
                                  ),
                                  obscureText: true,
                                  validator: signupForm.validateConfirmPassword,
                                ),
                                SizedBox(height: 50,),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await signupForm.signup(context);
                                    },
                                    child: Text(
                                      'Sign Up', 
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                      backgroundColor: const Color.fromARGB(255, 231, 101, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Already have an account? ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, AppRoutes.login);
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text('Login', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 242, 118, 2)),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
