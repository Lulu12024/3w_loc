// lib/features/announcement/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/announcement_provider.dart';
import '../models/announcement.dart';
import '../widgets/announcement_card.dart';
import '../../profile/screens/profile_screen.dart';
import '../../auth/providers/auth_provider.dart';
import 'create_announcement_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/new_custom_text_field.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'Outillages',
    'Jardinages',
    'Véhicules',
    'Sport',
    'Événements',
    'Services',
    'Ménager',
    'Puériculture',
    'Cuisine',
    'Jeux',
  ];

  // Données en dur pour les annonces premium (modifié pour éviter les erreurs)
  final List<Map<String, dynamic>> _premiumAnnouncements = [
    {
      'id': '1',
      'title': 'Perceuse professionnelle',
      'price': 15.0,
      'image': 'assets/images/perceuse.jpg'
    },
    {
      'id': '2',
      'title': 'Tondeuse à gazon',
      'price': 25.0,
      'image': 'assets/images/tondeuse.jpg'
    },
    {
      'id': '3',
      'title': 'Vélo de ville',
      'price': 10.0,
      'image': 'assets/images/velo.jpg'
    },
  ];

  final Map<String, int> _categoryCount = {
    'Outillages': 208,
    'Jardinages': 49,
    'Véhicules': 26,
    'Sport': 9,
    'Événements': 71,
    'Services': 5,
    'Ménager': 32,
    'Puériculture': 2,
    'Cuisine': 7,
    'Jeux': 5,
  };

  final Map<String, IconData> _categoryIcons = {
    'Outillages': Icons.build,
    'Jardinages': Icons.yard,
    'Véhicules': Icons.directions_car,
    'Sport': Icons.sports,
    'Événements': Icons.celebration,
    'Services': Icons.miscellaneous_services,
    'Ménager': Icons.cleaning_services,
    'Puériculture': Icons.child_care,
    'Cuisine': Icons.kitchen,
    'Jeux': Icons.casino,
  };

  // Pour le carrousel d'images
  final List<String> _carouselImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  int _currentCarouselIndex = 0;
  List<Announcement> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final announcements =
          await Provider.of<AnnouncementProvider>(context, listen: false)
              .fetchAnnouncements(
        category: _selectedCategory == 'Tous' ? null : _selectedCategory,
      );
      setState(() {
        _announcements = announcements;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erreur lors du chargement des annonces: ${error.toString()}'),
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
    final announcements =
        Provider.of<AnnouncementProvider>(context).announcements;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCarousel(),
            _buildPremiumAnnouncements(),
            _buildRentCTA(),
            _buildKeywords(),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildAnnouncementsList(announcements),
            SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeroCarousel() {
    return Stack(
      children: [
        // Carrousel d'images
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.7,
            viewportFraction: 1.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          items: _carouselImages.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        // Contenu superposé
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 10),

            // Barre supérieure avec icône et logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      // Afficher le menu des catégories
                      _showCategoriesDialog();
                    },
                  ),
                  Text(
                    '3W-LOC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Rediriger vers la messagerie
                    },
                  ),
                ],
              ),
            ),

            // Espace pour positionner le texte vers le milieu
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),

            // Texte principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LOUER A PROXIMITÉ !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Louez en toute simplicité près de chez vous sans vous déplacer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Champs de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Champ "Quoi ?"
                  CustomTextField(
                    hintText: 'Quoi ?',
                    isDark: true,
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  
                  // Champ "Où ?"
                  CustomTextField(
                    hintText: 'Où ?',
                    isDark: true,
                    prefixIcon: Icon(Icons.location_on, color: Colors.white70),
                  ),
                  const SizedBox(height: 15),
                  
                  // Bouton de recherche
                  ElevatedButton(
                    onPressed: () {
                      // Action de recherche
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB3022),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Rechercher',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Indicateurs de carrousel
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [0, 1, 2].map((i) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentCarouselIndex == i
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero, // Dialog plein écran
        backgroundColor: Colors.white, // Fond blanc
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre supérieure avec titre et bouton
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recherche par Catégorie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Text(
                        'VOIR PLUS',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      label: Icon(
                        Icons.menu,
                        size: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Grille de catégories - style similaire à la première image
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    if (index == 0) return SizedBox(); // Ignorer "Tous"
                    
                    final category = _categories[index];
                    final count = _categoryCount[category] ?? 0;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _loadAnnouncements();
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Gris clair
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _categoryIcons[category] ?? Icons.category,
                              size: 36,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 12),
                            Text(
                              category,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '($count)',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Footer avec copyright ou marque
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30, top: 10),
                child: Text(
                  'soxim.fr',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPremiumAnnouncements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Annonce premium',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Naviguer vers la liste complète des annonces
                },
                child: Text('Voir tout'),
              ),
            ],
          ),
        ),
        
        // Affichage des annonces premium en dur
        Container(
          height: 260,
          child: _premiumAnnouncements.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Aucune annonce trouvée',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _premiumAnnouncements.length,
                  itemBuilder: (context, index) {
                    final announcement = _premiumAnnouncements[index];
                    return GestureDetector(
                      onTap: () {
                        // Utilisation d'une vérification null pour éviter les erreurs
                        final id = announcement['id']?.toString() ?? '';
                        GoRouter.of(context).push('/announcement/$id');
                      },
                      child: Container(
                        width: 250,
                        margin: EdgeInsets.only(left: 16, right: index == _premiumAnnouncements.length - 1 ? 16 : 0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image sans overlay de lecture
                              Container(
                                height: 150,
                                width: double.infinity,
                                child: Image.asset(
                                  announcement['image']?.toString() ?? 'assets/images/placeholder.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  },
                                ),
                              ),
                              // Informations sur l'annonce
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      announcement['title']?.toString() ?? 'Sans titre',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          // Utilisez des valeurs par défaut si null
                                          (announcement['rating']?.toString() ?? '0.0'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "(${announcement['reviews']?.toString() ?? '0'})",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      announcement['location']?.toString() ?? 'Emplacement inconnu',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  Widget _buildRentCTA() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Avez-vous quelque chose à louer ?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Louez vos produits et services en ligne GRATUITEMENT. C\'est plus facile que vous pouvez l\'imaginer !',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/create-announcement');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDB3022),
                foregroundColor:
                    Colors.white, // Modifié à blanc pour lisibilité
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Démarrez maintenant!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywords() {
    final keywords = [
      'bissell',
      'shampouineuse',
      'injecteur',
      'extracteur',
      'tapis',
      'moquette',
      'karcher'
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.label, color: Colors.black54),
              SizedBox(width: 8),
              Text(
                'Mots clés:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords.map((keyword) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  keyword,
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    return _categoryIcons[category] ?? Icons.category;
  }

  Widget _buildAnnouncementsList(List<Announcement> announcements) {
    return announcements.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'Aucune annonce trouvée',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toutes les annonces',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: announcements.length,
                  itemBuilder: (ctx, index) {
                    return AnnouncementCard(
                      announcement: announcements[index],
                    );
                  },
                ),
              ],
            ),
          );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 3) {
          GoRouter.of(context).push('/profile');
        } else if (index == 2) {
          GoRouter.of(context).push('/create-announcement');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Recherche',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Publier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Mon compte',
        ),
      ],
    );
  }
}
