import 'dart:async';
import 'dart:io';
import 'package:Yemenaman/constants.dart';
import 'package:Yemenaman/screensadmin/database.dart';
import 'package:Yemenaman/screensuser/chatroomsuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Yemenaman/mainPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:intl/src/intl/date_format.dart';

import '../widgets/title_text.dart';

class add_requestuser extends StatefulWidget {
  final usertype;

  const add_requestuser({Key? key, this.usertype}) : super(key: key);
  @override
  _add_requestuserState createState() => _add_requestuserState();
}

class _add_requestuserState extends State<add_requestuser> {
  final _formKeyadd_request = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController blackailerinfoController = TextEditingController();
  TextEditingController citysearch = TextEditingController();
  String? victimsexValue1;
  String? cityValue1;
  String? whoareuvictimValue1;
  String? youknowhimValue1;
  String? familyknowbuttonValue1;
  DateTime selectedDate = DateTime.now();
  String? datedone;
  File? image1;
  File? imageTemp1;
  bool? imagestatue1 = false;
  File? image2;
  File? imageTemp2;
  bool? imagestatue2 = false;
  File? image3;
  File? imageTemp3;
  bool? imagestatue3 = false;
  File? image4;
  File? imageTemp4;
  bool? imagestatue4 = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final List<String> whoareuvictim = [
    "أخت الضحية ",
    "أخو الضحية",
    "أب الضحية",
    "أم الضحية",
    "الضحية نفسها",
    "صديق"
  ];
  final List<String> youknowhim = ["نعم", "لا"];
  final List<String> familyknowbutton = ["نعم", "لا"];
  final List<String> victimsex = ["دكر", "انثى"];
  final List<String> citynames = [
    "Sana'a",
    "Taizz",
    "Al Hudaydah",
    "Aden",
    "Ibb",
    "Dhamar",
    "al-Mukalla",
    "Zinjibar",
    "Sayyan",
    "Ash Shihr",
    "Sahar",
    "Zabid",
    "Hajjah",
    "Badschil",
    "Dhi as-Sufal",
    "Rida",
    "Socotra",
    "Bait al-Faqih",
    "al-Marawi'a",
    "Yarim",
    "Al Bayda'",
    "Amran",
    "Lahij",
    "Abs",
    "Harad",
    "Dimnat Chadir",
    "Ataq",
    "al-Mahabischa",
    "Baihan al-Kisab",
    "Marib",
    "Thila",
    "as-Saidiyya",
    "Madiyya",
    "Chamr",
    "Hais",
    "ad-Dahi",
    "Mocha",
    "al-Ghaida",
    "Al Mahwit"
  ];

  @override
  void dispose() {
    citysearch.dispose();
    super.dispose();
  }

  victimsexbutton() {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'المرجو التحديد',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              items: victimsex
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              value: victimsexValue1,
              onChanged: (value) {
                setState(() {
                  victimsexValue1 = value as String;
                });
              },
              selectedItemHighlightColor: Colors.greenAccent,
              buttonHeight: MediaQuery.of(context).size.height * .06,
              buttonWidth: MediaQuery.of(context).size.width * .35,
              itemHeight: 50,
              dropdownMaxHeight: 200,
              buttonDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TitleText(
              text: 'جنس الضحية',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey),
        ),
      ],
    );
  }

  youknowhimbutton() {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'المرجو التحديد',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              items: youknowhim
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              value: youknowhimValue1,
              onChanged: (value) {
                setState(() {
                  youknowhimValue1 = value as String;
                });
              },
              selectedItemHighlightColor: Colors.greenAccent,
              buttonHeight: MediaQuery.of(context).size.height * .06,
              buttonWidth: MediaQuery.of(context).size.width * .35,
              itemHeight: 50,
              dropdownMaxHeight: 200,
              buttonDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TitleText(
              text: 'هل تعرف المبتز',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey),
        ),
      ],
    );
  }

  citybutton() {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'إختر مدينتك',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              items: citynames
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              value: cityValue1,
              onChanged: (value) {
                setState(() {
                  cityValue1 = value as String;
                });
              },
              selectedItemHighlightColor: Colors.greenAccent,
              buttonHeight: MediaQuery.of(context).size.height * .06,
              buttonWidth: MediaQuery.of(context).size.width * .35,
              itemHeight: 50,
              dropdownMaxHeight: 200,
              searchController: citysearch,
              buttonDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10)),
              searchInnerWidget: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  controller: citysearch,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'إبحث',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return (item.value.toString().contains(searchValue));
              },
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  citysearch.clear();
                }
              },
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TitleText(
              text: 'إختر المدينة',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey),
        ),
      ],
    );
  }

  isfamilyknowbutton() {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'المرجو التحديد',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              items: familyknowbutton
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              value: familyknowbuttonValue1,
              onChanged: (value) {
                setState(() {
                  familyknowbuttonValue1 = value as String;
                });
              },
              selectedItemHighlightColor: Colors.greenAccent,
              buttonHeight: MediaQuery.of(context).size.height * .06,
              buttonWidth: MediaQuery.of(context).size.width * .35,
              itemHeight: 50,
              dropdownMaxHeight: 200,
              buttonDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TitleText(
              text: 'أهل الضحية عندهم علم بلابتزاز',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey),
        ),
      ],
    );
  }

  whoareubutton() {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(15),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'إختر من أنت',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              items: whoareuvictim
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
              value: whoareuvictimValue1,
              onChanged: (value) {
                setState(() {
                  whoareuvictimValue1 = value as String;
                });
              },
              selectedItemHighlightColor: Colors.greenAccent,
              buttonHeight: MediaQuery.of(context).size.height * .06,
              buttonWidth: MediaQuery.of(context).size.width * .35,
              itemHeight: 50,
              dropdownMaxHeight: 200,
              buttonDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TitleText(
              text: 'من أنت بالنسبة لضحية',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.grey),
        ),
      ],
    );
  }

  datebutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          child: InkWell(
            onTap: () => selectDate(context),
            child: Container(
              height: MediaQuery.of(context).size.height * .06,
              width: MediaQuery.of(context).size.width * .35,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TitleText(
            text: 'تاريخ بداية لإبتزاز',
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  //pick images //////////////////////////////////////////////////////////
  Future pickImage1() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final galleryimage = await _picker.pickImage(source: ImageSource.gallery);
      if (galleryimage == null) return;
      imageTemp1 = File(galleryimage.path);
      setState(() {
        this.image1 = imageTemp1;
        imagestatue1 = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImage2() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final galleryimage = await _picker.pickImage(source: ImageSource.gallery);
      if (galleryimage == null) return;
      imageTemp2 = File(galleryimage.path);
      setState(() {
        this.image2 = imageTemp2;
        imagestatue2 = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImage3() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final galleryimage = await _picker.pickImage(source: ImageSource.gallery);
      if (galleryimage == null) return;
      imageTemp3 = File(galleryimage.path);
      setState(() {
        this.image3 = imageTemp3;
        imagestatue3 = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImage4() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final galleryimage = await _picker.pickImage(source: ImageSource.gallery);
      if (galleryimage == null) return;
      imageTemp4 = File(galleryimage.path);
      setState(() {
        this.image4 = imageTemp4;
        imagestatue4 = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  ////////////////////////////////////////////////////////////////////////////

  //upload images //////////////////////////////////////////////////////////

  Future UploadImage() async {
    var filePath1 = "images/${Constants.myName}/1";
    var filePath2 = "images/${Constants.myName}/2";
    var filePath3 = "images/${Constants.myName}/3";
    var filePath4 = "images/${Constants.myName}/4";
    FirebaseStorage storage = FirebaseStorage.instance;
    final ref1 = storage.ref().child(filePath1);
    final ref2 = storage.ref().child(filePath2);
    final ref3 = storage.ref().child(filePath3);
    final ref4 = storage.ref().child(filePath4);
    if (image1 != null) {
      final uploadTask = await ref1.putFile(image1!);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      TaskSnapshot taskSnapshot = await uploadTask;
    }
    if (image2 != null) {
      final uploadTask = await ref2.putFile(image2!);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      TaskSnapshot taskSnapshot = await uploadTask;
    }
    if (image3 != null) {
      final uploadTask = await ref3.putFile(image3!);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      TaskSnapshot taskSnapshot = await uploadTask;
    }
    if (image4 != null) {
      final uploadTask = await ref4.putFile(image4!);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      TaskSnapshot taskSnapshot = await uploadTask;
    }
  }

  //pick images urls//////////////////////////////////////////////////////////
  Future<String> getPicurl1() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("images/${Constants.myName}/1");
    var url = (await ref.getDownloadURL());
    return url;
  }

  Future<String> getPicurl2() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("images/${Constants.myName}/2");
    var url = (await ref.getDownloadURL());
    return url;
  }

  Future<String> getPicurl3() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("images/${Constants.myName}/3");
    var url = (await ref.getDownloadURL());
    return url;
  }

  Future<String> getPicurl4() async {
    Reference ref =
        FirebaseStorage.instance.ref().child("images/${Constants.myName}/4");
    var url = (await ref.getDownloadURL());
    setState(() {});
    return url;
  }

  addMessagetosupport() {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .where(Constants.chatRoomId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((documentSnapshot) {
        documentSnapshot.reference
            .update({Constants.myName + "newmessage": "true"});
      });
    });
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "message": """
الضحية : ${Constants.myName}
الضحية تعرف المبتز : ${youknowhimValue1}
المدينة : ${cityValue1}
متى بدأ لإبتزاز : ${datedone}
جنس الضحية : ${victimsexValue1}
علاقتي بالضحية :  ${whoareuvictimValue1}
معلومات حول المبتز : ${blackailerinfoController.text}
""",
      'time': DateTime.now(),
      "type": "text"
    };

    DatabaseMethods().addMessage(Constants.chatRoomId, chatMessageMap);
  }

  sendMessage() async {
    final userName = "support";
    final otherUseruid = "P9S7AG9HhoZKeKKqFxrIx7zX4C92";
    Constants.chatRoomId = getChatRoomId1(Constants.myName, userName);
    List<String> users = [Constants.myName, userName];
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": Constants.chatRoomId,
      Constants.myName + "uid": FirebaseAuth.instance.currentUser!.uid,
      userName + "uid": otherUseruid,
      userName + "newmessage": "false",
      Constants.myName + "newmessage": "true"
    };

    databaseMethods.addChatRoom(chatRoom, Constants.chatRoomId);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatRoomUser()));
  }

  addimage1message() async {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "message": (imageTemp1 != null)
          ? await getPicurl1()
          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4wVfm3hRnQSlaOkrx7OJGLyD55rPosZyc1Ki5uo3CTXzm_1fohvVisivskfKcy7Tvcv4&usqp=CAUar.svg",
      'time': DateTime.now(),
      "type": "image"
    };
    await DatabaseMethods().addMessage(Constants.chatRoomId, chatMessageMap);
  }

  addimage2message() async {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "message": (imageTemp2 != null)
          ? await getPicurl2()
          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4wVfm3hRnQSlaOkrx7OJGLyD55rPosZyc1Ki5uo3CTXzm_1fohvVisivskfKcy7Tvcv4&usqp=CAUar.svg",
      'time': DateTime.now(),
      "type": "image"
    };
    await DatabaseMethods().addMessage(Constants.chatRoomId, chatMessageMap);
  }

  addimage3message() async {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "message": (imageTemp3 != null)
          ? await getPicurl3()
          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4wVfm3hRnQSlaOkrx7OJGLyD55rPosZyc1Ki5uo3CTXzm_1fohvVisivskfKcy7Tvcv4&usqp=CAUar.svg",
      'time': DateTime.now(),
      "type": "image"
    };
    await DatabaseMethods().addMessage(Constants.chatRoomId, chatMessageMap);
  }

  addimage4message() async {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "message": (imageTemp4 != null)
          ? await getPicurl4()
          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4wVfm3hRnQSlaOkrx7OJGLyD55rPosZyc1Ki5uo3CTXzm_1fohvVisivskfKcy7Tvcv4&usqp=CAUar.svg",
      'time': DateTime.now(),
      "type": "image"
    };
    await DatabaseMethods().addMessage(Constants.chatRoomId, chatMessageMap);
  }

  getChatRoomId1(String a, String b) {
    print(a);
    print(b);
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addimagemessage() async {
    FirebaseFirestore.instance
        .collection("blackmailingposts")
        .doc("blackmailingposts - ${Constants.myName}")
        .set({
      "victim name": Constants.myName,
      "image1": (imageTemp1 != null) ? await getPicurl1() : null,
      "image2": (imageTemp2 != null) ? await getPicurl2() : null,
      "image3": (imageTemp3 != null) ? await getPicurl3() : null,
      "image4": (imageTemp4 != null) ? await getPicurl4() : null,
      "victim sex": victimsexValue1,
      "blackmailer Info": blackailerinfoController.text,
      "victim Know blackmailer": youknowhimValue1,
      "who are you to victim": whoareuvictimValue1,
      "city": cityValue1,
      "when this start": datedone,
      "time": DateTime.now(),
    });
    _btnController.success();
  }

  uploadbutton() {
    return RoundedLoadingButton(
      color: Colors.green,
      successColor: Colors.amber,
      child: Text(
        "إرسال".toUpperCase(),
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      controller: _btnController,
      onPressed: () async {
        if (_formKeyadd_request.currentState!.validate()) {
          await UploadImage();
          await addimagemessage();
          await sendMessage();
          await addMessagetosupport();
          await addimage1message();
          await addimage2message();
          await addimage3message();
          await addimage4message();
        } else {
          _btnController.error();
          Timer(Duration(seconds: 1), () {
            _btnController.reset();
          });
        }
      },
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
         datedone = DateFormat('dd-MMM-yyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: OurColor.kPrimaryColor,
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(
                        "المرجو إضافة معلومات التالية إدا توفرت لكي نستطيع مساعدتك",
                        textAlign: TextAlign.end,
                        maxLines: 6,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKeyadd_request,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  victimsexbutton(),
                  youknowhimbutton(),
                  isfamilyknowbutton(),
                  whoareubutton(),
                  citybutton(),
                  datebutton(),
                  Container(
                    padding: const EdgeInsets.all(18),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 4,
                      textAlign: TextAlign.end,
                      controller: blackailerinfoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'رقم المبتز أو الحساب الخاص به أو أي معلومة عليه قد تفيد',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'المرجو تعبئة الخانة';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(8.0),
                    child: TitleText(
                        text: 'أرفق صور للمحادثة بين المبتز و الضحية',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          await pickImage1();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: (image1 != null)
                                  ? FileImage(image1!) as ImageProvider
                                  : AssetImage("assets/images/uploadimage.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await pickImage2();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: (image2 != null)
                                  ? FileImage(image2!) as ImageProvider
                                  : AssetImage("assets/images/uploadimage.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await pickImage3();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: (image3 != null)
                                  ? FileImage(image3!) as ImageProvider
                                  : AssetImage("assets/images/uploadimage.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await pickImage4();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: (image4 != null)
                                  ? FileImage(image4!) as ImageProvider
                                  : AssetImage("assets/images/uploadimage.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: uploadbutton(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
