import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/pages/add_medicine_page.dart';

import '../../data/model/medicine.dart';

class MedicinePage extends StatelessWidget {
  const MedicinePage({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    LocalDataBloc localDataBloc = BlocProvider.of<LocalDataBloc>(context);
    return Scaffold(
        body: SafeArea(
            child: DefaultTextStyle(
                style: TextStyle(fontSize: 16, color: Colors.black),
                child: CustomScrollView(slivers: [
                  SliverPersistentHeader(
                    delegate: MySliverAppBar(
                        expandedHeight: 280,
                        medicine: localDataBloc.medicines[index]),
                    pinned: true,
                  ),
                  SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      sliver: SliverList.list(children: [
                        localDataBloc.medicines[index].comment == null
                            ? SizedBox.shrink()
                            : Container(
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Комментарий:',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(localDataBloc
                                              .medicines[index].comment!),
                                        ]))),
                        localDataBloc.medicines[index].comment == null
                            ? SizedBox.shrink()
                            : SizedBox(
                                height: 15,
                              ),
                        Container(
                            color: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                          Text('График приема'),
                                          SizedBox(
                                            height: 15,
                                          )
                                        ] +
                                        List.generate(
                                            localDataBloc
                                                .medicines[index].doses.length,
                                            (index1) => Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Row(
                                                          children: [
                                                            Text(localDataBloc
                                                                .medicines[
                                                                    index]
                                                                .doses[index1]
                                                                .getTime()),
                                                            Spacer(),
                                                            Text(
                                                                '${localDataBloc.medicines[index].doses[index1].dosage} ${localDataBloc.medicines[index].unit}')
                                                          ],
                                                        )),
                                                    localDataBloc
                                                                    .medicines[
                                                                        index]
                                                                    .doses
                                                                    .length -
                                                                1 ==
                                                            index1
                                                        ? SizedBox.shrink()
                                                        : Divider()
                                                  ],
                                                ))))),
                        SizedBox(
                          height: 15,
                        ),
                        localDataBloc.medicines[index].startTreatment == null
                            ? SizedBox.shrink()
                            : Container(
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Длительность курса'),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'От: ',
                                                    ),
                                                    TextSpan(
                                                        text: DateFormat(
                                                                'y/M/d')
                                                            .format(localDataBloc
                                                                .medicines[
                                                                    index]
                                                                .startTreatment!),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'До: ',
                                                    ),
                                                    TextSpan(
                                                        text: DateFormat(
                                                                'y/M/d')
                                                            .format(localDataBloc
                                                                .medicines[
                                                                    index]
                                                                .endTreatment!),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])))
                      ]))
                ]))));
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double kToolbarHeight = 75;
  final Medicine medicine;
  MySliverAppBar({required this.expandedHeight, required this.medicine});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(children: [
      Expanded(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
              decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(160)),
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          )),
          Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Opacity(
                          opacity: shrinkOffset < 100
                              ? 1
                              : shrinkOffset > 300
                                  ? 0
                                  : (expandedHeight - shrinkOffset) /
                                      expandedHeight,
                          child: Image.asset(
                            'assets/pill2.png',
                            width: 200,
                            height: 200,
                          ))),
                  Text(
                    medicine.name,
                    style: TextStyle(
                      fontSize: (15 * shrinkOffset / 100) < 16
                          ? 16
                          : (16 * shrinkOffset / 100) > 22
                              ? 22
                              : 16 * shrinkOffset / 100,
                      color: Colors.white,
                    ),
                  ),
                  medicine.remains == null
                      ? SizedBox.shrink()
                      : Text(
                          'Осталось ${medicine.remains} ${medicine.unit}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ],
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: IconButton.filledTonal(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) =>
                                const AddMedicinePage()));
                      },
                      icon: Icon(Icons.edit))))
        ],
      )),
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
