import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_sliders/data.dart';

import 'custom_slider.dart';

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
  final List<SliderData> _values = [
    SliderData(value: 1, tenor: '2.25% p.a'),
    SliderData(value: 3, tenor: '3.00% p.a'),
    SliderData(value: 6, tenor: '4.00% p.a'),
    SliderData(value: 9, tenor: '5.00% p.a'),
    SliderData(value: 18, tenor: '5.50% p.a'),
    SliderData(value: 24, tenor: '5.75% p.a'),
    SliderData(value: 36, tenor: '6.00% p.a'),
  ];

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
            CustomSlider(
              sliderData: _values,
              progressChanged: (val) {
                print(val);
              },
            ),
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
