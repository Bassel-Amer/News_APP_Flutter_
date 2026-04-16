import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget buildNewsShimmer(bool light) {
  return Shimmer.fromColors(
    baseColor: light ? Colors.grey[300]! : Colors.grey[700]!,

    highlightColor: light ? Colors.grey[100]! : Colors.grey[500]!,

    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.w),
      // shadowColor: Colors.red,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),

            child: Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12.0.r),
            child: Column(
              children: [SizedBox(height: 8.h), SizedBox(height: 8.h)],
            ),
          ),
        ],
      ),
    ),
  );
}
