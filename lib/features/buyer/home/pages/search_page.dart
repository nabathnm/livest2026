import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_chip.dart';
import 'package:livest/features/buyer/home/pages/widgets/product_card.dart';
import 'package:livest/features/buyer/home/provider/search_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  static const _chips = ['Sapi Madura', 'Ayam Negeri', 'Bebek', 'Ayam'];

  @override
  void initState() {
    super.initState();
    // Auto-focus keyboard saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit(String query) {
    if (query.trim().isEmpty) return;
    _focusNode.unfocus();
    context.read<SearchProvider>().search(query.trim());
  }

  void _onChipTap(String query) {
    _controller.text = query;
    _onSubmit(query);
  }

  void _onHistoryTap(String query) {
    _controller.text = query;
    _onSubmit(query);
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchProvider>().reset();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Category chips ──
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => CategoryChip(
                title: _chips[i],
                onTap: () => _onChipTap(_chips[i]),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Body ──
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, _) {
                // Loading
                if (provider.isLoading) return _buildLoading();

                // Tidak ada hasil
                if (provider.isEmpty) return _buildEmpty();

                // Ada hasil
                if (provider.hasSearched && provider.results.isNotEmpty) {
                  return _buildResults(provider);
                }

                // Default: tampilkan history
                return _buildHistory(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: LivestColors.baseWhite,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: LivestColors.textHeading,
        ),
        onPressed: () {
          context.read<SearchProvider>().reset();
          Navigator.pop(context);
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: _buildSearchBar(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 44,
          decoration: BoxDecoration(
            color: LivestColors.baseBackground,
            borderRadius: BorderRadius.circular(32),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: _onSubmit,
            style: LivestTypography.bodyMd.copyWith(
              color: LivestColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Cari di Livest',
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
              suffixIcon: _controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _onClear,
                      child: const Icon(
                        Icons.close_rounded,
                        color: LivestColors.textSecondary,
                        size: 20,
                      ),
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}), // update suffix icon
          ),
        );
      },
    );
  }

  // ── History ──────────────────────────────────────────────────────────────

  Widget _buildHistory(SearchProvider provider) {
    if (provider.history.isEmpty) {
      return Center(
        child: Text(
          'Belum ada riwayat pencarian',
          style: LivestTypography.bodyMd.copyWith(
            color: LivestColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pencarian terakhir',
                style: LivestTypography.bodyMdBold.copyWith(
                  color: LivestColors.textHeading,
                ),
              ),
              GestureDetector(
                onTap: provider.clearHistory,
                child: Text(
                  'Hapus semua',
                  style: LivestTypography.bodySm.copyWith(
                    color: LivestColors.primaryNormal,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final item = provider.history[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                leading: const Icon(
                  Icons.history_rounded,
                  color: LivestColors.textSecondary,
                  size: 22,
                ),
                title: Text(
                  item,
                  style: LivestTypography.bodyMd.copyWith(
                    color: LivestColors.textPrimary,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () => provider.removeHistory(item),
                  child: const Icon(
                    Icons.close_rounded,
                    color: LivestColors.textSecondary,
                    size: 18,
                  ),
                ),
                onTap: () => _onHistoryTap(item),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────

  Widget _buildResults(SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${provider.results.length} hasil untuk "${provider.query}"',
            style: LivestTypography.bodySm.copyWith(
              color: LivestColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              itemCount: provider.results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.50,
              ),
              itemBuilder: (context, index) {
                final product = provider.results[index];
                return ProductCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty ────────────────────────────────────────────────────────────────

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/illustration/empty_search.png',
              height: 160,
              errorBuilder: (_, _, _) => const Icon(
                Icons.search_off_rounded,
                size: 80,
                color: LivestColors.primaryLightHover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Yah, ternak yang kamu cari belum\ntersedia nih...',
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

  // ── Loading ──────────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: LivestColors.primaryNormal),
    );
  }
}
