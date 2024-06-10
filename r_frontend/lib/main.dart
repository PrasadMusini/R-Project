import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RApp(),
    );
  }
}

class RApp extends StatefulWidget {
  const RApp({super.key});

  @override
  State<RApp> createState() => _RAppState();
}

class _RAppState extends State<RApp> {
  late Future<String?> generatedImage;
  @override
  void initState() {
    super.initState();
    generatedImage = fetchGeneratedGraphImage();
  }

  Future<String?> fetchGeneratedGraphImage() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://localhost:3000/generate-graph'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('jsonResponse: $jsonResponse');
        final generatedGraphImage = jsonResponse['imageUrl'];
        return generatedGraphImage;
      } else {
        throw Exception(
            'Failed to generate graph image: ${response.statusCode}');
      }
    } catch (e) {
      print('catch: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: FutureBuilder(
              future: generatedImage,
              builder: (builder, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator.adaptive();
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  print('snapshot.data: ${snapshot.data}');
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Image.network(
                      snapshot.data ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_P--jTt0SNpr6TvtJmyyenDiwuHBJJCabBJwwIa81JPj379lRrR3_nD989Q&s',
                      fit: BoxFit.cover,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
