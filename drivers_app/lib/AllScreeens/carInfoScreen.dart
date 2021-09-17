import 'package:drivers_app/AllScreeens/mainscreen.dart';
import 'package:drivers_app/AllScreeens/registrationScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:flutter/material.dart';

class CarInfoScreen extends StatelessWidget
{
  static const String idScreen = "carinfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("images/logo.png", width: 390.0, height: 250.0,),
              Padding(
                  padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Ingrese los detalles del auto", style: TextStyle(fontFamily: "Brand-Blod", fontSize: 24.0),),

                    SizedBox(height: 26.0,),
                    TextField(
                      controller: carModelTextEditingController,
                        decoration: InputDecoration(
                          labelText:  "Modelo del auto",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                        ),
                        style: TextStyle(fontSize:15.0),
                      ),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carNumberTextEditingController,
                      decoration: InputDecoration(
                        labelText:  "Numero del auto",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize:15.0),
                    ),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carColorTextEditingController,
                      decoration: InputDecoration(
                        labelText:  "Color del auto",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                      style: TextStyle(fontSize:15.0),
                    ),

                    SizedBox(height: 42.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: ()
                        {
                          if(carModelTextEditingController.text.isEmpty)
                            {
                              displayToastMessage("Por favor ingrese el model del auto", context);
                            }
                          if(carNumberTextEditingController.text.isEmpty)
                          {
                            displayToastMessage("Por favor ingrese el numero del auto", context);
                          }
                          if(carColorTextEditingController.text.isEmpty)
                          {
                            displayToastMessage("Por favor ingrese el color del auto", context);
                          }
                          else
                            {
                              saveDriverCarInfo(context);
                            }

                        },
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Siguiente", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white ),),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 26.0,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context)
  {
    String userId = currentfirebaseUser.uid;

    Map carInfoMap =
        {
          "car_color": carColorTextEditingController.text,
          "car_number": carNumberTextEditingController.text,
          "car_model": carModelTextEditingController.text,
        };

    driversRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
}