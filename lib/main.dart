import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'dart:async';
import 'dart:math';

var primaryColor = 0xff595959;
var secondaryColor1 = 0xff7f7f7f;
var secondaryColor3 = 0xffa5a5a5;
var secondaryColor4 = 0xffcccccc;
var secondaryColor5 = 0xfff2f2f2;

XmlDocument XmlParsed = XmlDocument();

void main() {
  runApp(const MainApp());

}

Future<String> _loadXML() async{
  return await rootBundle.loadString('file.xml');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xff595959),
        cardColor: const Color(0xffa5a5a5),
        primaryColorLight: const Color(0xff7f7f7f),
        canvasColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white
        ),
        
        cardTheme: const CardTheme(
          color: Color(0xFFE3E1D9),
        )
      ),
      home: const MainPage()
    );
  }
}

class MainPage extends StatelessWidget{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Словарь'),
        actions: [
        IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(data: XmlParsed.findAllElements('standarts').first);
          },));
        }
        , icon: const Icon(Icons.search))
      ],
      ),
      body: Builder(
        builder: (context) {
          return FutureBuilder(
            future: _loadXML(), 
            builder: (context, snapshot) {
              if(snapshot.hasData){
                final XmlString = snapshot.data;
          
                XmlParsed = XmlDocument.parse(XmlString.toString());
          
                return ListView.builder(
                  itemCount: XmlParsed.findAllElements('standart').length,
                  itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child:Material(
                            child: Ink.image(
                              image: NetworkImage(XmlParsed.findAllElements('standart').toList()[index].attributes.where((p0) => p0.name.toString() == 'image').first.value),
                              fit: BoxFit.fitWidth,
                              height: 120,
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcATop),
                              child:InkWell(
                                customBorder: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child:Text(XmlParsed.findAllElements('standart').toList()[index].attributes.where((p0) => p0.name.toString() == 'title').first.value, style: const TextStyle(color: Colors.white, fontSize: 15), softWrap: true,),
                                  )
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: ((context) {
                                    return StandartPage(element: XmlParsed.findAllElements('standart').toList()[index]);
                                  })));
                                },
                              )
                            )
                          )
                        )
                      );
                  }
                );
              }
              else{
                return const Text('Loadeng');
              }
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TestPage(data: XmlParsed.findAllElements('standarts').first, rand: Random().nextInt(4),);
          },));
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.fitness_center),
      ),
    );
  }
}

class StandartPage extends StatelessWidget{
  const StandartPage({Key? key, required this.element}) : super(key: key);
  final XmlElement element;

  @override
  Widget build(BuildContext context){
    var listView = ListView.builder(
      itemCount: element.findAllElements('term').length,
      itemBuilder: (BuildContext context, int index) {
          return Card.filled(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      alignment: Alignment.topLeft,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Icon(Icons.east), 
                      ),
                    ),
                    Expanded(
                      child: Text(element.findAllElements('term').toList()[index].attributes.where((p0) => p0.name.toString() == 'name').first.value, style: const TextStyle(fontSize: 20,),textAlign: TextAlign.left,softWrap: true, ),
                    )
                  ]
                ),
              ),
              onTap: () {
                showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
                  return Wrap(
                    children:[
                      Center(
                        
                        child: Column(children: [
                          Container(
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(15))),
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(20),
                            width: double.maxFinite,
                            child: Text(element.findAllElements('term').toList()[index].attributes.where((p0) => p0.name.toString() == 'name').first.value, style: const TextStyle(color: Colors.white, fontSize: 30), softWrap: true,),
                          ),
                          IntrinsicHeight(
                            
                            child: Row(
                              children: [
                                IntrinsicHeight(
                                  // height: double.maxFinite,
                                  child:VerticalDivider(
                                    width: 20,
                                    thickness: 2,
                                    indent: 20,color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(left: BorderSide(color: Theme.of(context).primaryColorLight, width: 5))
                                    ),
                                    width: double.maxFinite,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      width: double.maxFinite,
                                      child: Text(element.findAllElements('term').toList()[index].innerText.trim(), style: const TextStyle(fontSize: 20,), softWrap: true, ),
                                    )
                                  )
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.fromLTRB(0, 60, 0, 0))
                        ],
                        )
                      )
                    ]
                  );
                },
                );
              },
            ),
          );
        }
      );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(element.attributes.where((p0) => p0.name.toString() == 'title').first.value, style: const TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchPage(data: element);
            },));
          }
          , icon: const Icon(Icons.search))
        ],
      ),
      body: Center(
        child: listView,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TestPage(data: element, rand: Random().nextInt(4),);
          },));
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.fitness_center),
      ),
    );
  }
}

class SearchPage extends StatefulWidget{
  final XmlElement data;
  const SearchPage({Key? key, required this.data}) : super(key: key);


  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  String query = '';

  List<XmlElement> searchResults = [];

  Widget appBarTitle(){
    if (widget.data.name.local == 'standarts') {
      return const Text('Поиск', style: TextStyle(color: Colors.white),);
    } else {
       return Text('Поиск в ${widget.data.attributes.where((p0) => p0.name.toString() == 'title').first.value}', style: const TextStyle(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: appBarTitle(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: SearchBar(
            autoFocus: true,
            backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFF2EFE5)),
            onChanged: (query) {
              setState(() {
                searchResults = widget.data.findAllElements('term').where((element) => element.attributes.where((p0) => p0.name.toString() == 'name').first.value.contains(query)).toList();
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return Card.outlined(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: InkWell(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          alignment: Alignment.topLeft,
                          child: Container(
                             alignment: Alignment.topLeft,
                            child: const Icon(Icons.east),),
                        ),
                        Expanded(
                          child: Text(searchResults[index].attributes.where((p0) => p0.name.toString() == 'name').first.value, style: const TextStyle(fontSize: 20,),textAlign: TextAlign.left,softWrap: true, ),
                        )
                      ]
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, builder: (context) {
                      return Wrap(
                        children:[
                          Center(
                            
                            child: Column(children: [
                              Container(
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(15))),
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.all(20),
                                width: double.maxFinite,
                                child: Text(searchResults[index].attributes.where((p0) => p0.name.toString() == 'name').first.value, style: const TextStyle(color: Colors.white, fontSize: 30), softWrap: true,),
                              ),
                              IntrinsicHeight(
                                
                                child: Row(
                                  children: [
                                    IntrinsicHeight(
                                      child:VerticalDivider(
                                        width: 20,
                                        thickness: 2,
                                        indent: 20,color: Theme.of(context).primaryColorLight,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(color: Theme.of(context).primaryColorLight, width: 5))
                                        ),
                                        width: double.maxFinite,
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          width: double.maxFinite,
                                          child: Text(searchResults[index].innerText.trim(), style: const TextStyle(fontSize: 20,), softWrap: true, ),
                                        )
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.fromLTRB(0, 60, 0, 0))
                            ],
                            )
                          )
                        ]
                      );
                    },
                    );
                  },
                ),
              );
          },)
        )
      ],
      )
    );
  }
}

class TestPage extends StatefulWidget{
  final XmlElement data;
  final int rand;
  const TestPage({Key? key, required this.data, required this.rand}): super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>{
  int choice = 0;

  int rightAnswer = -1;
  int wrongAnswer = -1;

  bool checked = false;

  List<XmlElement> answers = [];

  Color _colorTiles(int index){
    if (checked) {
      if(index == rightAnswer){
        return const Color(0xFFB3E283);
      }
      if(index == wrongAnswer){
        return const Color(0xFFEC7272);
      }
      else{
        return Colors.white;
      }
    }
    else{
      return Colors.white;
    }
  }

  Widget getTitle(){
    if (widget.data.name.local == 'standarts') {
      return const Text('Тест', style: TextStyle(color: Colors.white));
    } else {
      return Text('Тест по ${widget.data.attributes.where((p0) => p0.name.toString() == 'title').first.value}', style: const TextStyle(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context){
    int answer = widget.rand;
    while(answers.length < 4){
      var _random = Random();
      var rand_int = _random.nextInt(widget.data.findAllElements('term').length);
      if(!answers.contains(widget.data.findAllElements('term').toList()[rand_int])){
        answers.add(widget.data.findAllElements('term').toList()[rand_int]);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: getTitle(),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(15))),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(20),
            width: double.maxFinite,
            child: Text('Выберите определение термина "${answers[answer].attributes.where((p0) => p0.name.toString() == 'name').first.value}":', style: const TextStyle(color: Colors.white, fontSize: 24, ), softWrap: true, textAlign: TextAlign.center,),
          ),
          Expanded(
            child: SizedBox(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    activeColor: Theme.of(context).primaryColorLight,
                    tileColor: _colorTiles(index),
                    title: Text(answers[index].innerText.trim()),
                    value: index + 1,
                    groupValue: choice,
                    onChanged: (value) {
                      setState(() {
                        choice = value!;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Divider(color: Theme.of(context).primaryColorLight,),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: FilledButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor
          ),
          child: checked ? const Text('Следующий вопрос') : const Text('Проверить'),
          onPressed: () {
            
            if (!checked) {
              if(choice == answer + 1){
                setState(() {
                  checked = true;
                  rightAnswer = answer;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Верно!'), duration: Duration(seconds: 1),));
              }
              else{
                setState(() {
                  checked = true;
                  rightAnswer = answer;
                  wrongAnswer = choice - 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Неверно!'), duration: Duration(seconds: 1),));
              }
            }
            else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return TestPage(data: widget.data, rand: Random().nextInt(4),);
              },));
            }
          },
        ),
      ),
    );
  }
}
