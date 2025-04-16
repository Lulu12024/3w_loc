// lib/features/profile/screens/profile_screen_updated.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTabIndex = 0;
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      // La redirection est gérée par le routeur
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la déconnexion: ${error.toString()}'),
          backgroundColor: const Color(0xFFDB3022),
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
    final user = Provider.of<AuthProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Utilisateur non connecté'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigation vers les paramètres
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user),
            _buildVerifications(),
            _buildTabSelector(),
            const SizedBox(height: 10),
            _buildActionButtons(),
            _selectedTabIndex == 0 ? _buildMyAnnouncements() : _buildMyReservations(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Index pour "Mon compte"
        selectedItemColor: const Color(0xFFDB3022),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            context.go('/');
          } else if (index == 2) {
            context.go('/create-announcement');
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
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: user.photoProfil != null
                    ? NetworkImage(user.photoProfil)
                    : null,
                child: user.photoProfil == null
                    ? const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      )
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
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
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFFDB3022)),
                onPressed: () {
                  // Navigation vers l'édition du profil
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerifications() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vérifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildVerificationItem('Pièce d\'identité', true),
          const Divider(height: 1),
          _buildVerificationItem('Adresse email', true),
          const Divider(height: 1),
          _buildVerificationItem('N° de téléphone', false),
          const Divider(height: 1),
          _buildVerificationItem('Compte Facebook', true),
          const SizedBox(height: 10),
          Text(
            'Vérifiez toujours l\'identité du prestataire avant de commencer un projet.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVerificationItem(String label, bool isVerified) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Row(
            children: [
              Text(
                isVerified ? 'Vérifié' : 'Non-vérifié',
                style: TextStyle(
                  fontSize: 14,
                  color: isVerified ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                isVerified ? Icons.check_circle : Icons.error,
                color: isVerified ? Colors.green : Colors.red,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTabButton('Mes annonces', 0),
          _buildTabButton('Mes réservations', 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFDB3022) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? const Color(0xFFDB3022) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.star,
            label: 'Avis',
            onTap: () {
              // Navigation vers les avis
            },
          ),
          _buildActionButton(
            icon: Icons.message,
            label: 'Messages',
            onTap: () {
              // Navigation vers les messages
            },
          ),
          _buildActionButton(
            icon: Icons.logout,
            label: 'Déconnexion',
            onTap: _logout,
            isLoading: _isLoading,
            color: const Color(0xFFDB3022),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
    Color color = Colors.grey,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  )
                : Icon(
                    icon,
                    color: color,
                  ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyAnnouncements() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(
            Icons.announcement,
            size: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const Text(
            'Vous n\'avez pas encore publié d\'annonces',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/create-announcement');
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
                'Créer une annonce',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyReservations() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(
            Icons.calendar_today,
            size: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const Text(
            'Vous n\'avez pas encore de réservations',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push('/bookings');
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
                'Voir toutes les réservations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}