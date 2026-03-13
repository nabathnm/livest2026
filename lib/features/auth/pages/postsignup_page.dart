import 'package:flutter/material.dart';
import 'package:livest/core/utils/formatters/phone_number_formatter.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:flutter/services.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/auth/widgets/postsignup/animal_card.dart';
import 'package:livest/features/auth/widgets/postsignup/location_dropdown.dart';
import 'package:livest/features/auth/widgets/postsignup/onboarding_helpers.dart';
import 'package:livest/features/auth/widgets/postsignup/onboarding_step_layout.dart';
import 'package:livest/features/auth/widgets/postsignup/role_card.dart';

class PostSignupPage extends StatefulWidget {
  const PostSignupPage({super.key});

  @override
  State<PostSignupPage> createState() => _PostSignupPageState();
}

class _PostSignupPageState extends State<PostSignupPage> {
  final PageController _pageController = PageController();

  String _role = '';
  String _nama = '';
  String _phoneNumber = '';
  String _farmName = '';
  String _farmLocation = '';
  final Set<String> _selectedAnimals = {};

  String? _roleError;
  String? _nameError;
  String? _phoneError;
  String? _farmError;
  String? _animalError;

  final _nameController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _phoneController = TextEditingController();

  int _currentStep = 0;

  static const List<String> _provinces = [
    'Jawa Timur',
    'Jawa Barat',
    'Jawa Tengah',
    'Banten',
    'DKI Jakarta',
    'Bali',
    'Sumatera Utara',
    'Sumatera Barat',
    'Kalimantan Timur',
    'Sulawesi Selatan',
  ];

  static const List<Map<String, String>> _animals = [
    {'label': 'Sapi', 'image': 'assets/images/login/sapi.png'},
    {'label': 'Ayam', 'image': 'assets/images/login/ayam.png'},
    {'label': 'Kambing', 'image': 'assets/images/login/kambing.png'},
    {'label': 'Bebek', 'image': 'assets/images/login/bebek.png'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _farmNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _clearErrors() => setState(() {
    _roleError = null;
    _nameError = null;
    _phoneError = null;
    _farmError = null;
    _animalError = null;
  });

  void _goBack() {
    _clearErrors();
    if (_currentStep > 0) {
      if (_role == 'pembeli' && _currentStep == 4) {
        _animateToStep(2);
      } else if (_role == 'pembeli' && _currentStep == 5) {
        _animateToStep(4);
      } else {
        _animateToStep(_currentStep - 1);
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _goNext() {
    _clearErrors();

    if (!_validateCurrentStep()) return;

    if (_role == 'pembeli') {
      if (_currentStep == 2) {
        _animateToStep(4);
      } else if (_currentStep < 5) {
        _animateToStep(_currentStep + 1);
      }
    } else {
      if (_currentStep < 5) {
        _animateToStep(_currentStep + 1);
      }
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_role.isEmpty) {
          setState(() => _roleError = 'Pilih salah satu terlebih dahulu!');
          return false;
        }
        break;
      case 1:
        if (_nama.trim().isEmpty) {
          setState(() => _nameError = 'Masukkan nama terlebih dahulu!');
          return false;
        }
        break;
      case 2:
        if (_phoneNumber.trim().isEmpty) {
          setState(
            () => _phoneError = 'Masukkan nomor telepon terlebih dahulu',
          );
          return false;
        }
        final String rawPhone = _phoneNumber.trim().replaceAll(
          RegExp(r'\D'),
          '',
        );
        if (!RegExp(r'^(08|\+62)\d{7,12}$').hasMatch(rawPhone)) {
          setState(() => _phoneError = 'Nomor telepon tidak valid');
          return false;
        }
        _phoneNumber = rawPhone;
        break;
      case 3:
        if (_farmName.trim().isEmpty || _farmLocation.isEmpty) {
          setState(() => _farmError = 'Lengkapi semua data!');
          return false;
        }
        break;
      case 4:
        if (_selectedAnimals.isEmpty) {
          setState(() => _animalError = 'Minimal pilih 1 ternak!');
          return false;
        }
        break;
    }
    return true;
  }

  int get _totalSegments => _role == 'pembeli' ? 4 : 5;

  int _getActiveSegment(int step) {
    if (_role == 'pembeli') {
      if (step == 0) return 0; 
      if (step == 1) return 1; 
      if (step == 2) return 2; 
      if (step == 4) return 3; 
      if (step == 5) return 4; 
      return 0; 
    } else {
      return step;
    }
  }

  void _animateToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submit() async {
    final profileProvider = context.read<ProfileProvider>();

    final success = await profileProvider.submitOnboardingData(
      nama: _nama.trim(),
      role: _role,
      phoneNumber: _phoneNumber,
      farmName: _role == 'peternak' ? _farmName : null,
      farmLocation: _role == 'peternak' ? _farmLocation : null,
      animalTypes: _role == 'peternak' ? _selectedAnimals.join(', ') : null,
      preferences: _role == 'pembeli' ? _selectedAnimals.join(', ') : null,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        _role == 'peternak'
            ? RouteGenerator.breaderHome
            : RouteGenerator.buyerHome,
        (route) => false,
      );
    } else if (profileProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileProvider.errorMessage!),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OnboardingStepLayout(
                  totalSegments: _totalSegments,
                  activeSegment: _getActiveSegment(0),
                  onBack: _goBack,
                  onNext: _goNext,
                  child: _RoleStep(
                    selectedRole: _role,
                    onRoleChanged: (r) => setState(() => _role = r),
                    errorMessage: _roleError,
                  ),
                ),
                OnboardingStepLayout(
                  totalSegments: _totalSegments,
                  activeSegment: _getActiveSegment(1),
                  onBack: _goBack,
                  onNext: _goNext,
                  child: _NameStep(
                    controller: _nameController,
                    onChanged: (v) => _nama = v,
                    errorMessage: _nameError,
                  ),
                ),
                OnboardingStepLayout(
                  totalSegments: _totalSegments,
                  activeSegment: _getActiveSegment(2),
                  onBack: _goBack,
                  onNext: _goNext,
                  child: _PhoneStep(
                    controller: _phoneController,
                    onChanged: (v) => _phoneNumber = v,
                    errorMessage: _phoneError,
                  ),
                ),
                OnboardingStepLayout(
                  totalSegments: _totalSegments,
                  activeSegment: _getActiveSegment(3),
                  onBack: _goBack,
                  onNext: _goNext,
                  child: _FarmStep(
                    farmNameController: _farmNameController,
                    onFarmNameChanged: (v) => _farmName = v,
                    farmLocation: _farmLocation.isEmpty ? null : _farmLocation,
                    provinces: _provinces,
                    onLocationChanged: (v) =>
                        setState(() => _farmLocation = v ?? ''),
                    errorMessage: _farmError,
                  ),
                ),
                OnboardingStepLayout(
                  totalSegments: _totalSegments,
                  activeSegment: _getActiveSegment(4),
                  onBack: _goBack,
                  onNext: _goNext,
                  child: _AnimalStep(
                    animals: _animals,
                    selectedAnimals: _selectedAnimals,
                    onToggle: (label) => setState(() {
                      if (_selectedAnimals.contains(label)) {
                        _selectedAnimals.remove(label);
                      } else {
                        _selectedAnimals.add(label);
                      }
                    }),
                    errorMessage: _animalError,
                  ),
                ),
                _AllSetStep(
                  totalSegments: _totalSegments,
                  activeSegment: _getActiveSegment(5),
                  onBack: _goBack,
                  isLoading: profileProvider.isLoading,
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoleStep extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final String? errorMessage;

  const _RoleStep({
    required this.selectedRole,
    required this.onRoleChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OnboardingStepHeader(
          title: 'Siapakah kamu?',
          subtitle: 'Lagi beternak, atau mau beli ternak?',
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            Expanded(
              child: RoleCard(
                label: 'Peternak',
                imagePath: 'assets/images/login/peternak.png',
                isSelected: selectedRole == 'peternak',
                onTap: () => onRoleChanged('peternak'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RoleCard(
                label: 'Pembeli Ternak',
                imagePath: 'assets/images/login/pembeli.png',
                isSelected: selectedRole == 'pembeli',
                onTap: () => onRoleChanged('pembeli'),
              ),
            ),
          ],
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 16),
          OnboardingErrorBox(message: errorMessage!),
        ],
      ],
    );
  }
}

class _PhoneStep extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorMessage;

  const _PhoneStep({
    required this.controller,
    required this.onChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OnboardingStepHeader(
          title: 'Nomor Telepon',
          subtitle: 'Masukkan nomor telepon kamu',
        ),
        CustomTextField(
          label: 'Nomor Telepon',
          hintText: 'Masukkan nomor telepon kamu',
          controller: controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            PhoneNumberFormatter(),
          ],
          prefixIcon: const Icon(
            Icons.phone_outlined,
            color: LivestColors.textSecondary,
            size: 20,
          ),
          onChanged: onChanged,
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Color(0xFFE53935), fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

class _NameStep extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorMessage;

  const _NameStep({
    required this.controller,
    required this.onChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OnboardingStepHeader(
          title: 'Kenalan, yuk!',
          subtitle: 'Nama kamu siapa?',
        ),
        CustomTextField(
          label: 'Nama',
          hintText: 'Masukkan nama kamu',
          controller: controller,
          keyboardType: TextInputType.name,
          prefixIcon: const SizedBox.shrink(),
          onChanged: onChanged,
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Color(0xFFE53935), fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

class _FarmStep extends StatelessWidget {
  final TextEditingController farmNameController;
  final ValueChanged<String> onFarmNameChanged;
  final String? farmLocation;
  final List<String> provinces;
  final ValueChanged<String?> onLocationChanged;
  final String? errorMessage;

  const _FarmStep({
    required this.farmNameController,
    required this.onFarmNameChanged,
    required this.farmLocation,
    required this.provinces,
    required this.onLocationChanged,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OnboardingStepHeader(
          title: 'Profil Peternakanmu',
          subtitle: 'Nama dan lokasi peternakanmu',
        ),
        CustomTextField(
          label: 'Nama Peternakan',
          hintText: 'Masukkan nama peternakan',
          controller: farmNameController,
          prefixIcon: const SizedBox.shrink(),
          onChanged: onFarmNameChanged,
        ),
        const SizedBox(height: LivestSizes.spaceBtwInputFields),
        LocationDropdown(
          value: farmLocation,
          items: provinces,
          hasError: errorMessage != null,
          onChanged: onLocationChanged,
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 8),
          OnboardingErrorBox(message: errorMessage!),
        ],
      ],
    );
  }
}

class _AnimalStep extends StatelessWidget {
  final List<Map<String, String>> animals;
  final Set<String> selectedAnimals;
  final ValueChanged<String> onToggle;
  final String? errorMessage;

  const _AnimalStep({
    required this.animals,
    required this.selectedAnimals,
    required this.onToggle,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OnboardingStepHeader(
          title: 'Mau Ternak Apa?',
          subtitle: 'Ternak apa yang menjadi preferensimu?',
          textAlign: TextAlign.center,
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
          children: animals.map((a) {
            final label = a['label']!;
            return AnimalCard(
              label: label,
              imagePath: a['image']!,
              isSelected: selectedAnimals.contains(label),
              onTap: () => onToggle(label),
            );
          }).toList(),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 16),
          OnboardingErrorBox(message: errorMessage!),
        ],
      ],
    );
  }
}

class _AllSetStep extends StatelessWidget {
  final int totalSegments;
  final int activeSegment;
  final VoidCallback onBack;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _AllSetStep({
    required this.totalSegments,
    required this.activeSegment,
    required this.onBack,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: LivestColors.textPrimary,
                ),
                onPressed: onBack,
              ),
              Expanded(
                child: SegmentedProgressBar(
                  totalSegments: totalSegments,
                  activeSegment: activeSegment,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login/sapisiap.png',
                height: 240,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              Text(
                'Akunmu sudah siap!',
                style: LivestTypography.displayMd.copyWith(
                  color: LivestColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Siap untuk memulai perjalanan bersama Livest?',
                style: LivestTypography.bodySm.copyWith(
                  color: LivestColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: CustomButton(
            text: 'Siap!',
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}
