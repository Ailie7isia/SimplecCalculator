import 'package:calculator/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  String number1 ="";
  String operand ="";
  String number2 ="";

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
       color: const Color.fromARGB(255,227,105,105),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  color: const Color.fromARGB(255,227,105,105),
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "$number1$operand$number2".isEmpty?"0"
                    : "$number1$operand$number2", 
                  style: const  TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
          //BUTTONS
          
          Wrap(
            children: Button.buttonValues.map(
              (value) => SizedBox(
                width: value==Button.n0?screenSize.width/2 :
                (screenSize.width/4),
                height: screenSize.width/5,
                child: buildButton(value)),
              ).toList(),
          )
         //button
          ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(value) {
    Color textColor = Colors.white;
      if (int.tryParse(value.toString()) != null) {
      textColor = const Color.fromARGB(255,137,103,103); 
    }
    
    if (value == ".") {
      textColor = const Color.fromARGB(255,137,103,103); 
    }

      return Material(
        color: getButtonColor(value),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(
            color: Colors.white10,
          )
        ),
        
        child: InkWell(
          onTap: () => ButtonTap(value),
          child: Center(
            child: Text(
              value,
               style: TextStyle(
                color: textColor,
                 fontWeight: FontWeight.bold,
              ),
            )
          )
        ),
      );
    }

    void ButtonTap(String value){
      if (value==Button.del){
        delete();
        return;
      }
      
      if (value == Button.clr) {
      clearAll();
      return;
    }

    if (value == Button.per) {
      percentage();
      return;
    }

    if (value == Button.calculate) {
      calculate();
      return;
    }

      appendValue(value);
    }

    void delete() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
        if (number2.isEmpty) {
          operand = "";
        }
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }

      setState(() {});
    }

    void appendValue (String value) {
      if (value!=Button.dot&&int.tryParse(value)==null) {
        if(operand.isNotEmpty&&number2.isNotEmpty){
          //CALCULATE
          calculate();
        }
        operand = value;
      } else if (number1.isEmpty || operand.isEmpty){ //CHECK NUMBER1
          if (value==Button.dot && number1.contains(Button.dot)) return;
          if (value==Button.dot && number1.isEmpty || number1==Button.n0) {
            value = "0.";
          }
          number1 += value;
      } else if (number2.isEmpty || operand.isEmpty){ //CHECK NUMBER2
          if (value==Button.dot && number2.contains(Button.dot)) return;
          if (value==Button.dot && number2.isEmpty || number2==Button.n0) {
            value = "0.";
          }
          number2 += value;
      }
   setState(() {});
}

  Color getButtonColor(value) {
    return  [
      Button.divide, 
      Button.multiply, 
      Button.subtract, 
      Button.add, 
      ].contains(value)? const Color.fromARGB(255,204,113,111)
    : [
      Button.calculate
    ].contains(value)? const Color.fromARGB(255, 225,184,107) 
    : [
      Button.clr,
      Button.per,
      Button.del,
    ].contains(value)? const Color.fromARGB(255, 211, 181, 181) :
    const Color.fromARGB(255, 247, 240, 238);
  }
  
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }
  
  void percentage() {
    if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
      
    }

    if(operand.isNotEmpty){
      return; //Can't convert non-number
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }
  
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;

    switch(operand){
      case Button.add:
        result = num1 + num2;
        break;
      case Button.subtract:
        result = num1 - num2;
        break;
      case Button.multiply:
        result = num1 * num2;
        break;
      case Button.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = result.toStringAsPrecision(3);

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }
}