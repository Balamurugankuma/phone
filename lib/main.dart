import 'package:flutter/material.dart';
import 'package:untitled19/models/contact.dart';
import 'package:untitled19/user_service.dart';
import 'create_user.dart';
import 'editscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isdark = false;
  String phone_number = "";
  TextEditingController _phonenumbercontroller = TextEditingController();
  TextEditingController _searchcontactscontroller = TextEditingController();
  List<contact> _list = [];
  List<Map<String, dynamic>> searchresults = [];
  bool search = true;
  User_service user_service = User_service();
  getdata() async {
    var user = await user_service.readuser();
    setState(() {
      _list = user.map<contact>((e) => contact.fromMap(e)).toList();
      if (searchresults.isEmpty) search = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isdark ? ThemeMode.dark : ThemeMode.light,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: TextField(
              onChanged: (value) async {
                var data = await user_service.Serachuser(value);
                setState(() {
                  searchresults = data;
                  search = false;
                  if (value.isEmpty) {
                    search = true;
                  }
                });
              },

              controller: _searchcontactscontroller,
              decoration: InputDecoration(
                labelText: 'Search contacts',
                fillColor: Colors.black12,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          endDrawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Row(children: [Text("Settings")])),

                Row(
                  children: [
                    SizedBox(width: 10),
                    Text('Theme Mode'),
                    SizedBox(width: 90),
                    Switch(
                      value: isdark,
                      onChanged: (value) {
                        setState(() {
                          isdark = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          body: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_alt, color: Colors.blue),
                  SizedBox(width: 20),
                  Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => createuser(),
                            ),
                          );
                          if (result == true) {
                            getdata();
                          }
                        },
                        child: Text(
                          'Create new contact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: search
                    ? ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return Builder(
                            builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => edit_screen(
                                        user: _list[index],
                                        function: getdata,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        _list[index].name
                                                ?.substring(0, 1)
                                                .toUpperCase() ??
                                            '',
                                      ),
                                    ),
                                    title: Text(_list[index].name ?? 'No name'),
                                    subtitle: Text(
                                      _list[index].phone_number ?? 'No Number',
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        PopupMenuButton<String>(
                                          itemBuilder: (contex) => [
                                            PopupMenuItem(
                                              child: Text('Call History'),
                                            ),
                                            PopupMenuItem(
                                              child: Text('Message'),
                                            ),
                                          ],
                                        );
                                      },
                                      icon: Icon(Icons.more_vert),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: searchresults.length,
                        itemBuilder: (context, index) {
                          final user = searchresults[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                _list[index].name
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    '',
                              ),
                            ),
                            title: Text(user['name']),
                            subtitle: Text(user['phone_number']),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: SizedBox(
            width: 70,
            height: 70,
            child: Builder(
              builder: (context) {
                return FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 500,
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 80,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: TextField(
                                    controller: _phonenumbercontroller,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            phone_number = phone_number
                                                .substring(
                                                  0,
                                                  phone_number.length - 1,
                                                );
                                            _phonenumbercontroller.text =
                                                phone_number;
                                          });
                                        },
                                        icon: Icon(Icons.backspace_outlined),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '1';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '1',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '2';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '2',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '3';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '3',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '4';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '4',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '5';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '5',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '6';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '6',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '7';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '7',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '8';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '8',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '9';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '9',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '*';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '*',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '0';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '0',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        phone_number += '#';
                                        _phonenumbercontroller.text =
                                            phone_number;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    child: Text(
                                      '#',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),

                                  child: Icon(Icons.call, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.dialpad, size: 30, color: Colors.black),
                );
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'Recents',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2),
                label: 'Contacts',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
