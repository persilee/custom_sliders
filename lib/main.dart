import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  double _sliderValue = 0.0;
  double _progress = 0.0;
  final List<int> _values = [1, 3, 6, 9, 18, 24, 36];
  int _value = 0;

  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_sliderValue',
              style: Theme.of(context).textTheme.headline4,
            ),
            Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                }),
            const Padding(padding: EdgeInsets.only(top: 60.0)),
            GestureDetector(
              onPanStart: (DragStartDetails details) {
                final getBox =
                    paintKey.currentContext?.findRenderObject() as RenderBox;
                Offset local = getBox.localToGlobal(details.globalPosition);
              },
              onPanUpdate: (DragUpdateDetails details) {
                final getBox =
                    paintKey.currentContext?.findRenderObject() as RenderBox;
                Offset local = getBox.localToGlobal(details.globalPosition);
                final double x = local.dx;
                final double y = local.dy;
                print('local: $x');
                print('_progress: $_progress');
                if (x < MediaQuery.of(context).size.width && x >= 60) {
                  print('aaaa: ${(_progress / (300.0 / 7)).truncate()}');
                  int index = (_progress / (300.0 / 7)).truncate();
                  setState(() {
                    _progress = x - 60;
                    _value = _values[index];
                  });
                }
                // controller.value = x - 60;
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    child: CustomPaint(
                      isComplex: false,
                      key: paintKey,
                      painter: CustomSlider(progress: _progress, value: _value),
                      size: Size(MediaQuery.of(context).size.width - 60, 30.0),
                    ),
                  ),
                  Positioned(
                    top: -6.0,
                    left: _progress - 7,
                    child: Center(
                      child: Text(
                        _value.toString(),
                        style: const TextStyle(
                          color: Color(0xff035F9E),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -54.0,
                    left: _progress - 7 - 38,
                    child: Center(
                      child: Image.asset(
                        'images/icon_tips_bg.png',
                        height: 46.0,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomSlider extends CustomPainter {
  final double progress;
  final int value;

  CustomSlider({this.progress = 0.0, this.value = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final double _width = size.width;
    final double _height = size.height;
    double _progress = progress;

    // 绘制线性渐变色
    var gradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(_width, 0),
      [
        const Color(0xFF01D5E7),
        const Color(0xFF009EAB),
      ],
    );

    var gradientDot = ui.Gradient.radial(
      Offset(progress, -6.5),
      26,
      [
        const Color(0xFF0BD5E5),
        const Color(0xFF009EAB),
      ],
    );

    Paint paint = Paint()
      ..color = const Color(0xffDAE6EC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    Paint paintShadow = Paint()
      ..color = const Color(0xff000000).withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 1.0);

    Paint paintProgress = Paint()
      ..shader = gradient
      ..color = const Color(0xFF01D5E7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11.0
      ..strokeCap = StrokeCap.round;

    Paint paintDot = Paint()..color = const Color(0xffE6EEF2);
    Paint paintDot2 = Paint()
      ..color = const Color(0xffE6EEF2)
      ..shader = gradientDot;

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value.toString(),
        style: const TextStyle(
          color: Color(0xff035F9E),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    )..layout();

    canvas.drawLine(const Offset(0, 0), Offset(_width, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(_width, 0), paintShadow);

    if (progress < 0) {
      _progress = 0;
    }
    canvas.drawLine(const Offset(0, 0), Offset(_progress, 0), paintProgress);
    canvas.drawCircle(Offset(_progress, 0), 14, paintDot2);
    canvas.drawCircle(Offset(_progress, 0), 11, paintDot);
    // textPainter.paint(canvas, Offset(_progress - 4, -6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
