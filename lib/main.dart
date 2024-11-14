import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Implementação Integração Numérica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 235, 34, 34)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(width: 0.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(width: 1)),
        ),
      ),
      home: const MyHomePage(title: 'Integração Numérica'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController inferiorController = TextEditingController();
  TextEditingController superiorController = TextEditingController();
  TextEditingController intervalosController = TextEditingController();

  String? validateEmptyValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Valor não pode ser vazio';
    }
    try {
      double.parse(value);
    } catch (e) {
      return 'Valor inválido';
    }
    return null;
  }

  double trapezoidalIntegration(double Function(double) f, double a, double b, int n) {
    if (n <= 0) {
      throw ArgumentError("O número de subdivisões (n) deve ser maior que zero.");
    }

    final double h = (b - a) / n;
    double sum = 0.5 * (f(a) + f(b));

    for (int i = 1; i < n; i++) {
      double x = a + i * h;
      sum += f(x);
    }

    return sum * h;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String result = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: inferiorController,
                    decoration: const InputDecoration(label: Text("Limite inferior")),
                    validator: (value) => validateEmptyValue(value),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: superiorController,
                    decoration: const InputDecoration(label: Text("Limite superior")),
                    validator: (value) => validateEmptyValue(value),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: intervalosController,
                    decoration: const InputDecoration(label: Text("Qtde de subintervalos")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Valor não pode ser vazio';
                      }
                      try {
                        int parsedValue = int.parse(value);
                        if (parsedValue.isNegative) {
                          return 'Número de subdivisões não pode ser negativo.';
                        }
                      } catch (e) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(result, style: const TextStyle(color: Colors.black, fontSize: 22))
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              try {
                double f(double x) => (x * x) * sin(x);
                double a = double.parse(inferiorController.text);
                double b = double.parse(superiorController.text);
                int n = int.parse(intervalosController.text);
                double result = trapezoidalIntegration(f, a, b, n);
                setState(() {
                  this.result = result.toString();
                });
              } catch (e) {
                setState(() {
                  result = 'Erro ao converter valores. Por favor, verifique se os valores estão preenchidos corretamente.';
                  formKey.currentState!.validate();
                });
              }
            }
          },
          tooltip: 'Calcular',
          child: const Icon(Icons.calculate),
        ));
  }
}
