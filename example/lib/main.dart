import 'dart:async';

import 'package:example/gh_i18n_helper.dart';
import 'package:flutter/material.dart';
import 'package:gh_i18n/language_type.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GhTranslatorHelper().initLanguage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isKr = true;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              tl.home?.text ?? '',
            ),
            Text(
              tl.home?.count?.params({'n': '$_counter'}) ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('en'),
                Switch(value: isKr, onChanged: (value){
                  isKr = value;
                  if(isKr){
                    GhTranslatorHelper.setLanguageType(LanguageType.ko);
                  } else{
                    GhTranslatorHelper.setLanguageType(LanguageType.en);
                  }
                  setState(() {});
                }),
                const Text('kr'),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
