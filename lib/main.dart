import 'package:flutter/material.dart';

import 'src/shelf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 300,
          child: Shelf(
            openCloseAnimation: Curves.bounceInOut,
            contentWidth: MediaQuery.of(context).size.width / 2,
            shelfItems: [
              ShelfItem(
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'assets/images/test02.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                label: Text('Mujtaba'),
              ),
              ShelfItem(
                color: Colors.blue,
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'assets/images/test02.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                label: Text('Isra'),
              ),
              ShelfItem(
                color: Colors.orange,
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'assets/images/test02.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                label: Text(
                  'Ghazi',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              ShelfItem(
                color: Colors.red,
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'assets/images/test02.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                label: Text('Iqbal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
