import 'package:flutter/material.dart';
import 'package:bookswap/Forms/loginform.dart';
import 'package:bookswap/routes/routes.dart';

class Login extends StatelessWidget {
  Login({super.key});
  
  final LoginForm loginForm = LoginForm();

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 100, color: const Color.fromARGB(255, 255, 255, 255)),
                      Text('BookSwap', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),),
                      SizedBox(height: 20,),
                      Text('Login to your account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),),
                      SizedBox(height: 20,),
                      Form(
                        key: loginForm.formKey,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: loginForm.emailController,
                                style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                  prefixIcon: Icon(Icons.email, color: const Color.fromARGB(255, 255, 255, 255)),
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  filled: true,
                                ),
                                validator: loginForm.validateEmail,
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: loginForm.passwordController,
                                style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                                  prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 255, 255, 255)),
                                  fillColor: const Color.fromARGB(255, 0, 0, 0),
                                  filled: true,
                                ),
                                obscureText: true,
                                validator: loginForm.validatePassword,
                              ),
                              SizedBox(height: 50,),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await loginForm.login(context);
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Error logging in'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Login', 
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Don\'t have an account? ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),),
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pushNamed(context, AppRoutes.signup);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text('Sign up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 242, 118, 2)),),
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
          ],
        ),
      ),
    );
  }
}

