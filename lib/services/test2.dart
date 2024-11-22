import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchFilterExample(),
      debugShowCheckedModeBanner: false,

    );
  }
}

class SearchFilterExample extends StatefulWidget {
  const SearchFilterExample({super.key});

  @override
  _SearchFilterExampleState createState() => _SearchFilterExampleState();
}

class _SearchFilterExampleState extends State<SearchFilterExample> {
  List<String> dataList = ['Item 1', 'Item 2', 'Item 3', 'Flutter', 'Filter'];
  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = dataList; // Default tampilkan semua data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filter Pencarian Flutter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Cari',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  filteredList = dataList
                      .where((item) =>
                          item.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
