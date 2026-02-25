import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  bool _isLoading = false;
  List<Map<String, dynamic>> _educations = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body:
          //  _educations.isEmpty
          // ? const Center(child: Text('Belum ada data.'))
          ListView.builder(
            itemCount: _educations.length,
            itemBuilder: (context, index) {
              final item = _educations[index];
              return ListTile(
                title: Text(item['title'] ?? '-'),
                subtitle: Text(item['desc'] ?? '-'),
              );
            },
          ),
    );
  }
}
