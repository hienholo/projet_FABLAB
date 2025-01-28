import 'dart:convert';
import 'package:fablabs7/constaints.dart';
import 'package:fablabs7/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<List<UserModel>> getUsersApi(BuildContext context) async {
  try {
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token not found, please login again')),
      );
      return defaultUsers;
    }

    final response = await http.get(
      Uri.parse('http://192.168.221.249:3000/users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<UserModel> users = [];
      List data = jsonDecode(response.body.toString());
      for (Map i in data) {
        users.add(UserModel.fromJson(i));
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading users: $e')),
    );
    return defaultUsers;
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  final TextEditingController filterController = TextEditingController();

  Future<void> refreshUsers() async {
    final fetchedUsers = await getUsersApi(context);
    setState(() {
      users = fetchedUsers;
      filteredUsers = fetchedUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshUsers();
  }

  void filterUsersByName(String username) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.username!.toLowerCase().contains(username.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: filterController,
                onChanged: filterUsersByName,
                decoration: InputDecoration(
                  hintText: 'Search By Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getUsersApi(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading users'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No users found'));
                  } else {
                    users = snapshot.data!;
                    filteredUsers = users;
                    return ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        final isAllowedColor = user.allowed ?? false
                            ? Colors.green
                            : Colors.red;
                        final isAllowedText =
                            user.allowed ?? false ? 'Allowed' : 'Not Allowed';

                        return ListTile(
                          title: Text(user.username ?? ''),
                          subtitle: Text('Role: ${user.role}'),
                          trailing: Icon(Icons.circle, color: isAllowedColor),
                          onTap: () {
                           
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
