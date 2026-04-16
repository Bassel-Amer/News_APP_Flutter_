import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/features/homescreen/ui/screens/detailscreen.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? description;
  final String? url;

  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.description,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 1. The Navigation Logic
        Navigator.pushNamed(
          context,
          "/details",
          arguments: DataArticle(
            title: title,
            imageUrl: imageUrl,
            description: description,
            url: url,
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        // shadowColor: Colors.red,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.sp)),

              child: Hero(
                tag: imageUrl,
                child:
                    imageUrl.isNotEmpty
                        ? Image.network(
                          height: 200.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) =>
                                  wasSynchronouslyLoaded
                                      ? child
                                      : AnimatedOpacity(
                                        opacity: frame == null ? 0 : 1,
                                        duration: const Duration(seconds: 1),
                                        child: child,
                                      ),

                          // loadingBuilder:
                          //     (context, child, loadingProgress) =>
                          //         Center(child: CircularProgressIndicator()),
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 200.h,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                        )
                        : Container(
                          height: 200.h,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey[700],
                          ),
                        ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12.0.r),
              child: Column(
                children: [
                  Text(
                    // softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    description ?? 'No Description Available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
