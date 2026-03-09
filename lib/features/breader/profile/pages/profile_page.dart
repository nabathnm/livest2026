import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/breader/profile/pages/edit_profile_page.dart';

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

        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          appBar: AppBar(
            backgroundColor: LivestColors.baseWhite,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: LivestColors.textPrimary,
              ),
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
                    Navigator.pushReplacementNamed(
                      context,
                      RouteGenerator.login,
                    );
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, size: 60, color: Colors.grey),
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
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildReadOnlyField("Email", email),
                  const SizedBox(height: 16),
                  _buildReadOnlyField("Nomor Telepon", phone),
                  const SizedBox(height: 16),
                  _buildReadOnlyField("Nama Peternakan", farmName),
                  const SizedBox(height: 16),
                  _buildReadOnlyField("Lokasi Peternakan", farmLocation),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: LivestSizes.fontSizeSm,
            fontWeight: FontWeight.w500,
            color: LivestColors.textPrimary,
          ),
        ),
        const SizedBox(height: LivestSizes.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: LivestColors.baseWhite,
            border: Border.all(
              color: LivestColors.primaryLightActive,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(LivestSizes.inputFieldRadius),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: LivestSizes.fontSizeSm,
              color: LivestColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
