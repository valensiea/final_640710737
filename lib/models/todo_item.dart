// import 'package:flutter/material.dart';

class TodoItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  // final bool completed;

  TodoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    // required this.completed,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'https://cpsu-api-49b593d4e146.herokuapp.com';
    const String endpoint = '/api/2_2566/final/';
    String imagePath = baseUrl + endpoint + json['image'];
    // debugPrint(imagePath);

    return TodoItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: imagePath,
      // completed: json['completed'],
    );
  }
}

class PostData {
  final String url;
  final String description;
  final String type;

  PostData({
    required this.url,
    required this.description,
    required this.type,
  });

  // Convert data to JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'description': description,
      'type': type,
    };
  }
}
