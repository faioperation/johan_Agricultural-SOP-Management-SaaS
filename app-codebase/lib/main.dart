import 'package:farm_check_support/app/app.dart';
import 'package:farm_check_support/app/controller_binding.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();
  runApp(const FarmCheckSupport());
}

