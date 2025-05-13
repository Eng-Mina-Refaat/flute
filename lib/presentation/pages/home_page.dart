// import 'package:flute2/presentation/pages/audio_screen.dart';
// import 'package:flute2/presentation/pages/exercise_page.dart';
import 'package:flute2/presentation/pages/flute_pages/flute_page.dart';
import 'package:flute2/presentation/pages/skills_pages/skills_page.dart';
import 'package:flute2/presentation/pages/tuner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List fluteList = [
    {'name': 'الة الناي', 'icon': Icons.tune, 'page': FlutePage()},
    {'name': 'المهارات', 'icon': Icons.school, 'page': SkillsPage()},
    {'name': 'Tuner', 'icon': Icons.music_note, 'page': TunerScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/flute20.png'))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 60.h,
                ),
                FittedBox(
                  child: Text(
                    'Flute',
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                FittedBox(
                  child: Text(
                    'لتعليم العزف علي آلة الناي',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                SizedBox(
                  height: 400.h,
                  width: 350.w,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: fluteList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 200.h,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      fluteList[index]['page']));
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                fluteList[index]['icon'],
                                size: 33.r,
                              ),
                              Text(fluteList[index]['name'],
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
