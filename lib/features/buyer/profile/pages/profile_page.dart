import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/buyer/profile/pages/edit_profile_page.dart';
import 'package:livest/features/buyer/profile/pages/widgets/buyer_profile_info_field.dart';
import 'package:livest/features/buyer/profile/pages/widgets/buyer_profile_setting_button.dart';
import 'package:livest/core/utils/widgets/custom_confirmation_dialog.dart';
import 'package:livest/core/utils/widgets/profile_header_card.dart';

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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const CustomConfirmationDialog(
        title: "Keluar Akun",
        subtitle: "Apakah Anda yakin ingin keluar dari akun ini?",
        confirmText: "Keluar",
      ),
    ).then((confirmed) async {
      if (confirmed == true && mounted) {
        await context.read<AuthProvider>().signOut();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.login, (route) => false);
        }
      }
    });
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    Navigator.pushNamed(context, RouteGenerator.deleteAccount);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final isLoading = profileProvider.isLoading;
    final profile = profileProvider.profileData;

    final avatarUrl = profileProvider.avatarUrl;
    final fullName = profile?['full_name'] ?? '-';
    final email = profile?['email'] ?? '-';
    final phoneNumber = profile?['phone_number'] ?? '-';
    final preferences = profile?['preferences'] ?? '-';

    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: AppBar(
        backgroundColor: LivestColors.baseWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: LivestSizes.lg,
        title: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: LivestColors.primaryLightActive,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: LivestColors.textPrimary, size: 20),
                onPressed: () {
                },
              ),
            ),
            const SizedBox(width: LivestSizes.md),
            const Text(
              "Profile",
              style: TextStyle(
                color: LivestColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(LivestSizes.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeaderCard(
                    name: fullName,
                    email: email,
                    phone: phoneNumber,
                    avatarUrl: avatarUrl,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            initialName: fullName,
                            initialEmail: email,
                            initialPhone: phoneNumber,
                            initialPreferences: preferences,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: LivestSizes.spaceBtwSections),
                  BuyerProfileInfoField(label: "Email", value: email),
                  const SizedBox(height: LivestSizes.md),
                  BuyerProfileInfoField(label: "Nomor Telepon", value: phoneNumber),
                  const SizedBox(height: LivestSizes.md),
                  BuyerProfileInfoField(label: "Preferensi Ternak", value: preferences),
                  const SizedBox(height: LivestSizes.spaceBtwSections),
                  const Text("Pengaturan", style: LivestTypography.h6),
                  const SizedBox(height: LivestSizes.md),

                  BuyerProfileSettingButton(
                    icon: Icons.lock_outline,
                    title: "Ubah Password",
                    onTap: () => Navigator.pushNamed(context, RouteGenerator.changePassword),
                  ),
                  const SizedBox(height: LivestSizes.sm),

                  BuyerProfileSettingButton(
                    icon: Icons.logout, 
                    title: "Keluar dari akun",
                    backgroundColor: const Color(0xFFFFEBEE),
                    textColor: const Color(0xFFD32F2F),
                    onTap: () => _showLogoutConfirmation(context),
                  ),
                  const SizedBox(height: LivestSizes.sm),

                  BuyerProfileSettingButton(
                    icon: Icons.lock_outline, 
                    title: "Hapus akun",
                    backgroundColor: const Color(0xFFFFEBEE),
                    textColor: const Color(0xFFD32F2F),
                    onTap: () => _showDeleteAccountConfirmation(context),
                  ),
                ],
              ),
            ),
    );
  }
}

