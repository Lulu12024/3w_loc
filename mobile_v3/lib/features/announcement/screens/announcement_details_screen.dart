// lib/features/announcement/screens/announcement_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/announcement_provider.dart';
import '../models/announcement.dart';
import '../../booking/screens/create_booking_screen.dart';
import '../../../shared/widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class AnnouncementDetailsScreen extends StatefulWidget {
  static const routeName = '/announcement-details';
  final String id;

  const AnnouncementDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AnnouncementDetailsScreen> createState() =>
      _AnnouncementDetailsScreenState();
}

class _AnnouncementDetailsScreenState extends State<AnnouncementDetailsScreen> {
  bool _isLoading = true;
  late Announcement _announcement;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAnnouncement();
  }

  Future<void> _loadAnnouncement() async {
    try {
      final announcement =
          await Provider.of<AnnouncementProvider>(context, listen: false)
              .fetchAnnouncementById(widget.id);
      setState(() {
        _announcement = announcement;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors du chargement de l\'annonce: ${error.toString()}'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isLoading ? Text(_announcement.title) : null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.pop(), // Remplacé Navigator.of(context).pop()
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildDescription(),
                        const SizedBox(height: 20),
                        _buildPriceAndAvailability(),
                        const SizedBox(height: 20),
                        _buildOwnerInfo(),
                        const SizedBox(height: 30),
                        CustomButton(
                          text: 'Réserver',
                          onPressed: () {
                            // Remplacé Navigator.of(context).pushNamed
                            // Pour passer des arguments avec GoRouter, utilisez extra:
                            context.push(
                              '/create-booking',
                              extra: _announcement,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          child: _announcement.pictures.isEmpty
              ? Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 50,
                  ),
                )
              : PageView.builder(
                  itemCount: _announcement.pictures.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      _announcement.pictures[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 50,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
        if (_announcement.pictures.length > 1)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _announcement.pictures.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _announcement.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '${_announcement.rentalPrice.toStringAsFixed(0)} €/jour',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.grey[600],
              size: 16,
            ),
            const SizedBox(width: 5),
            Text(
              _announcement.location,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 18,
            ),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 18,
            ),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 18,
            ),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 18,
            ),
            const Icon(
              Icons.star_half,
              color: Colors.amber,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              '(${(4.5).toStringAsFixed(1)})',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _announcement.description,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAvailability() {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prix et disponibilité',
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
                  const Text('Prix journalier'),
                  Text(
                    '${_announcement.rentalPrice.toStringAsFixed(0)} €',
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
                  const Text('Disponible du'),
                  Text(
                    formatter.format(_announcement.availabilityStartDate),
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
                  const Text('au'),
                  Text(
                    formatter.format(_announcement.availabilityEndDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_announcement.rentalTerms.isNotEmpty) ...[
                const Divider(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Conditions de location: '),
                    Expanded(
                      child: Text(
                        _announcement.rentalTerms,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerInfo() {
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
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                backgroundImage: _announcement.proprietaire.photoProfil != null
                    ? NetworkImage(_announcement.proprietaire.photoProfil!)
                    : null,
                child: _announcement.proprietaire.photoProfil == null
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
                      '${_announcement.proprietaire.firstName} ${_announcement.proprietaire.lastName}',
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
              TextButton(
                onPressed: () {
                  // Implémentation de la messagerie avec le propriétaire
                },
                child: const Text('Contacter'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
