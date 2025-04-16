// lib/features/announcement/screens/create_announcement_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/announcement_provider.dart';
import '../models/announcement.dart';
import '../../auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  static const routeName = '/create-announcement';

  const CreateAnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _termsController = TextEditingController();

  String _selectedCategory = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  List<File> _selectedImages = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'Outillages',
    'Jardinages',
    'Véhicules',
    'Services',
    'Sport',
    'Électronique',
    'Événements',
    'Électroménager',
    'Matériel Audiovisuel',
    'Bricolage',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImages = await picker.pickMultiImage();

      if (pickedImages.isNotEmpty) {
        setState(() {
          for (final image in pickedImages) {
            _selectedImages.add(File(image.path));
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Erreur lors de la sélection des images: ${e.toString()}'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', ''),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', ''),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _createAnnouncement() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter au moins une image'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Ici, vous devrez implémenter l'upload des images vers votre serveur
      // et récupérer les URLs des images uploadées
      List<String> imageUrls = await _uploadImages(_selectedImages);

      // Récupérer l'utilisateur connecté
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Créer l'annonce avec les données du formulaire
      final categoryObj = Category(
        id: '1', // À remplacer par l'ID réel de la catégorie
        wording: _selectedCategory,
      );

      final announcement = Announcement(
        id: '', // L'ID sera généré par le serveur
        title: _titleController.text,
        description: _descriptionController.text,
        pictures: imageUrls,
        rentalPrice: double.parse(_priceController.text),
        status: true,
        availabilityStartDate: _startDate,
        availabilityEndDate: _endDate,
        expirationDate: DateTime.now().add(const Duration(days: 90)),
        category: categoryObj,
        rentalTerms: _termsController.text,
        location: _locationController.text,
        proprietaire: user,
      );

      await Provider.of<AnnouncementProvider>(context, listen: false)
          .createAnnouncement(announcement);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Annonce créée avec succès!'),
          backgroundColor: Colors.green,
        ),
      );

      context.pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors de la création de l\'annonce: ${error.toString()}'),
          backgroundColor: Color(0xFFDB3022),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Cette fonction simule l'upload des images
  // Dans une implémentation réelle, vous devrez envoyer les images à votre API
  Future<List<String>> _uploadImages(List<File> images) async {
    // Simuler un délai d'upload
    await Future.delayed(const Duration(seconds: 2));
    // Retourner des URLs factices pour les images
    return List.generate(
        images.length, (index) => 'https://example.com/image_$index.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une annonce'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                const SizedBox(height: 20),
                _buildBasicInfoSection(),
                const SizedBox(height: 20),
                _buildAvailabilitySection(),
                const SizedBox(height: 20),
                _buildTermsSection(),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Publier l\'annonce',
                  isLoading: _isLoading,
                  onPressed: _createAnnouncement,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Ajoutez des photos pour illustrer votre matériel (min 1, max 5)',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Bouton d'ajout d'image
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Icon(
                    Icons.add_a_photo,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
              // Images sélectionnées
              ..._selectedImages.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 15,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations de base',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _titleController,
          label: 'Titre',
          hintText: 'Donnez un titre à votre annonce',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un titre';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _descriptionController,
          label: 'Description',
          hintText: 'Décrivez votre matériel, son état, etc.',
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer une description';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _priceController,
          label: 'Prix de location (€/jour)',
          hintText: 'ex: 25',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer un prix';
            }
            if (double.tryParse(value) == null) {
              return 'Le prix doit être un nombre';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _locationController,
          label: 'Localisation',
          hintText: 'Adresse ou quartier',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer une localisation';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catégorie',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Disponibilité',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Du',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectStartDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatter.format(_startDate)),
                          const Icon(Icons.calendar_today, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Au',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectEndDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatter.format(_endDate)),
                          const Icon(Icons.calendar_today, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conditions de location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: _termsController,
          label: 'Conditions',
          hintText: 'Caution, entretien, règles spécifiques, etc.',
          maxLines: 3,
        ),
      ],
    );
  }
}
