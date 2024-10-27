import 'package:flutter/material.dart';

class DeviceResolution{

  static double getDeviceHeight(BuildContext context){
    return MediaQuery.sizeOf(context).height;
  }

  static double getDeviceWidth(BuildContext context){
    return MediaQuery.sizeOf(context).width;
  }
  
}