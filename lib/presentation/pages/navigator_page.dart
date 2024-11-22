import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_state.dart';
import 'package:med_hackton/presentation/pages/add_medicine_page.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:med_hackton/presentation/pages/home_page.dart';
import 'package:med_hackton/presentation/pages/medicines_list_page.dart';
import '../widgets/dose_active_dialog.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NavigatorPage>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.pink
  ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 2, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = Colors.black;
    final Color unselectedColorReverse =
        colors[currentPage].computeLuminance() < 0.5
            ? Colors.white
            : Colors.black;

    return BlocBuilder<LocalDataBloc, LocalDataState>(
        builder: (context, state) {
      LocalDataBloc localDataBloc = BlocProvider.of<LocalDataBloc>(context);
      return Scaffold(
          appBar: AppBar(
            title: Text('Главное меню'),
          ),
          body: BottomBar(
              clip: Clip.none,
              fit: StackFit.expand,
              borderRadius: BorderRadius.circular(500),
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
              showIcon: true,
              width: MediaQuery.of(context).size.width * 0.9,
              barColor: Colors.white,
              start: 2,
              end: 0,
              offset: 20,
              barAlignment: Alignment.bottomCenter,
              iconHeight: 30,
              iconWidth: 30,
              reverse: false,
              hideOnScroll: true,
              scrollOpposite: false,
              onBottomBarHidden: () {},
              onBottomBarShown: () {},
              body: (context, controller) => TabBarView(
                      controller: tabController,
                      dragStartBehavior: DragStartBehavior.down,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        HomePage(context, localDataBloc),
                        const MedicinesPage()
                      ]),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  TabBar(
                    indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    controller: tabController,
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: currentPage <= 4
                              ? colors[currentPage]
                              : unselectedColor,
                          width: 4,
                        ),
                        insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
                    tabs: [
                      SizedBox(
                        height: 55,
                        width: 40,
                        child: Center(
                            child: Icon(
                          Icons.home,
                          color: currentPage == 0 ? colors[0] : unselectedColor,
                        )),
                      ),
                      SizedBox(
                        height: 55,
                        width: 40,
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color:
                                currentPage == 1 ? colors[1] : unselectedColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -25,
                    child: SpeedDial(
                        childrenButtonSize: Size(200, 50),
                        renderOverlay: false,
                        icon: Icons.add,
                        activeIcon: Icons.close,
                        direction: SpeedDialDirection.up,
                        children: <SpeedDialChild>[
                          SpeedDialChild(
                            //shape: const CircleBorder(eccentricity: 1),
                            child: Text('Добавить врача'),

                            onTap: () {},
                          ),
                          SpeedDialChild(
                            //shape: const CircleBorder(eccentricity: 1),
                            child: Text('Замерить вес'),
                            onTap: () {},
                          ),
                          SpeedDialChild(
                            //shape: const CircleBorder(eccentricity: 1),
                            child: Text('Замерить пульс'),

                            onTap: () {},
                          ),
                          SpeedDialChild(
                            //shape: const CircleBorder(eccentricity: 1),
                            child: Text('Добавить дозу'),

                            onTap: () {},
                          ),
                        ]),
                  )
                ],
              )));
    });
  }
}
