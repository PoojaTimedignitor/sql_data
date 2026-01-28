
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../db/db_helper.dart';

class SqlDbProvider extends ChangeNotifier{

  List<Map<String, dynamic>> dataList = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get ageController => _ageController;

  void setFetchUsers() async {
  // void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await DBHelper.instance.getData();                         /// singleton
    // List<Map<String, dynamic>> userList = await DBHelper.getData();
    //setState(() {
      dataList = userList;
    //});
    notifyListeners();

  }

  void setSaveData() async {
  // void _saveData() async {
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    int insertId = await DBHelper.instance.insertUser(name, age);
    log('$insertId');

    List<Map<String, dynamic>> updateData = await DBHelper.instance.getData();
   // setState(() {
      dataList = updateData;
   //});
    notifyListeners();
  }

  void setDelete(int dataId) async {
  // void _delete(int dataId) async {
    int id = await DBHelper.instance.deleteData(dataId);
    List<Map<String, dynamic>> updateData = await DBHelper.instance.getData();
    //setState(() {
      dataList = updateData;
   // });
    notifyListeners();
    log('Delete :$id');
  }


  /// Edit Data
  void fetchData(int id)async{
  // void fetchData()async{
    Map<String, dynamic>? data =  await DBHelper.instance.getSingleData(id);
    if(data != null){
      _nameController.text = data['name'];
      _ageController.text = data['age'].toString();
    }
  }

  void updateData(BuildContext context, int userId)async{
  // void updateData(BuildContext context)async{
    Map<String, dynamic> data = {
      'name' : _nameController.text,
      'age' : _ageController.text,
    };
    int id = await DBHelper.instance.updateData(userId, data);
    log('Update $id');
    Navigator.pop(context, true);
  }


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

}