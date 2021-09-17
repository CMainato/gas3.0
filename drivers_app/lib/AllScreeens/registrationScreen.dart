import 'package:drivers_app/AllScreeens/carInfoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:drivers_app/AllScreeens/loginScreen.dart';
import 'package:drivers_app/AllScreeens/mainscreen.dart';
import 'package:drivers_app/AllWidgets/progressDialog.dart';
import 'package:drivers_app/main.dart';

import '../configMaps.dart';


class RegistrationScreen extends StatelessWidget {

  static const String idScreen ="registrar";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Image(
                image:AssetImage("images/logo.png"),
                width: 350.0,
                height: 350.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text("Registrate como conductor",
                style: TextStyle(fontSize: 24.0,fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),

                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Correo",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),

                    ),


                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Celular",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),

                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),

                    ),


                    SizedBox(height: 30.0,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),

                      onPressed: () {
                        if(nameTextEditingController.text.length < 3)
                        {
                          displayToastMessage("El nombre debe tener al menos 3 caracteres.", context);
                        }
                        else if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("El correo no es valido", context);
                        }else if(phoneTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("El número de teléfono es obligatorio", context);
                        }else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage("La contraseña debe tener al menos 6 caracteres.", context);
                        }else{
                          registerNewUser(context);
                        }
                      },
                      child: Ink
                        (decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.black, Colors.green]),
                          borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          width: 300,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Crear cuenta',
                            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                }
                ,
                child: Text(
                  "Ya tines una Cuenta? Ingresa aqui.",
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Estamos registrando tu cuenta, por favor espera...",);
        }
    );

    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null)
      {
        //save user info to database

        Map userDataMap = {
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),

        };

        driversRef.child(firebaseUser.uid).set(userDataMap);

        currentfirebaseUser = firebaseUser;
        displayToastMessage("Felicidades, Ahora eres parte de Gas.SA. Cuenta  creada! ", context);


        Navigator.pushNamed(context, CarInfoScreen.idScreen);
        
      }
    else{
      Navigator.pop(context);
      //error occured - display error msg
      displayToastMessage("Nuevo usuario no creado", context);
    }

  }

}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
