import 'dart:io';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Awesome Dio Interceptor'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final dio = Dio(
              BaseOptions(
                headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                  HttpHeaders.acceptHeader: "application/json"
                },
              ),
            );

            dio.interceptors.add(
              AwesomeDioInterceptor(
                logRequestHeaders: false,
                logRequestTimeout: false,
                logResponseHeaders: false,
              ),
            );

            await dio.get(
              'https://jsonplaceholder.typicode.com/posts/1',
            );
          },
          child: const Text('Send Request'),
        ),
      ),
    );
  }
}
