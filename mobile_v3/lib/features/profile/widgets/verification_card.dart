// lib/features/profile/widgets/verification_card.dart
import 'package:flutter/material.dart';

class VerificationCard extends StatelessWidget {
  final List<VerificationItem> verificationItems;

  const VerificationCard({
    Key? key,
    required this.verificationItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vérifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...verificationItems.map((item) => _buildVerificationItem(item)).toList(),
            const SizedBox(height: 16),
            Text(
              'Vérifiez toujours l\'identité du prestataire avant de commencer un projet.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationItem(VerificationItem item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    item.isVerified ? 'Vérifié' : 'Non-vérifié',
                    style: TextStyle(
                      color: item.isVerified ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    item.isVerified ? Icons.check_circle : Icons.error,
                    color: item.isVerified ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class VerificationItem {
  final String label;
  final bool isVerified;
  final String? details;

  VerificationItem({
    required this.label,
    required this.isVerified,
    this.details,
  });
}

// Example usage:
// 
// final verificationItems = [
//   VerificationItem(
//     label: 'Pièce d\'identité (Lionel...)',
//     isVerified: true,
//   ),
//   VerificationItem(
//     label: 'Adresse email',
//     isVerified: true,
//   ),
//   VerificationItem(
//     label: 'N° de téléphone',
//     isVerified: false,
//   ),
//   VerificationItem(
//     label: 'Compte Facebook',
//     isVerified: true,
//   ),
//   VerificationItem(
//     label: 'Compte LinkedIn',
//     isVerified: true,
//   ),
// ];
// 
// VerificationCard(verificationItems: verificationItems)