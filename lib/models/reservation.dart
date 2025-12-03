// ⚠️ REFERENCE CODE ONLY - WILL NOT RUN IN FIGMA MAKE

import 'food_item.dart';

class Reservation {
  final String id;
  final FoodItem foodItem;
  final String pickupCode;
  final DateTime reservedAt;
  final int quantity;
  String status; // 'pending' or 'completed'

  Reservation({
    required this.id,
    required this.foodItem,
    required this.pickupCode,
    required this.reservedAt,
    required this.quantity,
    this.status = 'pending',
  });

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
}
