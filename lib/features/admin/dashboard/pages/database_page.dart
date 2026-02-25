import 'package:flutter/material.dart';
import 'package:livest/features/admin/dashboard/models/database_model.dart';
import 'package:livest/features/admin/dashboard/services/database_service.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  final databaseService = DatabaseService();
  List<DatabaseModel> database = [];

  Future<void> _fetchdata() async {
    final data = await databaseService.fetchData();
    setState(() {
      database = data;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchdata();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: database.isNotEmpty
          ? ListView.builder(
              itemCount: database.length,
              itemBuilder: (context, index) {
                final currentDatabase = database[index];
                return ListTile(title: Text(currentDatabase.title));
              },
            )
          : Center(child: Text("Kosong")),
    );
  }
}
