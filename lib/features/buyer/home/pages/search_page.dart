import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/buyer/home/pages/detail_product_page.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_chip.dart';
import 'package:livest/features/buyer/home/pages/widgets/dot.dart';
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
          SizedBox(height: 16),
          // ── Category chips ──
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
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
      automaticallyImplyLeading: false,
      toolbarHeight: 110,
      backgroundColor: LivestColors.baseWhite,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [Text("Search"), SizedBox(height: 8), _buildSearchBar()],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(90),
            border: Border.all(width: 2, color: LivestColors.primaryLight),
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
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
              ),
              Image.asset("assets/images/icon/search.png"),
            ],
          ),
        );
      },
    );
  }

  // ── History ──────────────────────────────────────────────────────────────

  Widget _buildHistory(SearchProvider provider) {
    if (provider.history.isEmpty) {
      return Center(
        child: SizedBox(
          width: 258,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .center,
            children: [
              Image.asset("assets/images/mascot/search.png"),
              Text(
                textAlign: .center,
                'Yah, ternak yang kamu cari belum tersedia nih...',
                style: LivestTypography.bodySmSemiBold,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                title: Row(
                  children: [
                    Image.asset("assets/images/icon/history.png"),
                    SizedBox(width: 16),
                    Text(
                      item,
                      style: LivestTypography.bodyMd.copyWith(
                        color: LivestColors.textPrimary,
                      ),
                    ),
                  ],
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
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailProductPage(product: product),
                      ),
                    );
                  },
                );
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
      child: SizedBox(
        width: 258,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: .center,
          children: [
            Image.asset("assets/images/mascot/search.png"),
            Text(
              textAlign: .center,
              'Yah, ternak yang kamu cari belum tersedia nih...',
              style: LivestTypography.bodySmSemiBold,
            ),
          ],
        ),
      ),
    );
  }

  // ── Loading ──────────────────────────────────────────────────────────────

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [Dot(delay: 0), Dot(delay: 200), Dot(delay: 400)],
          ),
          SizedBox(height: 24),
          Text(
            "Melakukan pencarian...",
            style: LivestTypography.bodyMdSemiBold,
          ),
        ],
      ),
    );
  }
}
