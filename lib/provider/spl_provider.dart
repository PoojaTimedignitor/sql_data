
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../db/db_helper.dart';

class SqlDbProvider extends ChangeNotifier{

  List<Map<String, dynamic>> dataList = [];

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get ageController => _ageController;

  void fetchUsers() async {
  // void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await DBHelper.instance.getData();                         /// singleton
    // List<Map<String, dynamic>> userList = await DBHelper.getData();
    //setState(() {
      dataList = userList;
    //});
    notifyListeners();

  }

  void saveData() async {
  // void _saveData() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final age = int.tryParse(_ageController.text) ?? 0;
    int insertId = await DBHelper.instance.insertUser(firstName, lastName, age);
    log('$insertId');

    List<Map<String, dynamic>> updateData = await DBHelper.instance.getData();
   // setState(() {
      dataList = updateData;
   //});
    notifyListeners();
  }

  void deleteData(int dataId) async {
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
      _firstNameController.text = data['firstName'];
      _lastNameController.text = data['lastName'];
      _ageController.text = data['age'].toString();
    }
  }

  void updateData(BuildContext context, int userId)async{
  // void updateData(BuildContext context)async{
    Map<String, dynamic> data = {
      'firstName' : _firstNameController.text,
      'lastName' : _lastNameController.text,
      'age' : _ageController.text,
    };
    int id = await DBHelper.instance.updateData(userId, data);
    log('Update $id');
    Navigator.pop(context, true);
  }


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

}