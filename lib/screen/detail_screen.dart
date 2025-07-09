import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  void _checkIfSaved() async {
    final box = Hive.box<Article>('saved_news');
    final exists = box.values.any((a) => a.title == widget.article.title);
    setState(() {
      _isSaved = exists;
    });
  }

  void _toggleSave() async {
    final box = Hive.box<Article>('saved_news');
    if (_isSaved) {
      final key = box.keys.firstWhere(
        (k) => box.get(k)?.title == widget.article.title,
        orElse: () => null,
      );
      if (key != null) await box.delete(key);
    } else {
      await box.add(widget.article);
    }

    setState(() {
      _isSaved = !_isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved ? 'Ditambahkan ke Baca Nanti' : 'Dihapus dari Baca Nanti',
        ),
      ),
    );
  }

  void _launchURL() async {
    final uri = Uri.parse(widget.article.url ?? '');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: _toggleSave,
            icon: Icon(
              _isSaved ? Icons.star : Icons.star_border,
              color: Colors.yellowAccent,
            ),
            tooltip: _isSaved ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null) Image.network(article.imageUrl!),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(article.description),
            const Spacer(),
            ElevatedButton(
              onPressed: _launchURL,
              child: const Text('Baca di Web'),
            ),
          ],
        ),
      ),
    );
  }
}
