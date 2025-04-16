// lib/features/booking/screens/booking_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import '../../../shared/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class BookingDetailsScreen extends StatefulWidget {
  static const routeName = '/booking-details';
  final String id;

  const BookingDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isLoading = true;
  late Booking _booking;
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    try {
      final booking = await Provider.of<BookingProvider>(context, listen: false)
          .fetchBookingById(widget.id);
      setState(() {
        _booking = booking;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors du chargement de la réservation: ${error.toString()}'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
    }
  }

  Future<void> _updateBookingStatus(String status) async {
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      await Provider.of<BookingProvider>(context, listen: false)
          .updateBookingStatus(widget.id, status);

      // Recharger la réservation avec le nouveau statut
      await _loadBooking();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Statut de la réservation mis à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors de la mise à jour du statut: ${error.toString()}'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
    } finally {
      setState(() {
        _isUpdatingStatus = false;
      });
    }
  }

  Future<void> _cancelBooking() async {
    final confirmCancel = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content:
            const Text('Êtes-vous sûr de vouloir annuler cette réservation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );

    if (confirmCancel == true) {
      setState(() {
        _isUpdatingStatus = true;
      });

      try {
        await Provider.of<BookingProvider>(context, listen: false)
            .cancelBooking(widget.id);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation annulée avec succès'),
            backgroundColor: Colors.green,
          ),
        );

        context.pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'annulation: ${error.toString()}'),
            backgroundColor: Color(0xFFDB3022),
          ),
        );
      } finally {
        setState(() {
          _isUpdatingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la réservation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBookingHeader(),
                    const SizedBox(height: 20),
                    _buildBookingDetails(),
                    const SizedBox(height: 20),
                    _buildItemDetails(),
                    const SizedBox(height: 20),
                    _buildOwnerDetails(),
                    const SizedBox(height: 30),
                    if (_booking.status == 'en attente') _buildActionButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBookingHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Réservation #${_booking.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _buildStatusIndicator(_booking.status),
                          const SizedBox(width: 5),
                          Text(
                            _getStatusText(_booking.status),
                            style: TextStyle(
                              color: _getStatusColor(_booking.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final days = _booking.dateFin.difference(_booking.dateReservation).inDays;
    final rentalPrice = _booking.announcement.rentalPrice;
    final total = days * rentalPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détails de la réservation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                _buildDetailRow('Date de début',
                    formatter.format(_booking.dateReservation)),
                const Divider(height: 20),
                _buildDetailRow(
                    'Date de fin', formatter.format(_booking.dateFin)),
                const Divider(height: 20),
                _buildDetailRow('Durée', '$days jour${days > 1 ? 's' : ''}'),
                const Divider(height: 20),
                _buildDetailRow(
                    'Mode de livraison',
                    _booking.status == 'delivery'
                        ? 'Livraison'
                        : 'Récupération'),
                const Divider(height: 20),
                _buildDetailRow('Prix total', '${total.toStringAsFixed(0)} €',
                    isBold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Matériel réservé',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _booking.announcement.pictures.isNotEmpty
                      ? Image.network(
                          _booking.announcement.pictures[0],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _booking.announcement.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _booking.announcement.category.wording,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              _booking.announcement.location,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Propriétaire',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _booking.announcement.proprietaire.photoProfil != null
                          ? NetworkImage(
                              _booking.announcement.proprietaire.photoProfil!)
                          : null,
                  child: _booking.announcement.proprietaire.photoProfil == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 30,
                        )
                      : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_booking.announcement.proprietaire.firstName} ${_booking.announcement.proprietaire.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Utilisateur vérifié',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implémentation de la messagerie avec le propriétaire
                  },
                  child: const Text('Contacter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          text: 'Annuler la réservation',
          isLoading: _isUpdatingStatus,
          onPressed: _cancelBooking,
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color;
    switch (status) {
      case 'en attente':
        color = Colors.orange;
        break;
      case 'confirmée':
        color = Colors.green;
        break;
      case 'en cours':
        color = Colors.blue;
        break;
      case 'terminé':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'en attente':
        return 'En attente';
      case 'confirmée':
        return 'Confirmée';
      case 'en cours':
        return 'En cours';
      case 'terminé':
        return 'Terminée';
      default:
        return 'Inconnu';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'en attente':
        return Colors.orange;
      case 'confirmée':
        return Colors.green;
      case 'en cours':
        return Colors.blue;
      case 'terminé':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
