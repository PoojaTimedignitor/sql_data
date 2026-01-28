import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_db/db/db_helper.dart';
import '../provider/spl_provider.dart';

class EditData extends StatefulWidget {
  final int id;

  const EditData({required this.id, super.key});

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
   // fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<SqlDbProvider>(context, listen: false).fetchData(widget.id);
    });
    super.initState();
  }

  // void fetchData()async{
  //   Map<String, dynamic>? data =  await DBHelper.instance.getSingleData(widget.id);
  //   if(data != null){
  //     _nameController.text = data['name'];
  //     _ageController.text = data['age'].toString();
  //   }
  // }
  //
  // void _updateData(BuildContext context)async{
  //   Map<String, dynamic> data = {
  //     'name' : _nameController.text,
  //     'age' : _ageController.text,
  //   };
  //   int id = await DBHelper.instance.updateData(widget.id, data);
  //   log('Update $id');
  //   Navigator.pop(context, true);
  // }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _ageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Consumer<SqlDbProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: provider.nameController,
                    decoration: InputDecoration(
                        hintText: 'Enter name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: provider.ageController,
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
                        //_updateData(context);
                        provider.updateData(context, widget.id);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Data Update Successfully'),
                          backgroundColor: Colors.green,
                        ));
                        provider.nameController.clear();
                        provider.ageController.clear();
                      },
                      child: const Text('Update Data')),
                ],
              ),
            );
          },
        ),

      ),
    );
  }
}
