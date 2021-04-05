import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const String routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('Feed'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => Scaffold( appBar: AppBar(title: Text('Hello!')),))
          ),
        ),
      ),
    );
  }
}
