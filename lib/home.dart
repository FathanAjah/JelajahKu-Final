//home.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'borobudur.dart';
import 'prambanan.dart';
import 'parangtritis.dart';
import 'keraton.dart';
import 'besakih.dart';
import 'samosir.dart';
import 'telagawarna.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _username = "Guest";

  final List<Map<String, dynamic>> destinations = [
    {
      'title': 'Borobudur Temple',
      'subtitle': 'Magelang, Central Java',
      'image': 'images/borobudur.jpg',
      'page': const BorobudurPage(),
    },
    {
      'title': 'Prambanan Temple',
      'subtitle': 'Yogyakarta, DIY',
      'image': 'images/prambanan.jpg',
      'page': const PrambananPage(),
    },
    {
      'title': 'Parangtritis Beach',
      'subtitle': 'Yogyakarta, DIY',
      'image': 'images/parangtritis.jpg',
      'page': const ParangtritisPage(),
    },
    {
      'title': 'Keraton Castle',
      'subtitle': 'Yogyakarta, DIY',
      'image': 'images/keraton.jpg',
      'page': const KeratonPage(),
    },
    {
      'title': 'Besakih Temple',
      'subtitle': 'Bali',
      'image': 'images/besakih.jpg',
      'page': const BesakihPage(),
    },
    {
      'title': 'Samosir Island',
      'subtitle': 'Lake Toba, North Sumatra',
      'image': 'images/samosir.jpg',
      'page': const SamosirPage(),
    },
    {
      'title': 'Lake of Colours',
      'subtitle': 'Dieng Plateau, Central Java',
      'image': 'images/telagawarna.jpg',
      'page': const TelagaPage(),
    },
    {
      'title': 'Comingsoon',
      'subtitle': 'Comingsoon',
      'image': 'images/gunung.jpg',
      'page': null,
    },
  ];

  final Set<int> favorites = {};
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;
  bool _isExpanded = false; // State to control the list's visibility

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _username = _user?.displayName ?? "Guest";
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= destinations.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _handleLogout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which list to display based on the _isExpanded state
    final displayedDestinations = _isExpanded ? destinations : destinations.take(4).toList();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/gunung.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.blueGrey);
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                PopupMenuButton<String>(
                  color: Colors.white,
                  offset: const Offset(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _handleLogout();
                    } else if (value == 'settings') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pengaturan belum tersedia")),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings, color: Colors.black),
                          SizedBox(width: 8),
                          Text("Settings"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Log Out"),
                        ],
                      ),
                    ),
                  ],
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: const AssetImage('images/user.jpg'),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Welcome, $_username!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 2, color: Colors.black54)
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final item = destinations[index];
                      return GestureDetector(
                        onTap: () {
                          if (item['page'] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => item['page']),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Halaman ini belum tersedia")),
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  item['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: Colors.grey);
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 4, color: Colors.black)
                                      ],
                                    ),
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(destinations.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Destination',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 3,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Build the list of destinations
                for (int i = 0; i < displayedDestinations.length; i++)
                  _buildListItem(context, index: i, data: displayedDestinations[i]),

                // Conditionally display "See More" or "See Less" button
                if (destinations.length > 4)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                      onPressed: _toggleExpanded,
                      child: Text(
                        _isExpanded ? 'See Less' : 'See More',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, {required int index, required Map<String, dynamic> data}) {
    // Find the original index of the data to maintain correct favorite status
    final originalIndex = destinations.indexOf(data);
    final bool isFavorite = favorites.contains(originalIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        child: ListTile(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onTap: () {
            if (data['page'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => data['page']),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Halaman ini belum tersedia")),
              );
            }
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              data['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 50);
              },
            ),
          ),
          title: Text(data['title'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(data['subtitle']),
          trailing: PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              if (value == 'favorite') {
                _toggleFavorite(originalIndex);
              } else if (value == 'report') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Dilaporkan!")),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Report'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text('Favorit'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}