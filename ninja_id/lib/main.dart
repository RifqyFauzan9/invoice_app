import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: NinjaCard(),
    ),
  );
}

class NinjaCard extends StatefulWidget {
  const NinjaCard({super.key});

  @override
  State<NinjaCard> createState() => _NinjaCardState();
}

class _NinjaCardState extends State<NinjaCard> {
  int _ninjaLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => greetUser());
  }

  void greetUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hello!'),
        content: const Text(
          textAlign: TextAlign.start,
          'To upgrade your ninja level, press the button on the right-bottom of your screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addNumber() {
    setState(() {
      _ninjaLevel++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Ninja ID Card',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[850],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNumber(),
        backgroundColor: Colors.grey[800],
        child: const Icon(Icons.add, color: Colors.grey),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/desktop-profile-picture.jpg',
                ),
                radius: 80,
              ),
            ),
            Divider(height: 90, color: Colors.grey[800]),
            Text(
              'name'.toUpperCase(),
              style: TextStyle(color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              'Rifqy Fauzan',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'current ninja level'.toUpperCase(),
              style: TextStyle(color: Colors.grey, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              _ninjaLevel.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 2,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: <Widget>[
                Icon(Icons.email, color: Colors.grey[400]),
                const SizedBox(width: 10),
                Text(
                  'rifqyfauzann1@gmail.com',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
