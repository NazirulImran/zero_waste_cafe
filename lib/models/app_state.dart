// ⚠️ REFERENCE CODE ONLY - WILL NOT RUN IN FIGMA MAKE

import 'package:flutter/foundation.dart';
import 'dart:math';
import 'food_item.dart';
import 'reservation.dart';

class AppState extends ChangeNotifier {
  List<FoodItem> _foodItems = [];
  List<Reservation> _reservations = [];
  Reservation? _currentReservation;

  AppState() {
    _foodItems = _generateMockData();
  }

  List<FoodItem> get foodItems => _foodItems;
  List<Reservation> get reservations => _reservations;
  Reservation? get currentReservation => _currentReservation;

  // Eco Stats
  double get totalSaved {
    return _reservations
        .where((r) => r.status == 'completed')
        .fold(0.0, (sum, r) {
      return sum + (r.foodItem.originalPrice - r.foodItem.discountedPrice) * r.quantity;
    });
  }

  int get mealsRescued {
    return _reservations
        .where((r) => r.status == 'completed')
        .fold(0, (sum, r) => sum + r.quantity);
  }



  void createReservation(FoodItem item, int quantity) {
    final random = Random();
    final code = (100000 + random.nextInt(900000)).toString();

    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodItem: item,
      pickupCode: code,
      reservedAt: DateTime.now(),
      quantity: quantity,
      status: 'pending',
    );

    _reservations.insert(0, reservation);
    _currentReservation = reservation;

    // Update inventory
    final index = _foodItems.indexWhere((f) => f.id == item.id);
    if (index != -1) {
      _foodItems[index].availableQuantity -= quantity;
    }

    notifyListeners();
  }

  void markAsPickedUp(String reservationId) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index].status = 'completed';
      if (_currentReservation?.id == reservationId) {
        _currentReservation!.status = 'completed';
      }
      notifyListeners();
    }
  }

  void addFoodItem(FoodItem item) {
    _foodItems.insert(0, item);
    notifyListeners();
  }

  void clearCurrentReservation() {
    _currentReservation = null;
    notifyListeners();
  }

  static List<FoodItem> _generateMockData() {
    return [
      FoodItem(
        id: '1',
        name: 'Nasi Lemak Sambal Sotong',
        cafe: 'Kafe Limbong',
        originalPrice: 8.0,
        discountedPrice: 3.00,
        pickupTime: '11:00 AM - 12:00 PM',
        category: 'Malaysian',
        imageUrl: 'https://images.deliveryhero.io/image/fd-my/LH/xybf-listing.jpg',
        availableQuantity: 3,
        description: 'Delicious Nasi Lemak with sambal sotong, boiled egg, and crispy anchovies.',
      ),
      FoodItem(
        id: '2',
        name: 'Nasi Ayam Bakar',
        cafe: 'Kafe KKSAM',
        originalPrice: 7.00,
        discountedPrice: 4.00,
        pickupTime: '3:30 PM - 4:00 PM',
        category: 'Asian',
        imageUrl: 'https://images.deliveryhero.io/image/fd-my/LH/h0xd-listing.jpg',
        availableQuantity: 5,
      ),
      FoodItem(
        id: '3',
        name: 'Set Kuih Muih',
        cafe: 'Bus Stop Belakang UMT',
        originalPrice: 5.00,
        discountedPrice: 2.00,
        pickupTime: '11:00 AM - 11:30 AM',
        category: 'Breakfast',
        imageUrl: 'https://images.deliveryhero.io/image/fd-my/LH/jxsi-listing.jpg',
        availableQuantity: 4,
      ),
      FoodItem(
        id: '4',
        name: 'Mee Goreng',
        cafe: 'Kafe Kompleks Kuliah',
        originalPrice: 6.50,
        discountedPrice: 3.00,
        pickupTime: '12:00 PM - 1:00 PM',
        category: 'Malaysian',
        imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800',
        availableQuantity: 2,
      ),
      FoodItem(
        id: '5',
        name: 'Nasi Ayam Penyet',
        cafe: 'Kedai Bawah FSKM',
        originalPrice: 9.00,
        discountedPrice: 4.50,
        pickupTime: '1:00 PM - 2:00 PM',
        category: 'Indonesian',
        imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800',
        availableQuantity: 6,
      ),
      FoodItem(
        id: '6',
        name: 'Fried Rice Special',
        cafe: 'Kafe Limbong',
        originalPrice: 7.50,
        discountedPrice: 3.75,
        pickupTime: '5:00 PM - 6:00 PM',
        category: 'Asian',
        imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800',
        availableQuantity: 4,
      ),
      FoodItem(
        id: '7',
        name: 'Curry Laksa',
        cafe: 'Kafe KKSAM',
        originalPrice: 8.00,
        discountedPrice: 4.00,
        pickupTime: '11:30 AM - 12:30 PM',
        category: 'Malaysian',
        imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
        availableQuantity: 3,
      ),
      FoodItem(
        id: '8',
        name: 'Sandwich Set',
        cafe: 'Bus Stop Belakang UMT',
        originalPrice: 6.00,
        discountedPrice: 3.00,
        pickupTime: '10:00 AM - 11:00 AM',
        category: 'Western',
        imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=800',
        availableQuantity: 0,
      ),
    ];
  }
}
