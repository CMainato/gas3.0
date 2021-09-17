import 'package:drivers_app/tabsPages/earningsTabPage.dart';
import 'package:drivers_app/tabsPages/homeTabPage.dart';
import 'package:drivers_app/tabsPages/profileTapPage.dart';
import 'package:drivers_app/tabsPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget
{

  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{
  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index)
  {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState(){
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose(){
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Inicio"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: "Ganancias"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Clacificaciones"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Cuenta"
          ),

        ],
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),

    );
  }
}


