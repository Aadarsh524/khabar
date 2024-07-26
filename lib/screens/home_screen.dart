import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khabar/bloc/cubit.dart';
import 'package:khabar/bloc/state.dart';
import 'package:khabar/model/news_model.dart';
import 'package:khabar/screens/detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 30,
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/notification.png',
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 12.0, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Latest',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )),
                  Text('See all',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: TabBarWidget(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NewsLoaded) {
                    final filteredArticles =
                        state.newsModel.articles?.where((article) {
                      return article.source != null &&
                          article.source?.name != null &&
                          article.title != null &&
                          article.urlToImage != null &&
                          article.publishedAt != null;
                    }).toList();

                    if (filteredArticles != null &&
                        filteredArticles.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<NewsCubit>().fetchNews();
                        },
                        child: ListView.builder(
                          itemCount: filteredArticles.length,
                          itemBuilder: (context, index) {
                            return NewsTile(article: filteredArticles[index]);
                          },
                        ),
                      );
                    } else {
                      return const Center(child: Text('No articles available'));
                    }
                  } else if (state is NewsError) {
                    return Center(
                        child: Text('Failed to fetch news: ${state.message}'));
                  }
                  return const Center(child: Text('Select a category'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          TabButton(text: "All", isSelected: true),
          TabButton(text: "Sports"),
          TabButton(text: "Politics"),
          TabButton(text: "Business"),
          TabButton(text: "Health"),
          TabButton(text: "Travel"),
          TabButton(text: "Science"),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;

  const TabButton({super.key, required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {},
              child: Text(text,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey,
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  )))),

          const SizedBox(
              height: 4), // Add some space between text and underline
          Container(
            height: 2,
            width: 30, // Adjust the width as needed
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  final Articles article;

  const NewsTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(article: article),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    article.urlToImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Europe',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          )),
                      const SizedBox(height: 4),
                      Text(
                        article.title ?? '',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(article.url!),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article.author ?? '',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                size: 14,
                                color: Colors.grey,
                              ),
                              Text(
                                _formatDate(article.publishedAt),
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.more_horiz_sharp),
                iconSize: 15,
                color: Colors.grey,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    final date = DateTime.tryParse(dateString);
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      final minutes = difference.inMinutes % 60;
      return '${difference.inHours}h ${minutes}m ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
