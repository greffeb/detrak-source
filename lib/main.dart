import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:sliding_switch/sliding_switch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: AdaptiveTheme(
        light: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.light),
        ),
        dark: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark),
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DÉTRAK',
          theme: theme,
          darkTheme: darkTheme,
          /*theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          ),*/
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var gameGrid = List<int>.generate(25, (int index) => 0, growable: false);
  var gameScore = List<int>.generate(13, (int index) => 0, growable: false);
  var diceValue = List<int>.generate(2, (int index) => Random().nextInt(6) + 1, growable: false);
  void updateScore(int caseId, int caseValue) {
    gameScore[12] = 0;
    gameGrid[caseId] = caseValue;
    gameScore[0] = computeScore(gameGrid[4], gameGrid[8], gameGrid[12], gameGrid[16], gameGrid[20]);
    gameScore[1] = computeScore(gameGrid[0], gameGrid[1], gameGrid[2], gameGrid[3], gameGrid[4]);
    gameScore[2] = computeScore(gameGrid[5], gameGrid[6], gameGrid[7], gameGrid[8], gameGrid[9]);
    gameScore[3] = computeScore(gameGrid[10], gameGrid[11], gameGrid[12], gameGrid[13], gameGrid[14]);
    gameScore[4] = computeScore(gameGrid[15], gameGrid[16], gameGrid[17], gameGrid[18], gameGrid[19]);
    gameScore[5] = computeScore(gameGrid[20], gameGrid[21], gameGrid[22], gameGrid[23], gameGrid[24]);
    gameScore[6] = gameScore[0];
    gameScore[7] = computeScore(gameGrid[0], gameGrid[5], gameGrid[10], gameGrid[15], gameGrid[20]);
    gameScore[8] = computeScore(gameGrid[1], gameGrid[6], gameGrid[11], gameGrid[16], gameGrid[21]);
    gameScore[9] = computeScore(gameGrid[2], gameGrid[7], gameGrid[12], gameGrid[17], gameGrid[22]);
    gameScore[10] = computeScore(gameGrid[3], gameGrid[8], gameGrid[13], gameGrid[18], gameGrid[23]);
    gameScore[11] = computeScore(gameGrid[4], gameGrid[9], gameGrid[14], gameGrid[19], gameGrid[24]);
    for (int iter = 0; iter < 12; iter++) {
      gameScore[12] += gameScore[iter];
    }
    notifyListeners();
  }

  int computeScore(int a, int b, int c, int d, int e) {
    int score = 0;
    bool scored = false;
    if (a != 0 && b != 0 && c != 0 && d != 0 && e != 0) {
      if ((a != 0 && b != 0 && c != 0 && d != 0 && e != 0) && (a == b && b == c && c == d && d == e)) {
        score = 10;
        scored = true;
      } else if (((a != 0 && b != 0 && c != 0 && d != 0) && (a == b && b == c && c == d)) ||
          ((b != 0 && c != 0 && d != 0 && e != 0) && (b == c && c == d && d == e))) {
        score = 8;
        scored = true;
      } else if ((b != 0 && c != 0 && d != 0) && (b == c && c == d)) {
        score = 3;
        scored = true;
      } else if ((a != 0 && b != 0 && c != 0) && (a == b && b == c)) {
        score += 3;
        scored = true;

        if ((d != 0 && e != 0) && (d == e)) {
          score += 2;
          scored = true;
        }
      } else if ((c != 0 && d != 0 && e != 0) && (c == d && d == e)) {
        score += 3;
        scored = true;

        if ((a != 0 && b != 0) && (a == b)) {
          score += 2;
          scored = true;
        }
      } else {
        if ((a != 0 && b != 0) && (a == b)) {
          score += 2;
          scored = true;
        }
        if ((b != 0 && c != 0) && (b == c)) {
          score += 2;
          scored = true;
        }
        if ((c != 0 && d != 0) && (c == d)) {
          score += 2;
          scored = true;
        }
        if ((d != 0 && e != 0) && (d == e)) {
          score += 2;
          scored = true;
        }
        if (scored == false) {
          score = -5;
        }
      }
    }
    notifyListeners();
    return score;
  }

  void diceRoll() {
    diceValue[0] = Random().nextInt(6) + 1;
    diceValue[1] = Random().nextInt(6) + 1;
    notifyListeners();
  }

  void clearGrid() {
    for (int i = 0; i < gameScore.length; i++) {
      gameScore[i] = 0;
    }
    for (int i = 0; i < gameGrid.length; i++) {
      gameGrid[i] = 0;
    }
    notifyListeners();
  }
}

class Symbol {
  AssetImage myIconData;
  int id;
  // Symbol({this.icon = Icons.abc, this.id = 0});
  Symbol({required this.myIconData, required this.id});
}

/*List<Symbol> symbols = [
  Symbol(myIconData: Icons.man, id: 0), // display white to emulate empty
  Symbol(myIconData: Icons.circle_outlined, id: 1),
  Symbol(myIconData: Icons.menu_rounded, id: 2),
  Symbol(myIconData: Icons.change_history_rounded, id: 3),
  Symbol(myIconData: Icons.horizontal_rule_rounded, id: 4),
  Symbol(myIconData: Icons.close_rounded, id: 5),
  Symbol(myIconData: Icons.tag_rounded, id: 6),
];*/

List<Symbol> symbols = [
  Symbol(myIconData: AssetImage('assets/blank.png'), id: 0),
  Symbol(myIconData: AssetImage('assets/rondBlack.png'), id: 1),
  Symbol(myIconData: AssetImage('assets/griffeBlack.png'), id: 2),
  Symbol(myIconData: AssetImage('assets/triangleBlack.png'), id: 3),
  Symbol(myIconData: AssetImage('assets/barreBlack.png'), id: 4),
  Symbol(myIconData: AssetImage('assets/croixBlack.png'), id: 5),
  Symbol(myIconData: AssetImage('assets/diezeBlack.png'), id: 6),
  Symbol(myIconData: AssetImage('assets/rondGrey.png'), id: 7),
  Symbol(myIconData: AssetImage('assets/griffeGrey.png'), id: 8),
  Symbol(myIconData: AssetImage('assets/triangleGrey.png'), id: 9),
  Symbol(myIconData: AssetImage('assets/barreGrey.png'), id: 10),
  Symbol(myIconData: AssetImage('assets/croixGrey.png'), id: 11),
  Symbol(myIconData: AssetImage('assets/diezeGrey.png'), id: 12),
];

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BuildGameInterface(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      title: Text(
        'DÉTRAK',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 36,
              color: theme.colorScheme.primary, // const Color(0xFFF64209),
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 30.0),
          child: SlidingSwitch(
            value: true,
            width: 100,
            onChanged: (bool value) {
              if (value == false) {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            },
            height: 35,
            animationDuration: const Duration(milliseconds: 400),
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            iconOff: Icons.dark_mode,
            iconOn: Icons.light_mode,
            contentSize: 20,
            colorOn: theme.colorScheme.onPrimary, //const Color(0xffdc6c73),
            colorOff: theme.colorScheme.onPrimary, //const Color(0xff6682c0),
            background: theme.colorScheme.primaryContainer, //const Color(0xffe4e5eb),
            buttonColor: theme.colorScheme.primary, //const Color(0xfff7f5f7),
            inactiveColor: theme.colorScheme.onPrimaryContainer, //const Color(0xff636f7b),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 30.0),
          child: ClearButton(context: context),
        ),
      ],
    );
  }
}

class BuildGameInterface extends StatefulWidget {
  const BuildGameInterface({
    super.key,
  });

  @override
  State<BuildGameInterface> createState() => _BuildGameInterfaceState();
}

class _BuildGameInterfaceState extends State<BuildGameInterface> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var screenAspectRatio = (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height);
    var gridSize = screenAspectRatio < 0.657
        ? ((MediaQuery.of(context).size.width) - 20) / 7
        : ((0.657 * (MediaQuery.of(context).size.height)) - 20) / 7;

    return ColoredBox(
      color: colorScheme.surfaceVariant,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /* SizedBox(
                      width: gridSize,
                      //child: Text("🔳🔳 = 2"),
                    ),*/
                    Container(
                      height: gridSize * 5,
                      width: gridSize,
                      child: FittedBox(child: Center(child: Image(image: AssetImage('assets/titre.png')))),
                    ),
                    Column(
                      children: [
                        Container(
                          height: gridSize,
                          width: gridSize * 5,
                          child: FittedBox(child: Center(child: Image(image: AssetImage('assets/score.png')))),
                        ),
                        buildCasesARemplir(),
                      ],
                    ),
                    buildScoreDroite(context)
                  ],
                ),
                buildScoreBas(context),
              ],
            ),
            //SizedBox(height: 20),
            buildSymboles(),
            //
            buildDiceRoll(context),
            SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Row buildDiceRoll(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var screenAspectRatio = (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height);
    var rollSize = screenAspectRatio < 0.657
        ? ((MediaQuery.of(context).size.width) - 20) / 5
        : ((0.657 * (MediaQuery.of(context).size.height)) - 20) / 5;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            appState.diceRoll();
          },
          child: FittedBox(
              child: Text(
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  "Roll")),
        ),
        SizedBox(width: 20),
        SizedBox(
            height: rollSize,
            width: rollSize,
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                children: [
                  DraggableSymbol(localSymbol: symbols[appState.diceValue[0]]),
                ],
              ),
            )),
        SizedBox(
            height: rollSize,
            width: rollSize,
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                children: [
                  DraggableSymbol(localSymbol: symbols[appState.diceValue[1]]),
                ],
              ),
            )),
      ],
    );
  }

  SizedBox buildSymboles() {
    var screenAspectRatio = (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height);
    var symbolSize = screenAspectRatio < 0.657
        ? ((MediaQuery.of(context).size.width) - 20) / 6
        : ((0.657 * (MediaQuery.of(context).size.height)) - 20) / 6;
    return SizedBox(
      //width: symbolSize * 6,
      height: symbolSize,
      child: Card(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          //SYMBOLES
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 1; i < 7; i++) DraggableSymbol(localSymbol: symbols[i]),
          ],
        ),
      ),
    );
  }

  Row buildScoreBas(BuildContext context) {
    return Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CaseScore(
            scoreItemNo: 6,
          ),
          CaseScore(
            scoreItemNo: 7,
          ),
          CaseScore(
            scoreItemNo: 8,
          ),
          CaseScore(
            scoreItemNo: 9,
          ),
          CaseScore(
            scoreItemNo: 10,
          ),
          CaseScore(
            scoreItemNo: 11,
          ),
          CaseScore(
            scoreItemNo: 12,
          ),
        ]);
  }

  Column buildScoreDroite(BuildContext context) {
    return Column(children: <Widget>[
      CaseScore(
        scoreItemNo: 0,
      ),
      CaseScore(
        scoreItemNo: 1,
      ),
      CaseScore(
        scoreItemNo: 2,
      ),
      CaseScore(
        scoreItemNo: 3,
      ),
      CaseScore(
        scoreItemNo: 4,
      ),
      CaseScore(
        scoreItemNo: 5,
      ),
    ]);
  }

  Column buildCasesARemplir() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 5; i++) GameGridDropTarget(i),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 5; i < 10; i++) GameGridDropTarget(i),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 10; i < 15; i++) GameGridDropTarget(i),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 15; i < 20; i++) GameGridDropTarget(i),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 20; i < 25; i++) GameGridDropTarget(i),
          ],
        ),
      ],
    );
  }
}

class ClearButton extends StatefulWidget {
  const ClearButton({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openAlertBox();
      },
      child: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  openAlertBox() {
    var theme = Theme.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          var appState = context.watch<MyAppState>();
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.all(10.0),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Tout Effacer ?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 25,
                        color: theme.colorScheme.onBackground, // const Color(0xFFF64209),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                //SizedBox(height: 10),
                Image.asset(
                  "assets/nils.gif",
                ),
                //SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: Text(
                      "Oui",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 25,
                            color: theme.colorScheme.onPrimary, // const Color(0xFFF64209),
                            fontWeight: FontWeight.normal,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      appState.clearGrid();
                    }),
              ],
            ),
          );
        });
  }
}

class CaseScore extends StatefulWidget {
  final int scoreItemNo;
  const CaseScore({
    required this.scoreItemNo,
  });

  @override
  State<CaseScore> createState() => _CaseScoreState();
}

class _CaseScoreState extends State<CaseScore> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var screenAspectRatio = (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height);
    var gridSize = screenAspectRatio < 0.657
        ? ((MediaQuery.of(context).size.width) - 20) / 7
        : ((0.657 * (MediaQuery.of(context).size.height)) - 20) / 7;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color darkerBackground = isDarkMode
        ? Color.alphaBlend(Colors.white.withAlpha(0x15), Theme.of(context).colorScheme.primaryContainer)
        : Color.alphaBlend(Colors.black.withAlpha(0x15), Theme.of(context).colorScheme.primaryContainer);
    return SizedBox(
      height: gridSize,
      width: gridSize,
      child: Card(
          margin: EdgeInsets.all(2),
          color: widget.scoreItemNo == 12
              ? Theme.of(context).colorScheme.primary
              : (widget.scoreItemNo == 0 || widget.scoreItemNo == 6)
                  ? darkerBackground
                  : Theme.of(context).colorScheme.primaryContainer,
          child: FittedBox(
              child: appState.gameScore[widget.scoreItemNo] != 0
                  ? Text(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 25,
                            color: widget.scoreItemNo == 12
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                      appState.gameScore[widget.scoreItemNo].toString())
                  : Text(" "))),
    );
  }
}

class GameGridDropTarget extends StatefulWidget {
  final int itemNo;
  const GameGridDropTarget(
    this.itemNo,
  );

  @override
  State<GameGridDropTarget> createState() => _GameGridDropTargetState();
}

class _GameGridDropTargetState extends State<GameGridDropTarget> {
  int acceptedData = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var screenAspectRatio = (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height);
    var gridSize = screenAspectRatio < 0.657
        ? ((MediaQuery.of(context).size.width) - 20) / 7
        : ((0.657 * (MediaQuery.of(context).size.height)) - 20) / 7;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color darkerBackground = isDarkMode
        ? Color.alphaBlend(Colors.white.withAlpha(0x11), Theme.of(context).colorScheme.surface)
        : Color.alphaBlend(Colors.black.withAlpha(0x11), Theme.of(context).colorScheme.surface);
    return GestureDetector(
      onLongPress: () => [
        setState(() {
          acceptedData = 0;
        }),
        appState.updateScore(widget.itemNo, 0),
      ],
      child: DragTarget<int>(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return SizedBox(
            height: gridSize,
            width: gridSize,
            child: Card(
              margin: EdgeInsets.all(2.0),
              color: ((widget.itemNo == 4) ||
                      (widget.itemNo == 8) ||
                      (widget.itemNo == 12) ||
                      (widget.itemNo == 16) ||
                      (widget.itemNo == 20))
                  ? darkerBackground
                  : Theme.of(context).colorScheme.surface,
              child: FittedBox(
                child: Center(
                  child: /*acceptedData != 0
                        ? */
                      Image(
                    image: symbols[symbols.indexWhere((l) => l.id == appState.gameGrid[widget.itemNo])].myIconData,
                  ),
                ),
              ),
            ),
          );
        },
        onAccept: (int data) {
          if (appState.gameGrid[widget.itemNo] == 0) {
            setState(() {
              acceptedData = data;
            });
            appState.updateScore(widget.itemNo, data);
          }
        },
      ),
    );
  }
}

Offset dragAnchorStrategy(Draggable<Object> d, BuildContext context, Offset point) {
  return Offset(d.feedbackOffset.dx + 70, d.feedbackOffset.dy + 85);
}

class DraggableSymbol extends StatelessWidget {
  final Symbol localSymbol;
  DraggableSymbol({required this.localSymbol}); // valeur par défault

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Draggable<int>(
        // Data is the value this Draggable stores.
        dragAnchorStrategy: dragAnchorStrategy,
        data: localSymbol.id,
        feedback: Center(
          child: Transform.scale(
            scale: 0.5,
            alignment: Alignment.center,
            child: Image(
              image: localSymbol.myIconData,
            ),
          ),
        ),
        childWhenDragging: Center(
          child: Image(
            image: symbols[localSymbol.id + 6].myIconData,
          ),
        ),
        child: Center(
          child: Image(
            image: localSymbol.myIconData,
          ),
        ),
      ),
    );
  }
}
