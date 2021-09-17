import 'package:drivers_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/AllScreeens/mainscreen.dart';
import 'package:drivers_app/AllScreeens/registrationScreen.dart';
import 'package:drivers_app/AllWidgets/progressDialog.dart';
import 'package:drivers_app/main.dart';


class LoginScreen extends StatelessWidget {

  static const String idScreen ="login";

  TextEditingController emailTextEditingController = TextEditingController();
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
              SizedBox(height: 45.0,),
              Image(
                  image:AssetImage("images/logo.png"),
                  width: 350.0,
                  height: 350.0,
                  alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text("Ingresa como conductor",
              style: TextStyle(fontSize: 24.0,fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),

                    TextField(
                      controller:emailTextEditingController,
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
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Contrase;a",
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
                        if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("El correo no es valido", context);
                        }else if(passwordTextEditingController.text.isEmpty) {
                          displayToastMessage("La contraseña es obligatoria", context);
                        }else
                        {
                          loginAndAuthenticateUser(context);
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
                            'Ingresar',
                            style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),

              // ignore: deprecated_member_use
              FlatButton(
                onPressed: ()
                {
                 Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                }
                ,
                child: Text(
                  "No tienes una Cuenta? Registrate aqui.",
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Estamos autenticando, por favor espera...",);
        }
    );

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    })).user;
    if(firebaseUser != null)
    {
      //save user info to database

      driversRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null)
        {
          currentfirebaseUser = firebaseUser;
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("Bienvenido! ", context);
        }
        else
          {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("No existe ningún registro para este usuario, por favor cree una nueva cuenta", context);
          }
      });

    }
    else{
      //error occured - display error msg
      Navigator.pop(context);
      displayToastMessage("Upss! No se ha creado una nueva cuenta de usuario ", context);
    }
  }
}
