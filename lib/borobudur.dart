//borobudur.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BorobudurPage extends StatefulWidget {
  const BorobudurPage({super.key});

  @override
  State<BorobudurPage> createState() => _BorobudurPageState();
}

class _BorobudurPageState extends State<BorobudurPage> {
  int likeCount = 120;
  int dislikeCount = 5;
  bool isLiked = false;
  bool isDisliked = false;

  void toggleLike() {
    setState(() {
      if (isLiked) {
        isLiked = false;
        likeCount--;
      } else {
        isLiked = true;
        likeCount++;
        if (isDisliked) {
          isDisliked = false;
          dislikeCount--;
        }
      }
    });
  }

  void toggleDislike() {
    setState(() {
      if (isDisliked) {
        isDisliked = false;
        dislikeCount--;
      } else {
        isDisliked = true;
        dislikeCount++;
        if (isLiked) {
          isLiked = false;
          likeCount--;
        }
      }
    });
  }

  Future<void> _launchMapsUrl() async {
    const double latitude = -7.6079;
    const double longitude = 110.2038;
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka peta')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/borobudur.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ImageSection(image: 'images/borobudur.jpg'),
                  const SizedBox(height: 16),
                  InfoCard(
                    likeCount: likeCount,
                    dislikeCount: dislikeCount,
                    isLiked: isLiked,
                    isDisliked: isDisliked,
                    onLikePressed: toggleLike,
                    onDislikePressed: toggleDislike,
                    onMapPressed: _launchMapsUrl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget ImageSection
class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(image, height: 200, width: double.infinity, fit: BoxFit.cover),
    );
  }
}

class InfoCard extends StatelessWidget {
  final int likeCount;
  final int dislikeCount;
  final bool isLiked;
  final bool isDisliked;
  final VoidCallback onLikePressed;
  final VoidCallback onDislikePressed;
  final VoidCallback onMapPressed;

  const InfoCard({
    super.key,
    required this.likeCount,
    required this.dislikeCount,
    required this.isLiked,
    required this.isDisliked,
    required this.onLikePressed,
    required this.onDislikePressed,
    required this.onMapPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleSection(
              name: 'Borobudur Temple',
              location: 'Magelang, Central Java',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.map_outlined, color: Colors.grey),
                      onPressed: onMapPressed,
                    ),
                    const Text('Map'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: onLikePressed,
                    ),
                    Text('$likeCount'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isDisliked ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
                        color: isDisliked ? Colors.red : Colors.grey,
                      ),
                      onPressed: onDislikePressed,
                    ),
                    Text('$dislikeCount'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextSection(
              description:
              'Candi Borobudur adalah candi Buddha yang terletak di Magelang, Jawa Tengah. '
                  'Dibangun pada abad ke-8 dan ke-9 oleh Dinasti Syailendra, candi ini merupakan situs Buddha '
                  'terbesar di dunia dengan lebih dari 2.600 panel relief dan 504 arca Buddha. Terdaftar sebagai Situs '
                  'Warisan Dunia UNESCO, Borobudur menawarkan keindahan arsitektur dan spiritualitas yang mendalam di '
                  'tengah lanskap alam yang memukau.',
            ),
            const SizedBox(height: 24),
            const ReviewSection(),
          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.name, required this.location});
  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(location, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            ],
          ),
        ),
        const Icon(Icons.star, color: Colors.amber),
        const SizedBox(width: 4),
        const Text('4.9', style: TextStyle(fontSize: 16, color: Colors.black87)),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
      textAlign: TextAlign.justify,
    );
  }
}

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('User Reviews',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
        const SizedBox(height: 16),
        _buildReview('Bambang Sudarsono', 'Tempat yang sangat menakjubkan, tempat ini sangat cantik.', 4.5,
            'https://picsum.photos/200/300/?blur=2'),
        _buildReview('Siti Nurjanah', 'Pemandangan di tempat ini sangat cantik, cocok untuk menjadi tempat rileks', 5.0,
            'https://picsum.photos/id/1084/200/300'),
        _buildReview('Tio Yulistio', 'Tempat ini sangat menakjubkan', 4.0,
            'https://picsum.photos/seed/picsum/200/300'),
      ],
    );
  }

  Widget _buildReview(String name, String review, double rating, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 24,
            onBackgroundImageError: (exception, stackTrace) {
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(review, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating.floor() ? Icons.star : (index < rating ? Icons.star_half : Icons.star_border),
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}