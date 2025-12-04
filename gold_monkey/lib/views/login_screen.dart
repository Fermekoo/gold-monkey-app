import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';
import 'package:gold_monkey/viewmodels/auth_viewmodel.dart';
import 'package:gold_monkey/views/main/main_screen.dart';
import 'package:gold_monkey/views/register_screen.dart';
import 'package:gold_monkey/views/widgets/glass_container.dart';
import 'package:gold_monkey/views/widgets/glass_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewmodel = Provider.of<AuthViewmodel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.05),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                GlassContainer(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      GlassTextField(
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        hint: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      GlassTextField(
                        controller: _passwordController,
                        icon: Icons.password_outlined,
                        hint: "Password",
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),

                      if (authViewmodel.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            authViewmodel.errorMessage!,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),

                      //Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authViewmodel.isLoading
                              ? null
                              : () async {
                                  bool success = await authViewmodel.login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );

                                  if (!context.mounted) return;
                                  if (success) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => MainScreen()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authViewmodel.errorMessage ??
                                              "login failed",
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },

                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            backgroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(14),
                            ),
                          ),
                          child: authViewmodel.isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Log In"),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create Account",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterScreen()),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
