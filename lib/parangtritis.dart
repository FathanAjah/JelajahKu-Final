//parangtritis.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ditambahkan untuk fungsionalitas peta

// Stateful widget karena membutuhkan pengelolaan state (like/dislike)
class ParangtritisPage extends StatefulWidget {
  const ParangtritisPage({super.key});

  @override
  State<ParangtritisPage> createState() => _ParangtritisPageState();
}

// State dari ParangtritisPage
class _ParangtritisPageState extends State<ParangtritisPage> {
  int likeCount = 230;
  int dislikeCount = 8;
  bool isLiked = false;
  bool isDisliked = false;

  // Fungsi untuk toggle like
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

  // Fungsi untuk toggle dislike
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

  // --- FUNGSI BARU UNTUK MEMBUKA PETA ---
  // Fungsi ini akan membuka aplikasi peta eksternal
  Future<void> _launchMapsUrl() async {
    // Koordinat untuk Pantai Parangtritis
    const double latitude = -8.0284;
    const double longitude = 110.3291;
    final Uri mapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(mapsUrl)) {
      await launchUrl(mapsUrl);
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
    return Scaffold( // Dihapus MaterialApp dan home agar bisa navigasi dari halaman lain
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
          // Background image
          Image.asset(
            'images/parangtritis.jpg',
            fit: BoxFit.cover,
          ),
          // Lapisan hitam transparan di atas gambar
          Container(color: Colors.black.withOpacity(0.7)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Gambar utama pantai
                  const ImageSection(image: 'images/parangtritis.jpg'),
                  const SizedBox(height: 16),
                  // Card berisi info, tombol like/dislike, deskripsi, review
                  InfoCard(
                    likeCount: likeCount,
                    dislikeCount: dislikeCount,
                    isLiked: isLiked,
                    isDisliked: isDisliked,
                    onLikePressed: toggleLike,
                    onDislikePressed: toggleDislike,
                    onMapPressed: _launchMapsUrl, // Memanggil fungsi peta
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

// Stateless Widget untuk menampilkan gambar utama destinasi
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

//Stateless Widget untuk menampilkan card dengan informasi destinasi, tombol like/dislike, deskripsi dan review
class InfoCard extends StatelessWidget {
  final int likeCount;
  final int dislikeCount;
  final bool isLiked;
  final bool isDisliked;
  final VoidCallback onLikePressed;
  final VoidCallback onDislikePressed;
  final VoidCallback onMapPressed; // Ditambahkan parameter untuk tombol peta

  const InfoCard({
    super.key,
    required this.likeCount,
    required this.dislikeCount,
    required this.isLiked,
    required this.isDisliked,
    required this.onLikePressed,
    required this.onDislikePressed,
    required this.onMapPressed, // Diperlukan parameter untuk tombol peta
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
              name: 'Parangtritis Beach',
              location: 'Yogyakarta, DIY',
            ),
            const SizedBox(height: 16),

            // Tombol Map, Like, & Dislike
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.map_outlined, color: Colors.grey),
                      onPressed: onMapPressed, // Menggunakan fungsi dari parameter
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

            // Deskripsi destinasi
            const TextSection(
              description:
              'Parangtritis adalah sebuah pantai yang terkenal di Yogyakarta, Indonesia, '
                  'terletak sekitar 27 km di selatan kota Yogyakarta. Pantai ini dikenal karena '
                  'ombaknya yang besar, pasir hitam vulkanik, serta suasana mistis yang erat kaitannya dengan '
                  'legenda Ratu Kidul, penguasa laut selatan dalam kepercayaan Jawa. Parangtritis menjadi tujuan '
                  'wisata populer untuk menikmati pemandangan matahari terbenam, bermain layang-layang, menunggang '
                  'kuda, atau menyewa ATV di sepanjang pantai.',
            ),

            const SizedBox(height: 24),

            // Review dari user
            const ReviewSection(),
          ],
        ),
      ),
    );
  }
}

//Stateless Widget menampilkan nama dan lokasi destinasi
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

//Stateless Widget menampilkan deskripsi destinasi
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

// Stateless Widget menampilkan review dari user
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
        _buildReview('Rina Kurniawan',
            'Pantainya luas dan cocok buat keluarga. Anak-anak senang naik delman dan main pasir. Sayangnya, tempat parkir agak penuh saat akhir pekan. Tapi tetap worth it buat liburan singkat.',
            4.5, 'https://picsum.photos/200/300/?blur=1'),
        _buildReview('Lestari Putri',
            'Pemandangan sunset di Parangtritis luar biasa indah. Saya juga sempat naik ATV—pengalaman seru banget! Sayangnya, kebersihan pantai kadang kurang terjaga, semoga ke depannya bisa lebih diperhatikan.',
            5.0, 'https://picsum.photos/id/237/200/300'),
        _buildReview('Raka Surya',
            'Parangtritis punya daya tarik tersendiri. Saya naik ATV menyusuri pantai, seru banget! Sayangnya agak ramai saat liburan, jadi lebih enak datang di hari biasa.',
            4.0, 'https://picsum.photos/200/300?grayscale'),
        _buildReview('Intan Ningsih',
            'Pantainya luas dan cocok untuk menikmati sunset. Saya suka suasana mistisnya yang unik, terasa beda dibanding pantai lain. Tapi ombaknya cukup besar, jadi hati-hati kalau bawa anak-anak.',
            4.5, 'https://picsum.photos/200/300/?blur=4'),
      ],
    );
  }

  // Fungsi pembantu untuk membuat review dari user
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