import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  final String textString;
  final Color color;
  const CustomCard({super.key, required this.textString, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
        child: Padding(
          padding: EdgeInsets.only(top: 3.h, left: 7.w, right: 7.w),
          child: Text(
            textString,
            style: TextStyle(
                letterSpacing: .5,
                wordSpacing: 4,
                fontSize: 17.sp,
                color: color),
          ),
        ));
  }
}
