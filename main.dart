import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// Fungsi main untuk menjalankan aplikasi
void main() => runApp(MyApp());
// URL untuk mengambil data post dari API
String url = "https://jsonplaceholder.typicode.com/posts";
String url2 = "https://calm-plum-jaguar-tutu.cyclic.app/todos";

// Fungsi untuk mengambil satu post dari API
Future<List<ToDo>> fetchPost() async {
  final response = await http.get(Uri.parse(url2));
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> data = jsonResponse['data'];

    List<ToDo> todos = data.map((dynamic item) => ToDo.fromJson(item)).toList();
    return todos;
  } else {
    throw Exception('Gagal memuat post');
  }
}

// Kelas Post yang mewakili satu post
class ToDo {
  final String id;
  final String todosName;
  final bool isComplete;

  // Konstruktor untuk membuat objek Post
  ToDo({
    required this.id,
    required this.todosName,
    required this.isComplete,
  });

  // Metode pabrik untuk mengonversi data JSON menjadi objek Post
  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['_id'] ?? '',
      todosName: json['todoName'] ?? '',
      isComplete: json['isComplete'] ?? false,
    );
  }
}

// Kelas MyApp yang mewakili akar dari aplikasi
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo From API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// Kelas MyHomePage yang mewakili konten utama dari aplikasi
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Mengambil satu post saat widget dibuat
  final Future<List<ToDo>> posts = fetchPost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDos From API'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<ToDo>>(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: ListTile(
                          title: Text(
                            "todoname : ${snapshot.data![index].todosName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          subtitle: Text(
                              "isComplete : ${snapshot.data![index].isComplete}"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(todo: snapshot.data![index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final ToDo todo;

  DetailScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.todosName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Id: ${todo.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Todo Name: ${todo.todosName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('isComplete: ${todo.isComplete}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
