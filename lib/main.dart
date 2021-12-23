import 'package:flutter/material.dart';
import 'package:pars_sdk_kullanimi/parse_provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ParseProvider.initParse();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ParseProvider.initParse().then((value) {
      startLiveQuery();
      getTodos().then((value) {
        setState(() {});
      });
    });
  }

  void startLiveQuery() async {
    print("Start Live Quergy");
    final LiveQuery liveQuery = LiveQuery();
    QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Stream'));
    Subscription subscription = await liveQuery.client.subscribe(query);
    subscription.on(LiveQueryEvent.create, (value) {
      print('*** CREATE ***: ${DateTime.now().toString()}\n $value ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo With Pars"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "New Todo",
                    ),
                    controller: textEditingController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveTodo(textEditingController.text);
                    textEditingController.clear();
                  },
                  child: const Text("Add"),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getTodos(),
              builder: (context, AsyncSnapshot snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data != null ? snapshot.data.length : 0,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(snapshot.data[index]['title']),
                      value: snapshot.data[index]['done'],
                      secondary: IconButton(
                          onPressed: () {
                            deleteTodo(snapshot.data[index]['objectId']);
                          },
                          icon: const Icon(Icons.delete)),
                      onChanged: (bool? newValue) {
                        setState(() {
                          updateTodo(snapshot.data[index]['objectId'], newValue!);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveTodo(String title) async {
    var stream = ParseObject('Stream')
      ..set('title', title)
      ..set('done', false);
    await stream.save();
    var todoApp = ParseObject('TodoApp')
      ..set('title', title)
      ..set('done', false);
    await todoApp.save().then((value) {
      setState(() {});
    });
  }

  Future<List<ParseObject>> getTodos() async {
    QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('TodoApp'));
    final ParseResponse response = await query.query();
    if (response.success && response.results!.isNotEmpty) {
      return response.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    var todoApp = ParseObject('TodoApp')
      ..set('objectId', id)
      ..set('done', done);
    await todoApp.save().then((value) {
      setState(() {});
    });
  }

  Future<void> deleteTodo(String id) async {
    var todoApp = ParseObject('TodoApp')..set('objectId', id);
    await todoApp.delete().then((value) {
      setState(() {});
    });
  }
}

/*

Expanded(
            child: FutureBuilder<List<ParseObject>>(
              future: getTodos(),
              builder: (context, AsyncSnapshot snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data != null ? snapshot.data.length : 0,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(snapshot.data[index]['title']),
                      value: snapshot.data[index]['done'],
                      secondary: IconButton(
                          onPressed: () {
                            deleteTodo(snapshot.data[index]['objectId']);
                          },
                          icon: const Icon(Icons.delete)),
                      onChanged: (bool? newValue) {
                        setState(() {
                          updateTodo(snapshot.data[index]['objectId'], newValue!);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),


 */