import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_in_out_widget/widget/clip_toggle_buttons.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Zoom On Double Tap';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  Clip clipBehavior = Clip.none;
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  TapDownDetails? tapDownDetails;

  @override
  void initState() {
    super.initState();

    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Zoom On\nDouble Tap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipToggleButtons(
                onChanged: (index) =>
                    setState(() => clipBehavior = Clip.values[index]),
              ),
              const SizedBox(height: 16),
              buildUser(),
              buildImage(),
            ],
          ),
        ),
      );

  Widget buildUser() {
    final urlUser =
        'https://images.unsplash.com/photo-1594745561149-2211ca8c5d98?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80';
    final name = 'Sarah Abs';

    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(urlUser),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            iconSize: 32,
            icon: Icon(Icons.more_horiz, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildImage() => GestureDetector(
        onDoubleTapDown: (details) => tapDownDetails = details,
        onDoubleTap: () {
          final position = tapDownDetails!.localPosition;

          final double scale = 3.0;
          final x = -position.dx * (scale - 1);
          final y = -position.dy * (scale - 1);
          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);

          final end =
              controller.value.isIdentity() ? zoomed : Matrix4.identity();

          animation = Matrix4Tween(
            begin: controller.value,
            end: end,
          ).animate(
            CurveTween(curve: Curves.easeOut).animate(animationController),
          );

          animationController.forward(from: 0);
        },
        child: InteractiveViewer(
          clipBehavior: clipBehavior,
          transformationController: controller,
          panEnabled: false,
          scaleEnabled: false,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              'https://images.unsplash.com/photo-1445583934509-4ad5ffe6ef08?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=870&q=80',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}

/// Simple Zoom Version 
/// Used in the YouTube Video
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Zoom On Double Tap';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();

    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(24),
          child: buildImage(),
        ),
      );

  Widget buildImage() => GestureDetector(
        onTapDown: (details) => tapDownDetails = details,
        onTap: () {
          final position = tapDownDetails!.localPosition;

          final double scale = 3;
          final x = -position.dx * (scale - 1);
          final y = -position.dy * (scale - 1);
          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);

          final end =
              controller.value.isIdentity() ? zoomed : Matrix4.identity();

          animation = Matrix4Tween(
            begin: controller.value,
            end: end,
          ).animate(
            CurveTween(curve: Curves.easeOut).animate(animationController),
          );

          animationController.forward(from: 0);
        },
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          transformationController: controller,
          panEnabled: false,
          scaleEnabled: false,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              'https://images.unsplash.com/photo-1445583934509-4ad5ffe6ef08?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=870&q=80',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
} */