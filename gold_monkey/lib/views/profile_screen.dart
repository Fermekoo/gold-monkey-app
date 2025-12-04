import 'package:flutter/material.dart';
import 'package:gold_monkey/core/constants/app_colors.dart';
import 'package:gold_monkey/viewmodels/profile_viewmodel.dart';
import 'package:gold_monkey/views/login_screen.dart';
import 'package:gold_monkey/views/widgets/glass_container.dart';
import 'package:gold_monkey/views/widgets/profile_ava.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    // Gunakan addPostFrameCallback agar tidak error saat rebuild UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewmodel>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewmodel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient
        ),
        child: profileVM.isLoading
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : profileVM.errorMessage != null 
              ? Center(child: Text(profileVM.errorMessage!, style: TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.12),
                    ProfileVatar(url: profileVM.user?.avaURL ?? "https://i.pravatar.cc/300"),
                    SizedBox(height: 16),
                    Text(
                      profileVM.user?.username ?? "User",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "member sinced 2020",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 30),

                    GlassContainer(
                      child: Column(
                        children: [
                          _buildProfileItem(Icons.person, "Username", profileVM.user?.username ?? "-"),
                          Divider(color: Colors.white24, height: 30),
                          _buildProfileItem(Icons.person, "Email", profileVM.user?.email ?? "-"),
                          Divider(color: Colors.white24, height: 30),
                          _buildProfileItem(Icons.security, "Security", "2FA Enabled"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Provider.of<ProfileViewmodel>(context, listen: false).logout();
                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(context, 
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                        ),
                        child: Text("Log Out"),
                      ),
                    )
                  ],
                ),
              )
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  
}