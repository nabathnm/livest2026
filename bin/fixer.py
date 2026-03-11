import re

with open(r"d:\vs code\flutterProject\livest2026\lib\features\buyer\home\pages\home_page.dart", "r") as f:
    text = f.read()

# We know the bug is in the final section, after GridView.builder. 
# Let's replace the whole section from Consumer builder to end of file
new_end = """                    Consumer<BuyerMarketplaceProvider>(
                      builder: (context, provider, _) {
                        if (provider.products.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Text(
                                'Produk tidak tersedia',
                                style: LivestTypography.bodyMd.copyWith(
                                  color: LivestColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.6,
                              ),
                          itemBuilder: (context, index) {
                            final product = provider.products[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailProductPage(product: product),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
"""

text = re.sub(r'                    Consumer<BuyerMarketplaceProvider>\(.*$', new_end, text, flags=re.MULTILINE|re.DOTALL)

with open(r"d:\vs code\flutterProject\livest2026\lib\features\buyer\home\pages\home_page.dart", "w") as f:
    f.write(text)
