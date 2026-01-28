import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sql_db/db/db_helper.dart';

class EditData extends StatefulWidget {
  final int id;

  const EditData({required this.id, super.key});

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData()async{
    Map<String, dynamic>? data =  await DBHelper.instance.getSingleData(widget.id);
    if(data != null){
      _nameController.text = data['name'];
      _ageController.text = data['age'].toString();
    }
  }

  void _updateData(BuildContext context)async{
    Map<String, dynamic> data = {
      'name' : _nameController.text,
      'age' : _ageController.text,
    };
    int id = await DBHelper.instance.updateData(widget.id, data);
    log('Update $id');
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
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
                    _updateData(context);
                    _nameController.clear();
                    _ageController.clear();
                  },
                  child: const Text('Update Data')),
            ],
          ),
        ),

      ),
    );
  }
}
