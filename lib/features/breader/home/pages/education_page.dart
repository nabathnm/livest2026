// lib/features/breader/home/pages/education_page.dart

import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/features/breader/home/models/education_model.dart';
import 'package:livest/features/breader/home/pages/education_detail_page.dart';
import 'package:livest/features/breader/home/provider/education_provider.dart';
import 'package:provider/provider.dart';

class EducationPage extends StatelessWidget {
  /// Jika [initialCategory] diisi, langsung filter ke kategori tersebut
  final String? initialCategory;

  const EducationPage({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = EducationProvider();
        if (initialCategory != null) {
          provider.setCategoryAndClearSearch(initialCategory!);
        }
        return provider;
      },
      child: const _EducationPageContent(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EducationPageContent extends StatefulWidget {
  const _EducationPageContent();

  @override
  State<_EducationPageContent> createState() => _EducationPageContentState();
}

class _EducationPageContentState extends State<_EducationPageContent> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Sync controller text bila provider sudah punya query
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EducationProvider>();
      if (provider.searchQuery.isNotEmpty) {
        _searchController.text = provider.searchQuery;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onCategoryTap(EducationProvider provider, String cat) {
    // Saat kategori di-tap, clear search bar
    _searchController.clear();
    provider.setCategory(cat);
    _focusNode.unfocus();
  }

  void _onSearchChanged(EducationProvider provider, String value) {
    provider.setSearch(value);
  }

  void _onClearSearch(EducationProvider provider) {
    _searchController.clear();
    provider.setSearch('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      appBar: LivestAppbar(name: "Edukasi"),
      body: Consumer<EducationProvider>(
        builder: (context, provider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search Bar ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: LivestColors.baseWhite,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: (v) => _onSearchChanged(provider, v),
                    textInputAction: TextInputAction.search,
                    style: LivestTypography.bodyMd,
                    decoration: InputDecoration(
                      hintText: 'Cari konten edukasi',
                      hintStyle: LivestTypography.bodyMd.copyWith(
                        color: LivestColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: LivestColors.textSecondary,
                        size: 22,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () => _onClearSearch(provider),
                              child: const Icon(
                                Icons.close_rounded,
                                color: LivestColors.textSecondary,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    // onChanged: (_) => setState(() {}), // refresh suffix icon
                  ),
                ),
              ),

              // ── Category Chips ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Wrap(
                  spacing: 8,
                  children: EducationProvider.categories.map((cat) {
                    final isSelected = provider.selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => _onCategoryTap(provider, cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? LivestColors.primaryNormal
                              : LivestColors.baseWhite,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Text(
                          cat,
                          style: LivestTypography.bodyMd.copyWith(
                            color: isSelected
                                ? Colors.white
                                : LivestColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // ── Dynamic Title ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTitle(provider),
              ),
              const SizedBox(height: 12),

              // ── Artikel Grid / Empty ─────────────────────────────────────
              Expanded(child: _buildBody(provider)),
            ],
          );
        },
      ),
    );
  }

  // ── Title berubah sesuai state ───────────────────────────────────────────

  Widget _buildTitle(EducationProvider provider) {
    String text;

    if (provider.searchQuery.isNotEmpty) {
      final count = provider.filteredArtikel.length;
      text = '$count hasil untuk "${provider.searchQuery}"';
    } else if (provider.selectedCategory != null) {
      text = 'Kategori: ${provider.selectedCategory}';
    } else {
      text = 'Semua Konten';
    }

    return Text(text, style: LivestTypography.bodyLgBold);
  }

  // ── Body ─────────────────────────────────────────────────────────────────

  Widget _buildBody(EducationProvider provider) {
    final articles = provider.filteredArtikel;

    if (articles.isEmpty) {
      return _buildEmpty(provider.searchQuery);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: articles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 260,
      ),
      itemBuilder: (context, index) {
        final artikel = articles[index];
        return _ArtikelCard(
          artikel: artikel,
          searchQuery: provider.searchQuery,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EducationDetailPage(artikel: artikel),
              ),
            );
          },
        );
      },
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────

  Widget _buildEmpty(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: LivestColors.primaryLightHover,
            ),
            const SizedBox(height: 16),
            Text(
              query.isNotEmpty
                  ? 'Konten "$query" belum tersedia'
                  : 'Konten tidak tersedia',
              style: LivestTypography.bodyMd.copyWith(
                color: LivestColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Artikel Card ─────────────────────────────────────────────────────────────

class _ArtikelCard extends StatelessWidget {
  final EducationModel artikel;
  final String searchQuery;
  final VoidCallback onTap;

  const _ArtikelCard({
    required this.artikel,
    required this.searchQuery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: LivestColors.baseWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──
            Image.network(
              artikel.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(height: 140, color: LivestColors.primaryLightHover),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategoryBadge(category: artikel.category),
                  const SizedBox(height: 6),

                  // Title dengan highlight jika ada query
                  searchQuery.isNotEmpty
                      ? _HighlightText(
                          text: artikel.title,
                          query: searchQuery,
                          style: LivestTypography.bodyMdBold.copyWith(
                            fontSize: 13,
                          ),
                          maxLines: 2,
                        )
                      : Text(
                          artikel.title,
                          style: LivestTypography.bodyMdBold.copyWith(
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                  const SizedBox(height: 4),

                  Text(
                    artikel.shortDesc,
                    style: LivestTypography.bodySm.copyWith(
                      color: LivestColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Highlight text widget ─────────────────────────────────────────────────────

class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;
  final int maxLines;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lowerText.indexOf(lowerQuery, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(
        TextSpan(
          text: text.substring(idx, idx + query.length),
          style: style.copyWith(
            color: LivestColors.primaryNormal,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      start = idx + query.length;
    }

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: style, children: spans),
    );
  }
}

// ── Category Badge ────────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  Color get _bgColor {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        category,
        style: LivestTypography.bodySm.copyWith(
          color: _textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
