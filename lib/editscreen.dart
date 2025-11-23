import 'package:flutter/material.dart';
import 'package:untitled19/editcontact.dart';
import 'package:untitled19/models/contact.dart';
import 'package:untitled19/user_service.dart';

class edit_screen extends StatefulWidget {
  final contact user;
  final Function function;

  const edit_screen({super.key, required this.user, required this.function});

  @override
  State<edit_screen> createState() => _edit_screenState();
}

class _edit_screenState extends State<edit_screen> {
  String? name;
  String? phonenumber;
  String profiel = '';
  User_service user_service = User_service();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      name = widget.user.name;
      phonenumber = widget.user.phone_number;
      profiel = widget.user.name!.substring(0, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Editcontact(user: widget.user, refresh: widget.function),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
          SizedBox(width: 30),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Delete') {
                Delete(context, widget.user.id);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Share')),
              PopupMenuDivider(),
              PopupMenuItem(child: Text('Set ringtone')),
              PopupMenuItem(child: Text('Move to another account')),
              PopupMenuItem(value: 'Delete', child: Text('Delete')),
            ],
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            child: Text(
              '$profiel'.toUpperCase(),
              style: TextStyle(color: Colors.black, fontSize: 40),
            ),
          ),
          SizedBox(height: 10),
          Text('$name', style: TextStyle(fontSize: 30)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.call)),
              IconButton(onPressed: () {}, icon: Icon(Icons.textsms)),
              IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text('Call'), Text('Text'), Text('Video')],
          ),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(right: 220),
                    child: Text(
                      'Contact info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.call, size: 30),
                      SizedBox(width: 20),
                      Text('$phonenumber'),
                      SizedBox(width: 180),
                      Icon(Icons.video_call),

                      SizedBox(width: 20),
                      Icon(Icons.textsms),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Padding(
            padding: EdgeInsets.only(right: 220),
            child: Text(
              'Contact settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 200),
            child: TextButton.icon(
              onPressed: () {},
              label: Text(
                'Block number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              icon: Icon(Icons.block),
            ),
          ),
        ],
      ),
    );
  }

  Delete(BuildContext context, id) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          content: Text('Are you sure to delete'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await user_service.deleteuser(id);
                Navigator.pop(context);
                Navigator.pop(context);
                if (result != null && result > 0) {
                  widget.function();
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
