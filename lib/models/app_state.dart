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
        description: 'Grilled chicken served with fragrant rice and spicy sambal.',
      ),
      FoodItem(
        id: '3',
        name: 'Set Kuih Muih',
        cafe: 'Bus Stop Belakang UMT',
        originalPrice: 2.50,
        discountedPrice: 0.00,
        pickupTime: '11:00 AM - 11:30 AM',
        category: 'Breakfast',
        imageUrl: 'https://images.deliveryhero.io/image/fd-my/LH/jxsi-listing.jpg',
        availableQuantity: 4,
        description: 'Assorted traditional Malaysian kuih muih selection.',
      ),
      FoodItem(
        id: '4',
        name: 'Mee Goreng',
        cafe: 'Kafe Kompleks Kuliah',
        originalPrice: 4.50,
        discountedPrice: 2.00,
        pickupTime: '12:00 PM - 1:00 PM',
        category: 'Malaysian',
        imageUrl: 'https://i.ytimg.com/vi/j_a2szbPzfA/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLC6m02QZjdMXrfV5OXOKKid_YJx8Q',
        description: 'Spicy fried noodles with vegetables and fried egg.',
        availableQuantity: 8,
      ),
      FoodItem(
        id: '5',
        name: 'Nasi Ayam Penyet',
        cafe: 'Kedai Bawah FSKM',
        originalPrice: 9.00,
        discountedPrice: 4.50,
        pickupTime: '3:00 PM - 4:00 PM',
        category: 'Indonesian',
        imageUrl: 'https://i.ytimg.com/vi/99wEdIAACvw/sddefault.jpg',
        availableQuantity: 6,
        description: 'Crispy smashed fried chicken served with rice and sambal.',
      ),
      FoodItem(
        id: '6',
        name: 'Nasi Goreng Kampung Telur Mata',
        cafe: 'Kafe Limbong',
        originalPrice: 7.00,
        discountedPrice: 3.50,
        pickupTime: '10:00 PM - 11:00 PM',
        category: 'Asian',
        imageUrl: 'https://i.ytimg.com/vi/sLw7tAUznrk/maxresdefault.jpg',
        availableQuantity: 4,
        description: 'Traditional village-style spicy fried rice topped with a sunny-side-up egg.',
      ),
      FoodItem(
        id: '7',
        name: 'Mee Kari Ayam',
        cafe: 'Kafe KKSAM',
        originalPrice: 8.00,
        discountedPrice: 3.50,
        pickupTime: '4:00 PM - 5:30 PM',
        category: 'Malaysian',
        imageUrl: 'https://i.ytimg.com/vi/F6W_5TlgXis/sddefault.jpg',
        availableQuantity: 3,
        description: 'Savory chicken curry noodles with a rich and spicy broth.',
      ),
      FoodItem(
        id: '8',
        name: 'Sandwich Sardin',
        cafe: 'Bus Stop Belakang UMT',
        originalPrice: 3.00,
        discountedPrice: 0.00,
        pickupTime: '10:30 AM - 11:30 AM',
        category: 'Breakfast',
        imageUrl: 'https://i.ytimg.com/vi/Oy2j4D7BL5k/maxresdefault.jpg',
        availableQuantity: 7,
        description: 'Classic sardine sandwich with fresh vegetables and mayo.',
      ),
    ];
  }
}
