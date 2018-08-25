// Step 5: Add a lazily loading infinite scrolling ListView.
// Also, add a heart icon so users can favorite word pairings.
// Save the word pairings in the State class.
// Make the hearts tappable and save the favorites list in the
// State class.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWords(),
      theme: new ThemeData(primaryColor: Colors.white),
    );
  }
}

///无状态的组件
class TextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text("text widget")),
      body: new Center(
        child: new Text(
          "Hello World",
          style: new TextStyle(fontSize: 18.0, color: Colors.red),
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: _buildBottom(),
      ),
    );
  }

  _buildBottom() {
    final _item = new List<BottomNavigationBarItem>();
    final _textStyle = new TextStyle(color: Colors.black);
    _item.add(new BottomNavigationBarItem(
        icon: new Icon(
          Icons.favorite,
          color: Colors.grey,
        ),
        title: new Text(
          "all",
          style: _textStyle,
        )));
    _item.add(new BottomNavigationBarItem(
        icon: new Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        title: new Text(
          "collect",
          style: _textStyle,
        )));
    return _item;
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Demo App'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
          ],
        ),
        bottomNavigationBar: new BottomNavigationBar(
            items: _buildBottom(),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            }),
        body: new IndexedStack(
          children: <Widget>[_buildSuggestions(), new CollectApp()],
          index: _currentIndex,
        ));
  }

  _buildBottom() {
    final _item = new List<BottomNavigationBarItem>();
    final _textStyle = new TextStyle(color: Colors.black);
    _item.add(new BottomNavigationBarItem(
        icon: new Icon(
          Icons.favorite,
          color: Colors.grey,
        ),
        title: new Text(
          "all",
          style: _textStyle,
        )));
    _item.add(new BottomNavigationBarItem(
        icon: new Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        title: new Text(
          "collect",
          style: _textStyle,
        )));
    return _item;
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(
          () {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          },
        );
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
            title: new Text(pair.asPascalCase, style: _biggerFont));
      });
      final divideTiles =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return new Scaffold(
          appBar: new AppBar(title: new Text('CollectList')),
          body: new ListView(children: divideTiles));
    }));
  }
}

class CollectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var take = generateWordPairs().take(10);
    final tiles = take.map((pair) {
      return new ListTile(
          title: new Text(pair.asPascalCase,
              style: new TextStyle(fontSize: 18.0)));
    });
    final divideTiles =
        ListTile.divideTiles(context: context, tiles: tiles).toList();
    return new ListView(children: divideTiles);
  }
}
