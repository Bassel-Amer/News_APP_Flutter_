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

          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true, 
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ), 
            flexibleSpace: FlexibleSpaceBar(
              background:
                  imageUrl.isNotEmpty
                      ? Hero(
                  
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
                      height: 1.3, 
                    ),
                  ),
                  const SizedBox(height: 16),

                 
                  Divider(color: Colors.red, thickness: 2),
                  const SizedBox(height: 16),

            
                  Text(
                    content ??
                        'No detailed description available for this article.',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,

                      height: 1.6, 

                    ),
                  ),

                  const SizedBox(height: 40),

                 
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // In the future, we will add the url_launcher package here
                        // to open the actual article in a web browser
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Launching browser...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Read Full Article on Web',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
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
