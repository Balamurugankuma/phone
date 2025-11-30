import 'package:flutter/material.dart';
import 'package:untitled19/user_service.dart';

import 'models/contact.dart';

class createuser extends StatefulWidget {
  const createuser({super.key});

  @override
  State<createuser> createState() => _createuserState();
}

class _createuserState extends State<createuser> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _phonenumbercontroller = TextEditingController();
  bool namevalide = false;
  bool phonevalide = false;
  contact user = contact();
  User_service user_service = User_service();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create contact'),

        actions: [
          ElevatedButton(
            onPressed: () async {
              setState(() {
                namevalide = _namecontroller.text.isEmpty;
                phonevalide = _phonenumbercontroller.text.isEmpty;
              });
              if (!namevalide && !phonevalide) {
                user.name = _namecontroller.text;
                user.phone_number = _phonenumbercontroller.text;
                await user_service.Saveuser(user);
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Save', style: TextStyle(color: Colors.black)),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),

      body: Column(
        children: [
          Center(child: CircleAvatar(radius: 50, child: Icon(Icons.person))),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(),
              child: TextField(
                controller: _namecontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(),
              child: TextField(
                controller: _phonenumbercontroller,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
