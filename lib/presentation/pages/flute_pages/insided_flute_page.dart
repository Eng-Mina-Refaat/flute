import 'package:flute2/presentation/reusable_widget/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_flutter/hive_flutter.dart';

class InsidedFlutePage extends StatelessWidget {
  final String title;
  final String description;
  const InsidedFlutePage(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[600],
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/flute2.jpg'))),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 50.w,
                  children: [
                    IconButton(
                        padding: EdgeInsets.only(right: 8.w),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 23.r,
                        )),
                    // SizedBox(
                    //   width: screenWidth * .10,
                    // ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 22.sp, wordSpacing: 3, color: Colors.white),
                    ),
                  ],
                ),
                Opacity(
                  opacity: .8,
                  child: CustomCard(
                    color: Colors.black,
                    textString: description,
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
