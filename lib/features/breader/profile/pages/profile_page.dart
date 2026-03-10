import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/widgets/custom_confirmation_dialog.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/breader/profile/pages/edit_profile_page.dart';
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

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider, ProfileProvider profileProvider) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return const CustomConfirmationDialog(
          title: "Yakin ingin keluar dari akun?",
          subtitle: "Kamu dapat kembali ke akun dengan\nemail dan password yang sesuai.",
          confirmText: "Keluar",
        );
      },
    );

    if (confirm == true) {
      await authProvider.signOut();
      profileProvider.clearProfile();
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      }
    }
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
        final farmName = profileProvider.farmName ?? '-';
        final farmLocation = profileProvider.farmLocation ?? '-';
        final description = profileProvider.description ?? '-';

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
                    backgroundImage: profileProvider.avatarUrl != null 
                        ? NetworkImage(profileProvider.avatarUrl!) 
                        : null,
                    child: profileProvider.avatarUrl == null 
                        ? const Icon(Icons.person, size: 60, color: Colors.grey) 
                        : null,
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
                              initialFarmName: farmName,
                              initialFarmLocation: farmLocation,
                              initialDescription: description,
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
                  
                  // Read Only Fields
                  ProfileInfoField(label: "Deskripsi", value: description),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Email", value: email),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Nomor Telepon", value: phone),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Nama Peternakan", value: farmName),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Lokasi Peternakan", value: farmLocation),
                  const SizedBox(height: 32),

                  // Settings Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pengaturan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LivestColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileSettingButton(
                    title: "Keluar dari akun",
                    onTap: () => _showLogoutDialog(context, authProvider, profileProvider),
                  ),
                  const SizedBox(height: 12),
                  ProfileSettingButton(
                    title: "Ubah Password",
                    onTap: () => Navigator.pushNamed(context, RouteGenerator.changePassword),
                  ),
                  const SizedBox(height: 12),
                  ProfileSettingButton(
                    title: "Hapus akun",
                    onTap: () => Navigator.pushNamed(context, '/delete-account'),
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
}
