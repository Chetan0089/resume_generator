import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ResumePage(),
    );
  }
}

class ResumePage extends StatefulWidget {
  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  Resume? resume;
  double fontSize = 16;
  Color fontColor = Colors.white;
  Color bgColor = Colors.black;

  @override
  void initState() {
    super.initState();
    loadResume(); // Load local JSON data
  }

  void loadResume() {
    // Hardcoded JSON object (simulate local API)
    final json = {
      "name": "insert-your-name-here",
      "phone": "+1-555-1234-567",
      "email": "user@example.com",
      "twitter": "@exampleUser",
      "address": "123 Main St, Anytown, USA",
      "summary":
          "A passionate developer with experience in full-stack development, AI, and cloud computing.",
      "skills": ["MongoDB", "Python", "JavaScript"],
      "projects": [
        {
          "title": "Task Manager App by insert-your-name-here",
          "description": "Developed a productivity app to manage tasks efficiently.",
          "startDate": "2023-01-01",
          "endDate": "2023-06-30"
        },
        {
          "title": "Weather App by insert-your-name-here",
          "description": "Created an app that fetches real-time weather data.",
          "startDate": "2023-01-01",
          "endDate": "2023-06-30"
        }
      ]
    };

    setState(() {
      resume = Resume.fromJson(json);
    });
  }

  Widget buildResumeText() {
    if (resume == null) return Text("Loading resume...");

    return SingleChildScrollView(
      child: Text(
        '''
NAME: ${resume!.name}
ADDRESS: ${resume!.address}
EMAIL: ${resume!.email}
PHONE: ${resume!.phone}
TWITTER: ${resume!.twitter}

SUMMARY
------------------------------
${resume!.summary}

SKILLS
------------------------------
${resume!.skills.map((e) => '• $e').join('\n')}

PROJECTS
------------------------------
${resume!.projects.map((p) => '• ${p.title}\n  ${p.description}\n  (${p.startDate} to ${p.endDate})\n').join('\n')}
''',
        style: TextStyle(fontSize: fontSize, color: fontColor),
      ),
    );
  }

  void pickColor(bool isFontColor) async {
    Color picked = fontColor;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pick ${isFontColor ? 'Font' : 'Background'} Color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: isFontColor ? fontColor : bgColor,
            onColorChanged: (color) {
              picked = color;
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text("Done"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
    setState(() {
      if (isFontColor) {
        fontColor = picked;
      } else {
        bgColor = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: buildResumeText(),
                ),
              ),
              SizedBox(height: 10),
              Text("Font Size: ${fontSize.toInt()}"),
              Slider(
                value: fontSize,
                min: 10,
                max: 30,
                onChanged: (value) {
                  setState(() {
                    fontSize = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => pickColor(true),
                    icon: Icon(Icons.text_fields),
                    label: Text("Font Color"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => pickColor(false),
                    icon: Icon(Icons.format_color_fill),
                    label: Text("Background"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ Models ------------------------

class Resume {
  final String name;
  final String phone;
  final String email;
  final String twitter;
  final String address;
  final String summary;
  final List<String> skills;
  final List<Project> projects;

  Resume({
    required this.name,
    required this.phone,
    required this.email,
    required this.twitter,
    required this.address,
    required this.summary,
    required this.skills,
    required this.projects,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      twitter: json['twitter'],
      address: json['address'],
      summary: json['summary'],
      skills: List<String>.from(json['skills']),
      projects:
          (json['projects'] as List).map((p) => Project.fromJson(p)).toList(),
    );
  }
}

class Project {
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  Project({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
