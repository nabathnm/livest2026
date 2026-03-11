import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/features/breader/home/models/education_model.dart';

class EducationDetailPage extends StatefulWidget {
  final EducationModel artikel;

  const EducationDetailPage({super.key, required this.artikel});

  @override
  State<EducationDetailPage> createState() => EducationDetailPageState();
}

class EducationDetailPageState extends State<EducationDetailPage> {
  final Set<int> _checkedItems = {};

  @override
  Widget build(BuildContext context) {
    final artikel = widget.artikel;

    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: LivestAppbar(name: "Konten"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero Image ──
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: Image.network(
                        artikel.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200,
                          color: LivestColors.primaryLightHover,
                          child: const Icon(Icons.image, size: 60),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title ──
                        Text(
                          artikel.title,
                          style: LivestTypography.bodyLgBold.copyWith(
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ── Category Badge ──
                        _CategoryBadge(category: artikel.category),
                        const SizedBox(height: 20),

                        // ── Sections ──
                        ..._buildSections(artikel.sections),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5E3C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Kembali ke Edukasi',
                    style: LivestTypography.bodyMdBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(List<ArtikelSection> sections) {
    final widgets = <Widget>[];
    int checklistGroupIndex = 0;

    for (final section in sections) {
      switch (section.type) {
        case 'heading':
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                section.heading!,
                style: LivestTypography.bodyLgSemiBold,
              ),
            ),
          );
          break;

        case 'paragraph':
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                section.paragraph!,
                style: LivestTypography.bodyMd.copyWith(
                  color: LivestColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          );
          break;

        case 'chips':
          final chips = section.chips!;
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: chips.map((chip) => _ChipItem(label: chip)).toList(),
              ),
            ),
          );
          break;

        case 'checklist':
          final items = section.checklist!;
          final groupIdx = checklistGroupIndex++;
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: List.generate(items.length, (i) {
                  final key = groupIdx * 100 + i;
                  return _ChecklistItem(
                    text: items[i],
                    isChecked: _checkedItems.contains(key),
                    onTap: () {
                      setState(() {
                        if (_checkedItems.contains(key)) {
                          _checkedItems.remove(key);
                        } else {
                          _checkedItems.add(key);
                        }
                      });
                    },
                  );
                }),
              ),
            ),
          );
          break;
      }
    }

    return widgets;
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  Color get _color {
    switch (category) {
      case 'Kesehatan':
        return const Color(0xFFE8F4F0);
      case 'Perawatan':
        return const Color(0xFFF0EBE3);
      case 'Pakan':
        return const Color(0xFFF5F0E8);
      default:
        return const Color(0xFFF0F0F0);
    }
  }

  Color get _textColor {
    switch (category) {
      case 'Kesehatan':
        return const Color(0xFF2D8B5E);
      case 'Perawatan':
        return const Color(0xFF8B5E3C);
      case 'Pakan':
        return const Color(0xFF7A6B3A);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        category,
        style: LivestTypography.bodySm.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String label;
  const _ChipItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: LivestColors.baseBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        label,
        style: LivestTypography.bodyMd.copyWith(
          color: LivestColors.textPrimary,
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String text;
  final bool isChecked;
  final VoidCallback onTap;

  const _ChecklistItem({
    required this.text,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: LivestColors.baseBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked
                    ? LivestColors.primaryNormal
                    : Colors.transparent,
                border: Border.all(
                  color: isChecked
                      ? LivestColors.primaryNormal
                      : LivestColors.textSecondary,
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: LivestTypography.bodyMd.copyWith(
                  color: LivestColors.textPrimary,
                  height: 1.4,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  decorationColor: LivestColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
