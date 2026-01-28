import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sql_db/db/db_helper.dart';
import 'edit_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> dataList = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await DBHelper.instance.getData();
    // List<Map<String, dynamic>> userList = await DBHelper.getData();
    setState(() {
      dataList = userList;
    });
  }

  void _saveData() async {
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    int insertId = await DBHelper.instance.insertUser(name, age);
    log('$insertId');

    List<Map<String, dynamic>> updateData = await DBHelper.instance.getData();
    setState(() {
      dataList = updateData;
    });
  }

  void _delete(int dataId) async {
    int id = await DBHelper.instance.deleteData(dataId);
    List<Map<String, dynamic>> updateData = await DBHelper.instance.getData();
    setState(() {
      dataList = updateData;
    });

    log('Delete :$id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: 'Enter name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Enter age',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.black),
                    onPressed: () {
                      setState(() {
                        _saveData();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Data Add Successfully'),
                          backgroundColor: Colors.green,
                        ));
                      });
                      _nameController.clear();
                      _ageController.clear();
                    },
                    child: const Text('Save Data')),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(dataList[index]['name']),
                      subtitle: Text(dataList[index]['age'].toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditData(id: dataList[index]['id']),
                                  ),
                                );

                                if (result == true) {
                                  _fetchUsers();
                                }
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _delete(dataList[index]['id']);
                                });
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
