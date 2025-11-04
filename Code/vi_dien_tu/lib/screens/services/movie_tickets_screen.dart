import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_dien_tu/providers/settings_provider.dart';
import 'package:vi_dien_tu/services/api_service.dart';

class MovieTicketsScreen extends StatefulWidget {
  const MovieTicketsScreen({super.key});

  @override
  State<MovieTicketsScreen> createState() =>
      _MovieTicketsScreenState();
}

class _MovieTicketsScreenState
    extends State<MovieTicketsScreen> {
  List<Map<String, dynamic>> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final apiService = ApiService();
    final loadedMovies =
        await apiService.getMovies();
    setState(() {
      movies = loadedMovies;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor:
              const Color(0xFFFFF8DC),
          appBar: AppBar(
            backgroundColor:
                const Color(0xFFDA020E),
            foregroundColor: Colors.white,
            title: Text(settings.isEnglish
                ? 'Movie Tickets'
                : 'Mua vé xem phim'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDA020E), Color(0xFFFF6B6B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator())
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return _buildMovieCard(
                        movie, settings);
                  },
                ),
        );
      },
    );
  }

  Widget _buildMovieCard(
      Map<String, dynamic> movie,
      SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(
                      top: Radius.circular(12)),
            ),
            child: const Center(
              child: Icon(
                Icons.movie,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie['genre'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    Text(
                      ' ${movie['rating']}/10',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${movie['duration']} ${settings.isEnglish ? 'min' : 'phút'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFDA020E),
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                8),
                      ),
                    ),
                    child: Text(settings.isEnglish
                        ? 'Book Tickets'
                        : 'Đặt vé'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
