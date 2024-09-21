import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madhav Agrawal - Portfolio',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey[300]),
          displayLarge: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.grey[700]),
      ),
      home: PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Main Landing Section
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(
                          'assets/profile.jpg'), // Add your profile image
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Madhav Agrawal',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Flutter Developer | UI/UX Enthusiast',
                      style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey[700],
                      ),
                      onPressed: () {
                        _scrollController.animateTo(
                          MediaQuery.of(context).size.height,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text('Scroll to Know More'),
                    ),
                  ],
                ),
              ),
            ),
            // Skills Section
            SkillsSection(scrollController: _scrollController),
            // Projects Section with Animations
            ProjectsSection(),
            // Education Section
            EducationSection(),
            // Contact Section
            ContactSection(),
          ],
        ),
      ),
    );
  }
}

class SkillsSection extends StatefulWidget {
  final ScrollController scrollController;

  SkillsSection({required this.scrollController});

  @override
  _SkillsSectionState createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final List<Map<String, dynamic>> skills = [
    {'name': 'Flutter', 'level': 80}, // Flutter 80%
    {'name': 'Dart', 'level': 70}, // Dart 70%
    {'name': 'BLoC', 'level': 60}, // BLoC 60%
    {'name': 'MVVM', 'level': 65}, // MVVM 65%
    {'name': 'UI/UX Design', 'level': 60}, // UI/UX Design 60%
    {'name': 'Firebase', 'level': 90}, // Firebase 90%
  ];

  bool _isVisible = false;
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >= 400 && !_isVisible) {
      setState(() {
        _isVisible = true;
        _isAnimated = true; // Start the animation
      });
    } else if (widget.scrollController.position.pixels < 400 && _isVisible) {
      setState(() {
        _isVisible = false; // Reset visibility
        _isAnimated = false; // Reset animation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Skills',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          Column(
            children: skills
                .map((skill) => SkillBar(skill: skill, isVisible: _isAnimated))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class SkillBar extends StatefulWidget {
  final Map<String, dynamic> skill;
  final bool isVisible;

  SkillBar({required this.skill, required this.isVisible});

  @override
  _SkillBarState createState() => _SkillBarState();
}

class _SkillBarState extends State<SkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.skill['level'] / 100)
        .animate(_controller);

    if (widget.isVisible) {
      _controller.forward(); // Start the animation if the section is visible
    }
  }

  @override
  void didUpdateWidget(SkillBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward(); // Start the animation if it becomes visible
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.skill['name'],
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[700],
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _animation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  final List<Map<String, String>> projects = [
    {
      'title': 'Xylophone App',
      'description': 'An interactive app that plays different musical notes.',
      'link': 'https://github.com/MadhavAgrawal65/Xylophone',
    },
    {
      'title': 'Destini Game',
      'description': 'A fun game giving users different gameplay choices.',
      'link': 'https://github.com/MadhavAgrawal65/DestiniGame',
    },
    {
      'title': 'Collaborative To-Do List App',
      'description': 'A task management app with notifications and reminders.',
      'link': 'https://github.com/MadhavAgrawal65/ToDoList_Collaborative',
    },
    {
      'title': 'Post Share App',
      'description':
          'An app to share text, images, and videos using deep links.',
      'link': 'https://github.com/MadhavAgrawal65/postshareapp',
    },
    {
      'title': 'Bloc Based TDL App',
      'description': 'A simple TDL app created with use of Bloc Management',
      'link': 'https://github.com/MadhavAgrawal65/tdl_bloc',
    },
    {
      'title': 'Dice Roll App',
      'description': 'A simple app with on demand dice roll.',
      'link': 'https://github.com/MadhavAgrawal65/Dice',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Projects',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          Column(
            children: projects
                .map((project) => HoverAnimatedProjectCard(project))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class HoverAnimatedProjectCard extends StatefulWidget {
  final Map<String, String> project;

  HoverAnimatedProjectCard(this.project);

  @override
  _HoverAnimatedProjectCardState createState() =>
      _HoverAnimatedProjectCardState();
}

class _HoverAnimatedProjectCardState extends State<HoverAnimatedProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(_isHovered ? 20 : 15),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.grey[800] : Colors.grey[850],
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                      color: Colors.grey[700]!,
                      blurRadius: 10,
                      offset: Offset(0, 5))
                ]
              : [],
        ),
        child: ListTile(
          title: Text(widget.project['title']!,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          subtitle: _isHovered
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.project['description']!,
                        style: TextStyle(color: Colors.grey[300])),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _launchURL(widget.project['link']!),
                      child: Row(
                        children: [
                          Icon(Icons.link, color: Colors.white),
                          SizedBox(width: 5),
                          Text('GitHub Repo',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class EducationSection extends StatelessWidget {
  final List<Map<String, String>> education = [
    {
      'degree': "Bachelor's in Computer Science",
      'institution': 'VIT BHOPAL University',
      'year': '2021-2025',
      'specialization': 'Gaming Technology',
      'CGPA': '8.27',
      'image': 'assets/VITlogo.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          Column(
            children:
                education.map((edu) => EducationCard(education: edu)).toList(),
          ),
        ],
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final Map<String, String> education;

  EducationCard({required this.education});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // University Image
            if (education['image'] != null)
              Image.asset(
                education['image']!,
                height: 150,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 10),
            Text(
              education['degree']!,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(education['institution']!,
                style: TextStyle(fontSize: 16, color: Colors.white)),
            Text(education['year']!,
                style: TextStyle(fontSize: 16, color: Colors.grey[500])),
            SizedBox(height: 5),
            Text('Specialization: ${education['specialization']!}',
                style: TextStyle(color: Colors.grey[300])),
            Text('CGPA: ${education['CGPA']!}',
                style: TextStyle(color: Colors.grey[300])),
          ],
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[900],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Madhav Agrawal',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'madhav.work65@gmail.com',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          '+91-8989028057',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
// Right Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white, // Adjust icon color if needed
                          size: 50, // Adjust icon size if needed
                        ),
                        SizedBox(
                            height:
                                8), // Add spacing between the icon and the button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue[700], // Button color
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          onPressed: () => _launchURL(
                              'https://drive.google.com/file/d/1yoYTGdc3tw3s65xLGtniAjvVtQiNzHOD/view?usp=share_link'),
                          child: Text('Download Resume'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Social Media Icons Row
          _buildSocialIcons(),
        ],
      ),
    );
  }

  // Social Media Icons Row
  Widget _buildSocialIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.github),
          iconSize: 30,
          onPressed: () => _launchURL('https://github.com/MadhavAgrawal65'),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.linkedin),
          iconSize: 30,
          onPressed: () =>
              _launchURL('https://www.linkedin.com/in/madhavagrawal65/'),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.instagram),
          iconSize: 30,
          onPressed: () => _launchURL(
              'https://www.instagram.com/madhav._.agrawal?igsh=MTZqZ2ZoNnBobW5zcw%3D%3D&utm_source=qr'),
        ),
      ],
    );
  }

  // URL launcher function
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
