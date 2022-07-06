import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'data.dart';

typedef ProgressChanged<double> = void Function(double value);

class CustomSlider extends StatefulWidget {
  final List<SliderData> sliderData;
  final double padding;
  final ProgressChanged? progressChanged;

  const CustomSlider({
    Key? key,
    required this.sliderData,
    this.padding = 60.0,
    this.progressChanged,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _progress = 0.0;
  int _value = 0;
  String _tenor = '2.25% p.a';
  bool _isShowTips = false;

  final GlobalKey paintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          _isShowTips = true;
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        final getBox = paintKey.currentContext?.findRenderObject() as RenderBox;
        Offset local = getBox.localToGlobal(details.globalPosition);
        final double x = local.dx;
        final double y = local.dy;
        if (x < MediaQuery.of(context).size.width && x >= widget.padding) {
          int index = (_progress /
                  ((_width - widget.padding) / (widget.sliderData.length)))
              .truncate();
          setState(() {
            _progress = x - widget.padding;
            _value = widget.sliderData[index].value!;
            _tenor = widget.sliderData[index].tenor!;
          });
        }
      },
      onPanEnd: (DragEndDetails details) {
        if (widget.progressChanged != null) {
          widget.progressChanged!(_value);
        }
        setState(() {
          _isShowTips = false;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: CustomPaint(
              isComplex: false,
              key: paintKey,
              painter: CustomSliderPainter(progress: _progress, value: _value),
              size: Size(
                  MediaQuery.of(context).size.width - widget.padding, 30.0),
            ),
          ),
          Positioned(
            top: -14.0,
            left: _progress - 14,
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
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
          if (_isShowTips)
            Positioned(
              top: -50.0,
              left: _progress - 44,
              child: Container(
                padding: const EdgeInsets.only(top: 7),
                width: 88,
                height: 40,
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/icon_tips_bg.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Text(
                  _tenor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class CustomSliderPainter extends CustomPainter {
  final double progress;
  final int value;

  CustomSliderPainter({this.progress = 0.0, this.value = 0});

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
