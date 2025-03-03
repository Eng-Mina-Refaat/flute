// import 'package:flute2/presentation/pages/audio_screen.dart';
// import 'package:flute2/presentation/pages/exercise_page.dart';
import 'package:flute2/presentation/pages/flute_pages/flute_page.dart';
import 'package:flute2/presentation/pages/skills_pages/skills_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List fluteList = [
    {'name': 'الة الناي', 'icon': Icons.tune, 'page': FlutePage()},
    {'name': 'المهارات', 'icon': Icons.school, 'page': SkillsPage()},
    // {
    //   'name': ' تدريبات ',
    //   'icon': Icons.assignment_outlined,
    //   'page': ExercisePage()
    // },
    // {
    //   'name': 'غرفة الاستماع',
    //   'icon': Icons.campaign_outlined,
    //   'page': RecordScreen()
    // }
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
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
                  height: screenHeight * .08,
                ),
                FittedBox(
                  child: Text(
                    'Flute',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                FittedBox(
                  child: Text(
                    'لتعليم العزف علي آلة الناي',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: screenHeight * .06,
                ),
                SizedBox(
                  height: screenHeight * .3,
                  width: screenWidth * .97,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: fluteList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: screenHeight * .25,
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth * .06),
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
                                size: 35,
                              ),
                              Text(fluteList[index]['name'],
                                  style: TextStyle(
                                    fontSize: 24,
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
