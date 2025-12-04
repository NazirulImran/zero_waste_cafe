import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/app_state.dart';
import '../models/reservation.dart'; // Ensure this import exists
import 'home_screen.dart';

class ReservationConfirmationScreen extends StatelessWidget {
  // 1. Accept optional reservation so Profile can pass it in
  final Reservation? reservation;

  const ReservationConfirmationScreen({
    super.key,
    this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    // 2. Determine which reservation to show
    // (Use the passed one, or fall back to the "current" one in state)
    final displayReservation = reservation ?? appState.currentReservation;

    if (displayReservation == null) {
      return const HomeScreen();
    }

    final isPending = displayReservation.isPending;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0FDF4), Color(0xFFD1FAE5)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Success Icon ---
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isPending
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPending ? Icons.history : Icons.check_circle,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Title ---
                  Text(
                    isPending ? 'Reservation Successful!' : 'Pickup Successful!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isPending
                          ? const Color(0xFF15803D)
                          : const Color(0xFF1D4ED8),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Subtitle ---
                  Text(
                    isPending
                        ? 'Your food has been reserved. Show this code during pickup.'
                        : 'Thank you for helping reduce food waste!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- QR Code and Details Card ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // QR Code
                        if (isPending) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QrImageView(
                              data: displayReservation.pickupCode,
                              version: QrVersions.auto,
                              size: 150,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Pickup Code
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            border: Border.all(
                              color: const Color(0xFF16A34A),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Pickup Code',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                displayReservation.pickupCode,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Food Details Divider
                        Divider(color: Colors.grey[200]),
                        const SizedBox(height: 16),

                        Text(
                          displayReservation.foodItem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildDetailRow(
                          Icons.location_on,
                          'Pickup Location',
                          displayReservation.foodItem.cafe,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          Icons.access_time,
                          'Pickup Time',
                          displayReservation.foodItem.pickupTime,
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          Icons.shopping_bag_outlined,
                          'Quantity',
                          displayReservation.quantity.toString(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Important Notice ---
                  if (isPending)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        border: Border.all(color: const Color(0xFFFBBF24)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Text('⚠️', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Please arrive during the pickup time window.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // ========================================================
                  // BUTTONS SECTION (Restored to match your request)
                  // ========================================================

                  // 1. "I've Picked Up" Button (Only if pending)
                  if (isPending) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          appState.markAsPickedUp(displayReservation.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "I've Picked Up the Food",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 2. "View My Reservations" Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Home, but switch to Profile Tab (index 1)
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen(initialIndex: 1),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'View My Reservations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. "Back to Home" Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        appState.clearCurrentReservation();
                        // Navigate to Home, Tab 0
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen(initialIndex: 0),
                          ),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF16A34A),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF16A34A), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}