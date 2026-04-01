import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? content;

  const ArticleDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. The Expanding Image Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true, // Allows the image to stretch if the user pulls down
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ), // White back button
            flexibleSpace: FlexibleSpaceBar(
              background:
                  imageUrl.isNotEmpty
                      ? Hero(
                        // The tag matches the one from the NewsCard!
                        tag: imageUrl,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Container(color: Colors.grey[300]),
                        ),
                      )
                      : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 50),
                      ),
            ),
          ),

          // 2. The Article Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3, // Adds a little breathing room between lines
                    ),
                  ),
                  const SizedBox(height: 16),

                  // A subtle divider to separate the header from the body
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 16),

                  // Description / Content
                  Text(
                    maxLines: 10,
                    content ??
                        'No detailed description available for this article.',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,

                      height: 1.6, // Excellent for readability

                      // overflow: TextOverflow.visible,
                      // // Allows the text to expand as needed
                    ),
                  ),

                  // const SizedBox(height: 40),

                  // // Optional: A "Read More" placeholder
                  // Center(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // In the future, you can add the url_launcher package here
                  //       // to open the actual article in a web browser!
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text('Launching browser...')),
                  //       );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.black,
                  //       foregroundColor: Colors.white,
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 40,
                  //         vertical: 15,
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30),
                  //       ),
                  //     ),
                  //     child: const Text('Read Full Article on Web'),
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
