import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';
import 'package:gold_monkey/viewmodels/auth_viewmodel.dart';
import 'package:gold_monkey/views/widgets/glass_container.dart';
import 'package:gold_monkey/views/widgets/glass_text_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordControler = TextEditingController();

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
                  "Create Account",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "start your crypto journey",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                GlassContainer(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      GlassTextField(
                        controller: _usernameController,
                        icon: Icons.person_outline,
                        hint: "username",
                      ),
                      const SizedBox(height: 20),

                      GlassTextField(
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        hint: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      GlassTextField(
                        controller: _passwordControler,
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

                      //Register button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authViewmodel.isLoading
                              ? null
                              : () async {
                                  bool success = await authViewmodel.register(
                                    _usernameController.text,
                                    _emailController.text,
                                    _passwordControler.text,
                                  );

                                  if (!context.mounted) return;

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Register success!, please Login",
                                        ),
                                      ),
                                    );
                                    // TODO: navigasi ke login Screen
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authViewmodel.errorMessage ??
                                              "Register failed",
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
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: authViewmodel.isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Sign Up"),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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
