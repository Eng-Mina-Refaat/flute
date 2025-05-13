import 'package:flute2/presentation/pages/skills_pages/insided_skill_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkillsPage extends StatelessWidget {
  final List skillsPages = [
    {
      'العنوان': 'النغمات الممتدة',
      'الصفحه': InsidedSkillPage(),
    },
    {
      'العنوان': 'التحكم في شده الهواء',
      'الصفحه': InsidedSkillPage(),
    },
    {
      'العنوان': 'القفزات اللحنية',
      'الصفحه': InsidedSkillPage(),
    },
    {
      'العنوان': 'نغمات القرار',
      'الصفحع': InsidedSkillPage(),
    }
  ];
  SkillsPage({super.key});

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
                  image: AssetImage('assets/images/flute5.jpg'))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 80.w,
                children: [
                  IconButton(
                      padding: EdgeInsets.only(right: 8.w),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 23.r,
                      )),
                  Text(
                    'تعلم مهارات الناي',
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: skillsPages.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 90.h,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InsidedSkillPage())),
                      child: Card(
                        margin: EdgeInsets.only(
                            top: 13.h, left: 23.w, right: 23.w, bottom: 13.h),
                        child: Center(
                          child: Text(
                            skillsPages[index]['العنوان'],
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
