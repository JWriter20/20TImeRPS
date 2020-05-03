/*
Name: Jake Writer
Date: 5/3/2020
Purpose: This file builds an application with four different pages, the Homepage in 
which the user chooses how many games they want to play, the choicePage, in which 
they choose either rock, paper, or scissors, the individualGameResultPage, which shows 
who won that round, and the finalResultsPage, which shows the final number of wins,
losses, and ties. This file also contains the AI which the computer uses to make its 
guesses, it adjusts the odds based on whether or not it believes the player is going 
to switch or stay with their previous move. 
Initials: JAW
*/

import 'dart:math';
//import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:http/http.dart';

void main() => runApp(MyApp());

//AI portion:

int paperChance = 33;
int rockChance = 33; 
int scissorsChance = 100 - rockChance - paperChance;

double repStyleWin = 0;
double repStyleLose = 0;
double repStyleTie = 0;

double changeStyleWin = 0;
double changeStyleLose = 0;
double changeStyleTie = 0;

double rocksThrown = 0;
double papersThrown = 0;
double scissorsThrown = 0;

String compChoice;
String userChoice;

List<String> userChoices = new List<String>();

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


class AiMethods {

  //Purpose: converts the number input into a number below 1 and above -1, this prevents the 
  //numbers from getting too skewed in one direction
  //Assumptions: a double in inputted as the parameter 
  double sigmoidFunction(double confidenceVal){
      return confidenceVal/(sqrt(1+ pow(confidenceVal, 2)));
  }
  //Purpose: To return the predicted confidence level that the player will switch moves
  //assumptions: none
  double getSwitchConfidence(){
    //greater than 1 is quite sure, 1 is half sure, less than 1 is not sure
    var switchResults = (changeStyleWin + 0.25*(changeStyleTie) - 0.75*(changeStyleLose)) / (numRounds/5.0);
    return sigmoidFunction(switchResults);
    
  }
  //Purpose: To return the predicted confidence level that the player will not switch moves
  //assumptions: none
  double getStayConfidence(){
    var stayResults = (repStyleWin + 0.25*(repStyleTie) - 0.75*(repStyleLose)) / (numRounds/5.0);
    return sigmoidFunction(stayResults);
  }
  String prevChoice = userChoices[userChoices.length-1];
  //Purpose: Adjusts the odds of the three computer choices by looking at the stayConfidence,
  //switchConfidence and which move was previously thrown
  //assumptions: none
  void adjustOdds(){
    switch(prevChoice){
      case "r": 
        if(getStayConfidence()> getSwitchConfidence()){
          paperChance += 15;
          rockChance += 5;
          scissorsChance -= 20;
        }else{
          paperChance -= 10;
          rockChance -= 10;
          scissorsChance += 20;
        }

        break;

      case "p":
        if(getStayConfidence()> getSwitchConfidence()){
          paperChance += 5;
          rockChance -= 20;
          scissorsChance += 15;
        }else{
          paperChance -= 10;
          rockChance += 20;
          scissorsChance -= 10;
        }

      break;

      case "s":
        if(getStayConfidence()> getSwitchConfidence()){
          paperChance -= 20;
          rockChance += 15;
          scissorsChance += 5;
        }else{
          paperChance += 20;
          rockChance -= 10;
          scissorsChance -= 10;
        }

      break;

      //makes sure there is always an aspect of randomness by never letting the odds 
      //go below 20 or above 80
    }
    if(rockChance > 80){
      int remainder = rockChance - 80;
      rockChance = 80;
      if(remainder % 2 ==0){
        paperChance += (remainder ~/ 2);
        scissorsChance += (remainder ~/ 2);
      }else{
        paperChance += (remainder ~/ 2) + 1;
        scissorsChance += remainder ~/ 2;
      }

    }

    if(paperChance > 80){
      int remainder = paperChance - 80;
      paperChance = 80;
      if(remainder % 2 ==0){
        rockChance += (remainder ~/ 2);
        scissorsChance += (remainder ~/ 2);
      }else{
        rockChance += (remainder ~/ 2) + 1;
        scissorsChance += (remainder ~/ 2);
      }
    }

    if(scissorsChance > 80){
      int remainder = scissorsChance - 80;
      scissorsChance = 80;
      if(remainder % 2 ==0){
        paperChance += (remainder ~/ 2);
        rockChance += (remainder ~/ 2);
      }else{
        paperChance += (remainder ~/ 2) + 1;
        rockChance += (remainder ~/ 2);
      }
    }

    if(rockChance < 20 ){
      int remainder = 20 - rockChance;
      rockChance = 20;
      if(remainder % 2 ==0){
        paperChance -= (remainder ~/ 2);
        scissorsChance -= (remainder ~/ 2);
      }else{
        paperChance -= (remainder ~/ 2) + 1;
        scissorsChance -= (remainder ~/ 2);
      }
    }

    if(paperChance < 20){
      int remainder = 20 - paperChance;
      paperChance = 20;
      if(remainder % 2 ==0){
        rockChance -= (remainder ~/ 2);
        scissorsChance -= (remainder ~/ 2);
      }else{
        rockChance -= (remainder ~/ 2) + 1;
        scissorsChance -= (remainder ~/ 2);
      }
    }

    if(scissorsChance < 20){
      int remainder = 20 - scissorsChance;
      scissorsChance = 20;
      if(remainder % 2 ==0){
        paperChance -= (remainder ~/ 2);
        rockChance -= (remainder ~/ 2);
      }else{
        paperChance -= (remainder ~/ 2) + 1;
        rockChance -= (remainder ~/ 2);
      }
    }
    

  }
  //Purpose: to print the odds of each of the choices
  //Assumptions: None
  void printOdds(){
    print("rockchance: " + rockChance.toString());
     print("PaperChance: " + paperChance.toString());
     print("ScissorsChance: " + scissorsChance.toString());
  }
}
//Purpose: builds the app itself and records data based on the user's choices
//Assumptions: flutter is installed
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
//Purpose: creates the GamePage
class GamePage extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rounds + " Rounds"),
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
//Purpose: choose a Random action for the computer to take using the calculated odds
class GetRand {
  String randChoice(){
    //9 10 11
    var randChoice = "";
    var randNum = Random().nextInt(100);
    print("randnum: " + randNum.toString());
    if(randNum < paperChance){randChoice = "11"; print("1");}
    else if(randNum >= (paperChance + scissorsChance)){randChoice = "10";print("2");}
    else{randChoice = "9";print("3");}

    return randChoice;
  }
}
//Purpose: Used to see if the user won or lost
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
  //Purpose: returns if the user won or lost and stores data
  String didWin(String randChoice){
    String prevChoice;
    if(userChoices.length > 0){prevChoice = userChoices[userChoices.length-1];}
    else{prevChoice = "r";}
    
    var myGuessParsed = int.parse(pushedButton)-9;
    var compGuessParsed = int.parse(randChoice)-9;
    switch(winMatrix()[myGuessParsed][compGuessParsed]){
      case 'You Tie': ties++; if(prevChoice == userChoice) repStyleTie++;else{changeStyleTie++;}break;
      case 'You Win': wins++; if(prevChoice == userChoice) repStyleWin++;else{changeStyleWin++;} break;
      case 'You Lose': losses++; if(prevChoice == userChoice) repStyleLose++;else{changeStyleLose++;}break;
      default: return 'this broken'; break;
    }
    AiMethods().adjustOdds();
    AiMethods().printOdds();
    print("stayChance: " + AiMethods().getStayConfidence().toString());
    print("ChangeChance: " + AiMethods().getSwitchConfidence().toString());
    return winMatrix()[myGuessParsed][compGuessParsed];
  }
}
//Purpose: Creates the finalaPage
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

//Purpose: Creates the resultPage
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

//Purpose: A button used in the GamePage
class PictureButton1 extends StatelessWidget{
   Widget build(BuildContext context){
    return FlatButton(
      highlightColor: Colors.white,
        onPressed: () {
          pushedButton = '9';
          userChoice = 's';
          userChoices.insert(userChoice.length-1, userChoice);
          scissorsThrown++;
          Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ResultPage()),
          );
        },
        padding: EdgeInsets.all(0.0),
        child: new Image(image: AssetImage('./lib/Assets/Images/th-9.png'), width: 300, height: 225,)
    );
  }
}

//Purpose: A button used in the GamePage
class PictureButton2 extends StatelessWidget{
  Widget build(BuildContext context){
    return FlatButton(
      highlightColor: Colors.white,
        onPressed: () {
          pushedButton = '10';
          userChoice = 'r';
          userChoices.insert(userChoice.length-1, userChoice);
          rocksThrown++;
          Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ResultPage()),
          );
        },
        padding: EdgeInsets.all(0.0),
        child: new Image(image: AssetImage('./lib/Assets/Images/th-10.png'), width: 300, height: 225,)
    );
  }
}

//Purpose: A button used in the GamePage
class PictureButton3 extends StatelessWidget{
  Widget build(BuildContext context){
    return FlatButton(
      highlightColor: Colors.white,
        onPressed: () {
          pushedButton = '11';
          userChoice = 'p';
          userChoices.insert(userChoice.length-1, userChoice);
          papersThrown++;
          Navigator.push(context,
            new MaterialPageRoute(builder: (context) => ResultPage()),
          );
        },
        padding: EdgeInsets.all(0.0),
        child: new Image(image: AssetImage('./lib/Assets/Images/th-11.png'), width: 300, height: 225,)
    );
  }
}
//Purpose: Formats the result in the FinalResults page
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
//Purpose: Formats the result in the FinalResults page
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
//Purpose: Formats the result in the FinalResults page
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
//Purpose: Button that takes the user back a page to play again 
// as long as the number of rounds has not exceeded the initially 
// selected number
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
//Purpose: Takes the user back to the homepage
//Assumptions: The user is on the last page (finalResultsPage)
class BackToHomeButton extends StatelessWidget{
  Widget build(BuildContext context){
    return Container(
      child: RaisedButton(
        onPressed: () { 
            wins = 0;
            rockChance = 33;
            paperChance = 33;
            scissorsChance = (100 - rockChance - paperChance);
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

//Purpose: Formats the Homepage
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

//Purpose: Creates a button on the homepage that takes user to the GamePage
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
                '                        5 rounds                        ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      ),
    );
  }
}
//Purpose: Creates a button on the homepage that takes user to the GamePage
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
                '                        9 rounds                        ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      )
    );
  } 
}
//Purpose: Creates a button on the homepage that takes user to the GamePage
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
                '                       15 rounds                       ',
                style: TextStyle(fontSize: 25)
              ),
            ),
      )
    );
  } 
}

//Purpose: Gets a picture from a number assigned to it
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

  //Future<String> voidgetdata() async {
     //print("rockchance: " + rockChance.toString());
     //print("PaperChance: " + paperChance.toString());
     //print("ScissorsChance: " + scissorsChance.toString());

     //return null;
  //}

  //Builds homepage
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

