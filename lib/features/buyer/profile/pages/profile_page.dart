import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/buyer/profile/pages/edit_profile_page.dart';
import 'package:livest/features/breader/profile/widgets/profile_info_field.dart';
import 'package:livest/features/breader/profile/widgets/profile_setting_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileProvider, AuthProvider>(
      builder: (context, profileProvider, authProvider, child) {
        if (profileProvider.isLoading) {
          return const Scaffold(
            backgroundColor: LivestColors.baseWhite,
            body: Center(child: CircularProgressIndicator(color: LivestColors.primaryNormal)),
          );
        }

        final name = profileProvider.fullName ?? 'User';
        final email = profileProvider.profileData?['email'] ?? 'Memuat...';
        final phone = profileProvider.phoneNumber ?? '-';
        final preferences = profileProvider.preferences ?? '-';
        final avatarUrl = profileProvider.avatarUrl;

        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          appBar: AppBar(
            backgroundColor: LivestColors.baseWhite,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: LivestColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Profile",
              style: TextStyle(
                color: LivestColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () async {
                  await authProvider.signOut();
                  profileProvider.clearProfile();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, RouteGenerator.login);
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFE0E0E0),
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl == null ? const Icon(Icons.person, size: 60, color: Colors.grey) : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: LivestColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfilePage(
                              initialName: name,
                              initialEmail: email,
                              initialPhone: phone,
                              initialPreferences: preferences,
                            ),
                          ),
                        );
                        if (result == true && mounted) {
                          profileProvider.fetchProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LivestColors.primaryNormal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ProfileInfoField(label: "Email", value: email),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Nomor Telepon", value: phone),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Preferensi Ternak", value: preferences),
                  const SizedBox(height: 32),
                  
                  // Settings Section (Tembusan dari Breader untuk standardisasi)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pengaturan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LivestColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileSettingButton(
                    title: "Keluar (Logout)",
                    onTap: () => _confirmLogout(context, authProvider, profileProvider),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider authProvider, ProfileProvider profileProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: LivestColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.signOut();
              profileProvider.clearProfile();
              if (mounted) {
                Navigator.pushReplacementNamed(context, RouteGenerator.login);
              }
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
