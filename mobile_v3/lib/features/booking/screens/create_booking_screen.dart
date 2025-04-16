// lib/features/booking/screens/create_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../booking/providers/booking_provider.dart';
import '../../announcement/models/announcement.dart';
import 'package:go_router/go_router.dart';

class CreateBookingScreen extends StatefulWidget {
  static const routeName = '/create-booking';
  final Announcement announcement;

  const CreateBookingScreen({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;
  bool _isDeliverySelected = true;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    // Initialiser les dates avec les dates de disponibilité de l'annonce
    if (_startDate.isBefore(widget.announcement.availabilityStartDate)) {
      _startDate = widget.announcement.availabilityStartDate;
    }
    _endDate = _startDate.add(const Duration(days: 1));
    if (_endDate.isAfter(widget.announcement.availabilityEndDate)) {
      _endDate = widget.announcement.availabilityEndDate;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: widget.announcement.availabilityStartDate,
      lastDate: widget.announcement.availabilityEndDate,
      locale: const Locale('fr', ''),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate) || _endDate == _startDate) {
          _endDate = _startDate.add(const Duration(days: 1));
          if (_endDate.isAfter(widget.announcement.availabilityEndDate)) {
            _endDate = widget.announcement.availabilityEndDate;
          }
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate.add(const Duration(days: 1)),
      lastDate: widget.announcement.availabilityEndDate,
      locale: const Locale('fr', ''),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  int _calculateTotalDays() {
    return _endDate.difference(_startDate).inDays;
  }

  double _calculateTotalPrice() {
    final totalDays = _calculateTotalDays();
    return totalDays * widget.announcement.rentalPrice;
  }

  Future<void> _createBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<BookingProvider>(context, listen: false).createBooking(
        widget.announcement.id,
        _startDate,
        _endDate,
        _isDeliverySelected,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Réservation créée avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors de la création de la réservation: ${error.toString()}'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnnouncementInfo(),
              const SizedBox(height: 30),
              _buildDateSelection(),
              const SizedBox(height: 30),
              _buildDeliveryOptions(),
              const SizedBox(height: 30),
              _buildPriceSummary(),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Confirmer la réservation',
                isLoading: _isLoading,
                onPressed: _createBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détails de la location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.announcement.pictures.isNotEmpty
                    ? Image.network(
                        widget.announcement.pictures[0],
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
                      widget.announcement.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                            widget.announcement.location,
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
                    const SizedBox(height: 5),
                    Text(
                      'Propriétaire: ${widget.announcement.proprietaire.firstName} ${widget.announcement.proprietaire.lastName}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Période de location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Du'),
                  TextButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(
                      _dateFormat.format(_startDate),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Au'),
                  TextButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(
                      _dateFormat.format(_endDate),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Durée totale'),
                  Text(
                    '${_calculateTotalDays()} jour${_calculateTotalDays() > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mode de livraison',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              RadioListTile<bool>(
                title: const Text('Je veux être livré'),
                value: true,
                groupValue: _isDeliverySelected,
                onChanged: (value) {
                  setState(() {
                    _isDeliverySelected = value!;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<bool>(
                title: const Text('J\'irai récupérer'),
                value: false,
                groupValue: _isDeliverySelected,
                onChanged: (value) {
                  setState(() {
                    _isDeliverySelected = value!;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    final deliveryFee = _isDeliverySelected ? 15.0 : 0.0;
    final subtotal = _calculateTotalPrice();
    final total = subtotal + deliveryFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Récapitulatif',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.announcement.rentalPrice.toStringAsFixed(0)} € x ${_calculateTotalDays()} jour${_calculateTotalDays() > 1 ? 's' : ''}',
                  ),
                  Text(
                    '${subtotal.toStringAsFixed(0)} €',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Livraison'),
                  Text(
                    '${deliveryFee.toStringAsFixed(0)} €',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${total.toStringAsFixed(0)} €',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
