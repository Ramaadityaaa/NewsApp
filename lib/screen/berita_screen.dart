import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk autentikasi
import '../models/article.dart'; // Model data berita
import '../services/news_service.dart'; // Service untuk ambil berita
import 'detail_screen.dart'; // Halaman detail berita
import 'saved_screen.dart'; // Halaman berita yang disimpan
import 'login_screen.dart'; // Halaman login

// Widget utama yang menampilkan berita
class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller untuk pencarian
  List<Article> _berita = []; // Semua berita dari API
  List<Article> _filteredBerita = []; // Berita hasil pencarian
  bool _isLoading = true; // Status loading

  @override
  void initState() {
    super.initState();
    _fetchBeritaFromApi(); // Ambil data saat pertama kali dibuka
  }

  // Ambil berita dari API
  void _fetchBeritaFromApi() async {
    try {
      final berita = await NewsService().fetchTopHeadlines();
      setState(() {
        _berita = berita;
        _filteredBerita = berita;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Tampilkan error kalau gagal ambil berita
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat berita: $e')));
    }
  }

  // Filter berita berdasarkan teks pencarian
  void _filterBerita(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBerita = List.from(_berita);
      } else {
        _filteredBerita =
            _berita
                .where(
                  (item) =>
                      item.title.toLowerCase().contains(query.toLowerCase()) ||
                      item.description.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  // Fungsi logout dari Firebase
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // Setelah logout, kembali ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan tombol bookmark dan logout
      appBar: AppBar(
        title: const Text('Hot News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: 'Baca Nanti',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Kolom pencarian
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari Berita',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterBerita,
            ),
          ),
          // Tampilan utama: loading atau list berita
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Loading saat ambil berita
                    : OrientationBuilder(
                      builder: (context, orientation) {
                        return ListView.builder(
                          itemCount: _filteredBerita.length,
                          itemBuilder: (context, index) {
                            final berita = _filteredBerita[index];
                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                // Tampilan berita dalam orientasi portrait
                                child:
                                    orientation == Orientation.portrait
                                        ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (berita.imageUrl != null)
                                              Image.network(
                                                berita.imageUrl!,
                                                width: double.infinity,
                                                height: 160,
                                                fit: BoxFit.cover,
                                              ),
                                            const SizedBox(height: 8),
                                            Text(
                                              berita.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(berita.description),
                                            const SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Buka detail berita
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) => DetailScreen(
                                                          article: berita,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Baca Selengkapnya',
                                              ),
                                            ),
                                          ],
                                        )
                                        // Tampilan berita dalam orientasi landscape
                                        : Row(
                                          children: [
                                            if (berita.imageUrl != null)
                                              Image.network(
                                                berita.imageUrl!,
                                                width: 140,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    berita.title,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    berita.description,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Buka detail berita
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (_) =>
                                                                  DetailScreen(
                                                                    article:
                                                                        berita,
                                                                  ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'Baca Selengkapnya',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
