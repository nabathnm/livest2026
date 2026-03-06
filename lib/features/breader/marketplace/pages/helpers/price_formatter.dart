String formatPrice(int? price) {
  if (price == null) return "Rp 0";
  final formatted = price.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
  return "Rp $formatted";
}
