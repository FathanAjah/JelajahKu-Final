//borobudur.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SamosirPage extends StatefulWidget {
  const SamosirPage({super.key});

  @override
  State<SamosirPage> createState() => _SamosirPageState();
}

class _SamosirPageState extends State<SamosirPage> {
  int likeCount = 400;
  int dislikeCount = 50;
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
    const double latitude = 2.6556;
    const double longitude = 98.8154;
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
            'images/samosir.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ImageSection(image: 'images/samosir.jpg'),
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
              name: 'Samosir Island',
              location: 'Lake Toba, North Sumatra',
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
              'Pulau Samosir adalah sebuah pulau vulkanik yang terletak di tengah Danau Toba, '
                  'dan termasuk wilayah Kabupaten Samosir, Provinsi Sumatera Utara. Pulau ini terbentuk '
                  'akibat letusan supervulkan purba ribuan tahun yang lalu. Selain menawarkan panorama alam '
                  'yang menakjubkan berupa danau, pegunungan, dan udara sejuk, Pulau Samosir juga merupakan pusat '
                  'kebudayaan Batak Toba. Di sini, pengunjung dapat menemukan rumah adat Batak, situs sejarah, '
                  'tarian tradisional, dan museum yang memperkenalkan kekayaan budaya lokal. Pulau Samosir menjadi '
                  'destinasi wisata favorit bagi wisatawan lokal maupun mancanegara yang ingin menikmati keindahan '
                  'alam dan budaya Indonesia.',
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
        const Text('4.7', style: TextStyle(fontSize: 16, color: Colors.black87)),
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
        _buildReview('Rina Marlina', 'Alam yang luar biasa indah!', 5.0,
            'https://picsum.photos/200/300/?blur=2'),
        _buildReview('Clara Simanjuntak', 'Destinasi terbaik untuk healing!', 4.6,
            'https://picsum.photos/id/1084/200/300'),
        _buildReview('Emily Tan', 'Salah satu tempat paling indah yang pernah saya kunjungi.', 4.5,
            'https://picsum.photos/seed/picsum/200/300'),
        _buildReview('Budi Hartanto', 'Kaya budaya dan ramah penduduknya.', 5.0,
            'https://picsum.photos/200/300/?blur'),
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