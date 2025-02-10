import 'package:flutter/material.dart';

class AddTransactionsPage extends StatefulWidget {
  @override
  _AddTransactionsPageState createState() => _AddTransactionsPageState();
}

class _AddTransactionsPageState extends State<AddTransactionsPage> {
  bool _ingreso = true;
  String _monedaSeleccionada = 'USD'; // Valor inicial de la moneda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 219, 219, 219),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Agregar transaccion",
                      style: TextStyle(
                        fontSize: 18,
                        
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _ingreso = true;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                color: _ingreso
                                    ? Colors.green.withOpacity(0.7)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Ingreso',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                      
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _ingreso = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                color: !_ingreso
                                    ? Colors.red.withOpacity(0.7)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Gasto',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  Center(
                  
                   child: 
                   Padding(
                     padding: const EdgeInsets.only(top: 10.0),
                     child: Text(
                      "Monto"
                      ,style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                   )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(!_ingreso ? " -" : "+",
                          style: TextStyle(fontSize: 35)),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: SizedBox(
                          width: 120,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: const Color.fromARGB(255, 191, 191, 191)),
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  double.tryParse(value) == null) {
                                return "Ingrese un número válido";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _monedaSeleccionada,
                        onChanged: (String? newValue) {
                          setState(() {
                            _monedaSeleccionada = newValue!;
                          });
                        },
                        items: <String>['USD', 'EUR']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}