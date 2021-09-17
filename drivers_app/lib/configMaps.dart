/*String mapKey ="AIzaSyAXPskuIBK98iX8-6NuPCmtMItixdjRfgQ";*/
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey ="AIzaSyBGCJr3ayZ3-2lNbYrmkieT4Oj7JCxDUZo";

User firebaseUser;
Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubcriptor;