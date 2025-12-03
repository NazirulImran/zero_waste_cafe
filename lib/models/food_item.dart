// ⚠️ REFERENCE CODE ONLY - WILL NOT RUN IN FIGMA MAKE

class FoodItem {
  final String id;
  final String name;
  final String cafe;
  final double originalPrice;
  final double discountedPrice;
  final String pickupTime;
  final String category;
  final String imageUrl;
  int availableQuantity;
  final String description;

  FoodItem({
    required this.id,
    required this.name,
    required this.cafe,
    required this.originalPrice,
    required this.discountedPrice,
    required this.pickupTime,
    required this.category,
    required this.imageUrl,
    required this.availableQuantity,
    this.description = '',
  });

  int get discount {
    return (((originalPrice - discountedPrice) / originalPrice) * 100).round();
  }

  bool get isAvailable => availableQuantity > 0;

  double get savingsAmount => originalPrice - discountedPrice;
}
