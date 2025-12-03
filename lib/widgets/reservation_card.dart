// ⚠️ REFERENCE CODE ONLY - WILL NOT RUN IN FIGMA MAKE

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reservation.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onMarkAsPickedUp;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onMarkAsPickedUp,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = reservation.isPending;
    final statusColor = isPending ? const Color(0xFF16A34A) : const Color(0xFF3B82F6);
    final statusBgColor = isPending ? const Color(0xFFDCFCE7) : const Color(0xFFDEEDFF);
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    reservation.foodItem.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPending ? 'Pending' : 'Completed',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Pickup Code
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code, color: Color(0xFF16A34A)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup Code',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reservation.pickupCode,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Details
            _buildDetailRow(Icons.location_on, reservation.foodItem.cafe),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.access_time, reservation.foodItem.pickupTime),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.shopping_bag_outlined,
              'Quantity: ${reservation.quantity}',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.calendar_today,
              dateFormat.format(reservation.reservedAt),
            ),
            const SizedBox(height: 12),

            // Price
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Color(0xFF16A34A)),
                const SizedBox(width: 8),
                Text(
                  'RM ${reservation.foodItem.discountedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'RM ${reservation.foodItem.originalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),

            // Action Button
            if (isPending) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onMarkAsPickedUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("I've Picked Up"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}
