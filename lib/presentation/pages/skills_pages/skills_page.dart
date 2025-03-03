import 'package:flute2/presentation/pages/skills_pages/insided_skill_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/flute5.jpg'))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: screenWidth * .2,
                children: [
                  IconButton(
                      padding: EdgeInsets.only(right: 10),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 25,
                      )),
                  Text(
                    'تعلم مهارات الناي',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
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
                    height: screenHeight * .12,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InsidedSkillPage())),
                      child: Card(
                        margin: EdgeInsets.only(
                            top: 15, left: 25, right: 25, bottom: 15),
                        child: Center(
                          child: Text(
                            skillsPages[index]['العنوان'],
                            style: TextStyle(
                              fontSize: 24,
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

// class NoteHole extends StatelessWidget {
//   const NoteHole({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("تم الضغط على ثقب الناي!")),
//         );
//       },
//       child: Container(
//         width: 25,
//         height: 25,
//         decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
//       ),
//     );
//   }
// }
