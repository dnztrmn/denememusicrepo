import 'package:flutter/material.dart';
import '../../services/api_manager.dart';
import '../../models/api_key.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final APIManager _apiManager = APIManager();
  final _keyController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _keyController,
                      decoration: InputDecoration(
                        labelText: 'API Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Key Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addNewKey,
                      child: Text('Add New API Key'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildKeysList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeysList() {
    return ValueListenableBuilder(
      valueListenable: _apiManager.keysBoxListenable,
      builder: (context, Box<APIKey> box, _) {
        final keys = box.values.toList();
        return ListView.builder(
          itemCount: keys.length,
          itemBuilder: (context, index) {
            final apiKey = keys[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(apiKey.name),
                subtitle: Text('Quota used: ${apiKey.quotaUsed}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: apiKey.isActive,
                      onChanged: (value) async {
                        await _apiManager.updateKeyStatus(apiKey.key, value);
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _apiManager.removeAPIKey(apiKey.key);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addNewKey() async {
    if (_keyController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      await _apiManager.addAPIKey(_keyController.text, _nameController.text);
      _keyController.clear();
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API key added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add API key: $e')),
      );
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
