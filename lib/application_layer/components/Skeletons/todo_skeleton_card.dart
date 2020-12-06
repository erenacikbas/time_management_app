import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:time_management_app/shared/constants.dart';

class TodoCardSkeleton extends StatelessWidget {
  const TodoCardSkeleton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)),
                  color: Colors.white70),
              child: Container(
                height: 85,
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment:
                      MainAxisAlignment.start,
                  children: <Widget>[
                    // SkeletonAnimation(
                    //   child: Container(
                    //     width: 70.0,
                    //     height: 70.0,
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey[300],
                    //     ),
                    //   ),
                    // ),
                    Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(
                                  left: 15.0,
                                  bottom: 5.0),
                          child: SkeletonAnimation(
                            child: Container(
                              height: 15,
                              width:
                                  MediaQuery.of(context)
                                          .size
                                          .width *
                                      0.6,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              10.0),
                                  color:
                                      Colors.grey[300]),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(
                                  left: 15.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(
                                    right: 5.0),
                            child: SkeletonAnimation(
                              child: Container(
                                width: 60,
                                height: 13,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                10.0),
                                    color: Colors
                                        .grey[300]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: 5,
      ),
    );
  }
}

