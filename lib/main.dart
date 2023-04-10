import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _capitulos = [];

  Future<List> readJson() async {
    final String response = await rootBundle.loadString('lib/biblia_data.json');
    final jsonDecoded = await json.decode(response);

    _capitulos = jsonDecoded['book'];
    await Future.delayed(const Duration(seconds: 2));
    return _capitulos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bíblia')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<List>(
            future: readJson(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                //String livro = snapshot.data![0]['nome'];
                var capitulos = snapshot.data![0]['capitulos'];
                return Expanded(
                  child: ListView.builder(
                    itemCount: capitulos.length as int,
                    shrinkWrap: true,
                    itemBuilder: (context, indexA) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text('Capitulo ${indexA + 1}'),
                            const SizedBox(height: 24.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: capitulos[indexA].length,
                              itemBuilder: (context, indexB) => Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text((indexB + 1).toString()),
                                      const SizedBox(width: 12.0),
                                      Expanded(child: Text(capitulos[indexA][indexB])),
                                    ],
                                  ),
                                  const SizedBox(height: 12.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
