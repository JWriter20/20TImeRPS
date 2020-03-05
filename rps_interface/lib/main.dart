import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

int numRounds;
String rounds;
String pushedButton;
String randChoice; 
int wins = 0;
int losses = 0;
int ties = 0;
String win = 'Wins: ' + wins.toString();
String lose = 'Losses: ' + losses.toString();
String tie = 'Ties: ' + ties.toString();
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'RPS Simulator HomeScreen'),
    );
  }
}

class GamePage extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Best of " + rounds + " Rounds"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PictureButton1().build(context),
            PictureButton2().build(context),
            PictureButton3().build(context),
          ],
        ),
      ),
    );
  }
}
class GetRand {
  String randChoice(){
  var randChoice = (Random().nextInt(3)+9).toString();
    return randChoice;
  }
}
class ResultsMatrix {
  List winMatrix(){
  var x = new List.generate(3, (_) => new List(3));
    x[0][0] = 'You Tie';
    x[0][1] = 'You Lose';
    x[0][2] = 'You Win';
    x[1][0] = 'You Win';
    x[1][1] = 'You Tie';
    x[1][2] = 'You Lose';
    x[2][0] = 'You Lose';
    x[2][1] = 'You Win';
    x[2][2] = 'You Tie';
    return x;
  }
  String didWin(String randChoice){
    var myGuessParsed = int.parse(pushedButton)-9;
    var compGuessParsed = int.parse(randChoice)-9;
    switch(winMatrix()[myGuessParsed][compGuessParsed]){
      case 'You Tie': ties++; break;
      case 'You Win': wins++; break;
      case 'You Lose': losses++; break;
      default: return 'this broken'; break;
    }
    return winMatrix()[myGuessParsed][compGuessParsed];
  }
}
class FinalPage extends StatelessWidget {
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Results"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              DecorativeBackground(),
              Text('              '),
              DecorativeBackground2(),
              Text('              '),
              DecorativeBackground3(),
              Text('              '),
              BackToHomeButton(),

          ]
        ),
      ),
    );
  }
}


class ResultPage extends StatelessWidget {
  final String randChoice = GetRand().randChoice();
  
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: '  Computer',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 50),
                ),
              ),
              Image(image: AssetImage('./lib/Assets/Images/th-' + randChoice + '.png'), width: 300, height: 225),

              RichText(
              text: TextSpan(
                text: ResultsMatrix().didWin(randChoice),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 50),
                ),
              ),
              PlayAgainButton(),

              Image(image: AssetImage('./lib/Assets/Images/th-'+ pushedButton +'.png'), width: 300, height: 225),
              RichText(
              text: TextSpan(
                text: ' You',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 50),
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}


class PictureButton1 extends StatelessWidget{
   Widget build(BuildContext context){
    return FlatButton(
      highlightColor: Colors.white,
        onPressed: () {
          pushedButton = '9';
          Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ResultPage()),
          );
        },
        padding: EdgeInsets.all(0.0),
        child: new Image(image: AssetImage('./lib/Assets/Images/th-9.png'), width: 300, height: 225,)
    );
  }
}

class PictureButton2 extends StatelessWidget{
  Widget build(BuildContext context){
    return FlatButton(
      highlightColor: Colors.white,
        onPressed: () {
          pushedButton = '10';
          Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ResultPage()),
          );
        },
        padding: EdgeInsets.all(0.0),
        child: new Image(image: AssetImage('./lib/Assets/Images/th-10.png'), width: 300, height: 225,)
    );
  }
}

class PictureButton3 extends StatelessWidget{
  Widget build(BuildContext context){
    return FlatButton(
      highlightColor: Colors.white,
        onPressed: () {
          pushedButton = '11';
          Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ResultPage()),
          );
        },
        padding: EdgeInsets.all(0.0),
        child: new Image(image: AssetImage('./lib/Assets/Images/th-11.png'), width: 300, height: 225,)
    );
  }
}
class DecorativeBackground extends StatelessWidget{
  String getText(var text){
    return text;
  }
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      height: (MediaQuery.of(context).size.height)/4.5,
      width: (MediaQuery.of(context).size.width)/1.2,
      child: Align(
      alignment: Alignment.center,
        child: RichText(
                text: TextSpan(
                  text: getText(win),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.blue,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
class DecorativeBackground2 extends StatelessWidget{
  String getText(var text){
    return text;
  }
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height)/4.5,
      width: (MediaQuery.of(context).size.width)/1.2,
      child: Align(
      alignment: Alignment.center,
        child: RichText(
                text: TextSpan(
                  text: getText(lose),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.blue,
          width: 8,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
class DecorativeBackground3 extends StatelessWidget{
  String getText(var text){
    return text;
  }
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height)/4.5,
      width: (MediaQuery.of(context).size.width)/1.2,
      child: Align(
      alignment: Alignment.center,
        child: RichText(
                text: TextSpan(
                  text: getText(tie),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(
          color: Colors.blue,
          width: 8,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class PlayAgainButton extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
      child: RaisedButton(
        onPressed: () { 
          if(numRounds==1){
            win = 'Wins: ' + wins.toString();
            lose = 'Losses: ' + losses.toString();
            tie = 'Ties: ' + ties.toString();
            Navigator.push(context,
            new MaterialPageRoute(builder: (context) => FinalPage()));
          }else{
            numRounds--;
          rounds = numRounds.toString();
          Navigator.pop(context);
          }
      },
        elevation: 4.0,
        highlightElevation: 10.0,
              textColor: Colors.white,
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.blue
            ),
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                '                    Next Game                    ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      ),
    );
  }
}

class BackToHomeButton extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
      child: RaisedButton(
        onPressed: () { 
            wins = 0;
            losses = 0;
            ties = 0;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
      },
        elevation: 4.0,
        highlightElevation: 10.0,
              textColor: Colors.white,
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.blue
            ),
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                '               Return to HomePage               ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class HomepageButton extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
      child: RaisedButton(
        onPressed: () { 
          numRounds = 5;
          rounds = numRounds.toString();
          Navigator.push(context,
          new MaterialPageRoute(builder: (context) => GamePage()),
        );
      },
        elevation: 4.0,
        highlightElevation: 10.0,
              textColor: Colors.white,
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.blue
            ),
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                '                    Best of 5 rounds                    ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      ),
    );
  }
}
class HomepageButton2 extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
      child: RaisedButton(
        onPressed: () { 
          numRounds = 9;
          rounds = numRounds.toString();
          Navigator.push(context,
          new MaterialPageRoute(builder: (context) => GamePage()),
        );
      },
        elevation: 4.0,
        highlightElevation: 10.0,
              textColor: Colors.white,
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.blue
            ),
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                '                    Best of 9 rounds                    ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      )
    );
  } 
}
class HomepageButton3 extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
      child: RaisedButton(
        onPressed: () { 
          numRounds = 15;
          rounds = numRounds.toString();
          Navigator.push(context,
          new MaterialPageRoute(builder: (context) => GamePage()),
        );
      },
        elevation: 4.0,
        highlightElevation: 10.0,
              textColor: Colors.white,
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.blue
            ),
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                '                   Best of 15 rounds                   ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      )
    );
  } 
}

class ImageFinder extends StatelessWidget{
  Image findImage(String numOfPic){
    var assetImage = new AssetImage('./lib/Assets/Images/th-' + numOfPic + '.jpg');
      var image = new Image(image: assetImage, width: 400, height: 300);
      return image;
  }
  Widget build(BuildContext context) {
      return new Container(child: findImage('8'));
  }
}


class _MyHomePageState extends State<MyHomePage> {

  Future<String> getdata() async {
     // var response = 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: '   Can You Beat' + '\n  the Computer?',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 50),
                ),
              ),
              ImageFinder(),
              HomepageButton(),
              HomepageButton2(),
              HomepageButton3(),

          ],
        ),
      ),
    );
  }
}

