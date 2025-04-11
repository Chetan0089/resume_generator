class Resume {
  final String name;
  final List<String> skills;
  final List<String> projects;

  Resume({required this.name, required this.skills, required this.projects});

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      name: json['name'],
      skills: List<String>.from(json['skills']),
      projects: List<String>.from(json['projects']),
    );
  }
}
