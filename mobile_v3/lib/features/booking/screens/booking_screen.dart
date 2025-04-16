// lib/features/booking/screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';
import 'booking_details_screen.dart';
import 'package:go_router/go_router.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/bookings';

  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<BookingProvider>(context, listen: false)
          .fetchUserBookings();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors du chargement des réservations: ${error.toString()}'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<BookingProvider>(context).bookings;
    final activeBookings =
        bookings.where((b) => b.status != 'terminé').toList();
    final completedBookings =
        bookings.where((b) => b.status == 'terminé').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes réservations'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'En location'),
            Tab(text: 'Terminées'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList(activeBookings),
                _buildBookingsList(completedBookings),
              ],
            ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    return bookings.isEmpty
        ? const Center(
            child: Text(
              'Aucune réservation trouvée',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: bookings.length,
            itemBuilder: (ctx, index) {
              return _buildBookingCard(bookings[index]);
            },
          );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push('/booking/${booking.id}');
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: booking.announcement.pictures.isNotEmpty
                    ? Image.network(
                        booking.announcement.pictures[0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
              ),
              title: Text(
                booking.announcement.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    '${_formatDate(booking.dateReservation)} - ${_formatDate(booking.dateFin)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _buildStatusIndicator(booking.status),
                      const SizedBox(width: 5),
                      Text(
                        _getStatusText(booking.status),
                        style: TextStyle(
                          color: _getStatusColor(booking.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Text(
                '${_calculateTotalPrice(booking).toStringAsFixed(0)} €',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (booking.status != 'terminé')
              Padding(
                padding: const EdgeInsets.only(right: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (booking.status == 'en attente')
                      TextButton(
                        onPressed: () => _cancelBooking(booking.id),
                        child: const Text('Annuler'),
                      ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push('/booking/${booking.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text('Détails'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  double _calculateTotalPrice(Booking booking) {
    final days = booking.dateFin.difference(booking.dateReservation).inDays;
    return days * booking.announcement.rentalPrice;
  }

  Future<void> _cancelBooking(String id) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<BookingProvider>(context, listen: false)
          .cancelBooking(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Réservation annulée avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'annulation: ${error.toString()}'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
