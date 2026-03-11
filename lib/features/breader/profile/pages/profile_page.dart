import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
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

  void _showLogoutDialog(
    BuildContext context,
    AuthProvider authProvider,
    ProfileProvider profileProvider,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return const CustomConfirmationDialog(
          title: "Yakin ingin keluar dari akun?",
          subtitle:
              "Kamu dapat kembali ke akun dengan\nemail dan password yang sesuai.",
          confirmText: "Keluar",
        );
      },
    );

    if (confirm == true) {
      await authProvider.signOut();
      profileProvider.clearProfile();
      if (context.mounted) {
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
            body: Center(
              child: CircularProgressIndicator(
                color: LivestColors.primaryNormal,
              ),
            ),
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
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F4F0), // Beige circular background
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              "Profil",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            titleSpacing: 16,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  // 🔥 HEADER SECTION (Row Layout)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFFE0E0E0),
                        backgroundImage: profileProvider.avatarUrl != null
                            ? NetworkImage(profileProvider.avatarUrl!)
                            : null,
                        child: profileProvider.avatarUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 13,
                                color: LivestColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 13,
                                color: LivestColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
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
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 🔥 BIODATA SECTION
                  const Text(
                    "Biodata",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Deskripsi", value: description),
                  const SizedBox(height: 16),
                  ProfileInfoField(label: "Nama Peternakan", value: farmName),
                  const SizedBox(height: 16),
                  ProfileInfoField(
                    label: "Lokasi Peternakan",
                    value: farmLocation,
                  ),
                  const SizedBox(height: 32),

                  // 🔥 PENGATURAN SECTION
                  const Text(
                    "Pengaturan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileSettingButton(
                    title: "Ubah Password",
                    icon: Icons.lock_outline_rounded,
                    backgroundColor: const Color(
                      0xFFF7F4F0,
                    ), // Beige background
                    textColor: Colors.black87,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteGenerator.changePassword,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileSettingButton(
                    title: "Keluar Akun",
                    icon: Icons.logout_rounded,
                    backgroundColor: const Color(
                      0xFFFDE8E8,
                    ), // Light red background
                    textColor: const Color(0xFFD32F2F), // Red text
                    onTap: () => _showLogoutDialog(
                      context,
                      authProvider,
                      profileProvider,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileSettingButton(
                    title: "Hapus Akun",
                    icon: Icons.delete_outline_rounded,
                    backgroundColor: const Color(
                      0xFFFDE8E8,
                    ), // Light red background
                    textColor: const Color(0xFFD32F2F), // Red text
                    onTap: () =>
                        Navigator.pushNamed(context, '/delete-account'),
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
