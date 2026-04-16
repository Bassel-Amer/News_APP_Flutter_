import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DataArticle {
  final String title;
  final String? description;
  final String imageUrl;
  final String? url;

  DataArticle({
    required this.title,
    this.description,
    required this.imageUrl,
    this.url,
  });
}

class ArticleDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? description;
  final String? url;

  const ArticleDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    this.description,
    this.url,
  });

  Future<void> _openBrowser(String? urlString) async {
    if (urlString == null) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: width < 800 ? 300.h : 0.7 * width,
            pinned: true,
            stretch: true,

            // iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background:
                  imageUrl.isNotEmpty
                      ? Hero(
                        tag: imageUrl,

                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 200.h,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                        ),
                      )
                      : Container(
                        // color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 50.sp),
                      ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Divider(color: Colors.red, thickness: 2),
                  SizedBox(height: 12.h),

                  Text(
                    description ??
                        'No detailed description available for this article.',
                    style: TextStyle(
                      fontSize: 18.sp,

                      // color: Colors.black87,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Launching browser...')),
                        );
                        await _openBrowser(url);
                      },
                      style: ElevatedButton.styleFrom(),
                      child: const Text(
                        'Read Full Article on Web',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
