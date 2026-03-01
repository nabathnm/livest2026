import 'package:flutter/material.dart';
import 'package:livest/core/config/supabase_config.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  // State Data Profil
  String _nama = '';
  String _role = ''; // 'peternak' atau 'pembeli'
  String _farmName = '';
  String _farmLocation = '';
  String _animalTypes = '';
  String _preferences = '';

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Mesin Logika Navigasi
  void _nextPage() {
    final int currentIndex = _pageController.page?.toInt() ?? 0;

    switch (currentIndex) {
      case 0:
        if (_nama.trim().isEmpty) {
          _showError("Nama wajib diisi!");
          return;
        }
        _animateToPage(1); // Ini instruksi yang sebelumnya hilang
        break;

      case 1:
        if (_role.isEmpty) {
          _showError("Pilih role Anda!");
          return;
        }
        // Gunakan ternary operator untuk percabangan role yang lebih bersih
        _animateToPage(_role == 'peternak' ? 2 : 4);
        break;

      case 2:
        _animateToPage(3);
        break;

      case 3:
      case 4:
        _animateToPage(5);
        break;

      default:
        // Antisipasi jika index berada di luar jangkauan (defensive programming)
        break;
    }
  }

  void _animateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Eksekusi Akhir: Lempar ke Supabase
  Future<void> _submitData() async {
    setState(() => _isLoading = true);
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) throw Exception("Sesi hilang. Silakan login ulang.");

      await SupabaseConfig.client.from('profiles').upsert({
        'id': user.id,
        'full_name': _nama,
        'role': _role,
        'farm_name': _role == 'peternak' ? _farmName : null,
        'farm_location': _role == 'peternak' ? _farmLocation : null,
        'animal_types': _role == 'peternak' ? _animalTypes : null,
        'preferences': _role == 'pembeli' ? _preferences : null,
        'updated_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        // Lempar ke SplashPage. SplashPage yang akan menyortir role secara otomatis.
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteGenerator.splash,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6D4C41),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // PAGE 0: NAMA
              _buildStepLayout(
                progress: 0.15,
                title: "Kenalan, yuk!",
                subtitle: "Nama kamu siapa?",
                content: CustomTextField(
                  label: "Nama Lengkap",
                  controller: TextEditingController(text: _nama),
                  onChanged: (val) => _nama = val,
                ),
                onNext: _nextPage,
              ),

              _buildStepLayout(
                progress: 0.3,
                title: "Peran kamu?",
                subtitle: "Apa peran kamu? Peternak atau Pembeli Ternak?",
                content: Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard('Peternak', Icons.pets, 'peternak'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRoleCard(
                        'Pembeli Ternak',
                        Icons.shopping_cart,
                        'pembeli',
                      ),
                    ),
                  ],
                ),
                onNext: _nextPage,
              ),

              _buildStepLayout(
                progress: 0.5,
                title: "Profil Peternakan",
                subtitle: "Lengkapi data profil peternakanmu.",
                content: Column(
                  children: [
                    CustomTextField(
                      label: "Nama Peternakan",
                      controller: TextEditingController(text: _farmName),
                      onChanged: (val) => _farmName = val,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Lokasi Peternakan",
                      controller: TextEditingController(text: _farmLocation),
                      onChanged: (val) => _farmLocation = val,
                    ),
                  ],
                ),
                onNext: _nextPage,
              ),

              _buildStepLayout(
                progress: 0.75,
                title: "Jenis Hewan",
                subtitle: "Hewan apa saja yang kamu ternakkan?",
                content: CustomTextField(
                  label: "Contoh: Sapi, Kambing, Ayam",
                  controller: TextEditingController(text: _animalTypes),
                  onChanged: (val) => _animalTypes = val,
                ),
                onNext: _nextPage,
              ),

              _buildStepLayout(
                progress: 0.75,
                title: "Preferensi Ternak",
                subtitle: "Ternak seperti apa yang kamu cari?",
                content: CustomTextField(
                  label: "Contoh: Sapi perah, Kambing pedaging",
                  controller: TextEditingController(text: _preferences),
                  onChanged: (val) => _preferences = val,
                ),
                onNext: _nextPage,
              ),

              _buildStepLayout(
                progress: 1.0,
                title: "All set",
                subtitle: "Profil kamu sudah siap. Mari mulai!",
                content: const Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                ),
                onNext: _isLoading ? () {} : _submitData,
                buttonText: _isLoading ? "Memproses..." : "Mulai",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepLayout({
    required double progress,
    required String title,
    required String subtitle,
    required Widget content,
    required VoidCallback onNext,
    String buttonText = "Lanjut",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProgressBar(progress),
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Expanded(child: content),
        CustomButton(
          text: buttonText,
          isLoading: _isLoading,
          onPressed: onNext,
        ),
      ],
    );
  }

  // Widget Kartu Role Dinamis
  Widget _buildRoleCard(String title, IconData icon, String roleValue) {
    final isSelected = _role == roleValue;
    return InkWell(
      onTap: () => setState(() => _role = roleValue),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFEBE9) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF6D4C41) : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? const Color(0xFF6D4C41) : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
