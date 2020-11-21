import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_management_app/service_layer/database.dart';
import 'package:time_management_app/shared/constants.dart';

//UniqueID Creator for Events
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class TrackerAdder extends StatefulWidget {
  TrackerAdder({Key key, this.userID, this.eventID}) : super(key: key);

  final String userID;
  final String eventID;

  @override
  _TrackerAdderState createState() => _TrackerAdderState();
}

class _TrackerAdderState extends State<TrackerAdder> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  // finals
  String eventName = "";
  String startingTime;
  String finishingTime = "";
  String duration = "";
  String date = "";

  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  // stopwatch
  bool flag = true;
  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  final TextEditingController _textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    // vertical divider
    _verticalDivider() => BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), 
              //gradient: greyGradient,
              color: Color(0xff979ca1)
              ),
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                        cursorColor: Colors.indigoAccent,
                        key: _formKey,
                        controller: _textEditingController,
                        onChanged: (value) {
                          setState(() {
                            eventName = value;
                          });
                        },
                        decoration: trackerAdderTextInputDecoration.copyWith(
                          hintText: "What are you working on ?",
                          // focusedBorder: OutlineInputBorder(
                          //     borderSide:
                          //         BorderSide(color: Colors.blueGrey, width: 2.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey, width: 0.5)),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          //decoration: _verticalDivider(),
                          child: RawMaterialButton(
                            child: Text("\$"),
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w200,
                                fontSize: 25),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                "${hoursStr}:${minutesStr}:${secondsStr}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            timerStream == null
                                ? Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        // Start Button
                                        child: InkWell(
                                          child: Text(
                                            'START',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () {
                                            startingTime = DateFormat.Hm()
                                                .format(DateTime.now());
                                            FocusScope.of(context).unfocus();
                                            timerStream = stopWatchStream();
                                            timerSubscription = timerStream
                                                .listen((int newTick) {
                                              setState(() {
                                                hoursStr =
                                                    ((newTick / (60 * 60)) % 60)
                                                        .floor()
                                                        .toString()
                                                        .padLeft(2, '0');
                                                minutesStr =
                                                    ((newTick / 60) % 60)
                                                        .floor()
                                                        .toString()
                                                        .padLeft(2, '0');
                                                secondsStr = (newTick % 60)
                                                    .floor()
                                                    .toString()
                                                    .padLeft(2, '0');
                                                print(startingTime);
                                                print(finishingTime);
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      MaterialButton(
                                          minWidth: 0,
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {},
                                          child: Icon(Icons.more_vert)),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        // Stop Button
                                        child: InkWell(
                                          child: Text(
                                            'STOP',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          onTap: () async {
                                            await timerSubscription.cancel();
                                            timerStream = null;
                                            setState(() {
                                              _textEditingController.clear();
                                              duration =
                                                  "${hoursStr}:${minutesStr}:${secondsStr}";

                                              date = "${DateFormat("d")
                                                  .format(DateTime.now())}/${DateFormat("M")
                                                  .format(DateTime.now())}/${DateFormat("y")
                                                  .format(DateTime.now())}";
                                              //print(eventName);

                                              hoursStr = '00';
                                              minutesStr = '00';
                                              secondsStr = '00';
                                            });
                                            finishingTime = DateFormat.Hm()
                                                .format(DateTime.now());

                                            DatabaseService().updateTrackersData(
                                              startingTime,
                                              finishingTime,
                                              eventName,
                                              date,
                                              duration,
                                              widget.userID,
                                              uuid.v1(),
                                              Timestamp.now(),
                                            );
                                          },
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: 0,
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {},
                                        child: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
