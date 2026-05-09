import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriCalc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          background: const Color(0xFFF2F5F1),
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const AgriCalcMainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AgriCalcMainScreen extends StatefulWidget {
  const AgriCalcMainScreen({super.key});

  @override
  State<AgriCalcMainScreen> createState() => _AgriCalcMainScreenState();
}

class _AgriCalcMainScreenState extends State<AgriCalcMainScreen> {
  // Start with null to show the empty state
  String? _selectedCategory;
  final List<String> _categories = ['Luas Lahan', 'Takaran Pupuk', 'Berat Panen'];

  String _fromUnit = 'Hektar (ha)';
  String _toUnit = 'Bahu';
  final TextEditingController _inputController = TextEditingController(text: '');
  
  // Ratio Feature Controllers
  final TextEditingController _ratioDoseController = TextEditingController(text: '2');
  final TextEditingController _ratioWaterController = TextEditingController(text: '1');
  
  double _outputValue = 0;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_calculate);
    _ratioDoseController.addListener(() => setState(() {}));
    _ratioWaterController.addListener(() => setState(() {}));
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'Luas Lahan') {
        _fromUnit = 'Hektar (ha)';
        _toUnit = 'Bahu';
        _inputController.text = '1.5';
      } else if (category == 'Takaran Pupuk') {
        _fromUnit = 'Sendok Makan (sdm)';
        _toUnit = 'Mililiter (mL / cc)';
        _inputController.text = '5';
      } else if (category == 'Berat Panen') {
        _fromUnit = 'Ton';
        _toUnit = 'Kilogram (kg)';
        _inputController.text = '1';
      }
      _calculate();
    });
  }

  void _calculate() {
    setState(() {
      double? input = double.tryParse(_inputController.text);
      if (input != null) {
        if (_selectedCategory == 'Luas Lahan') {
          if (_fromUnit == 'Hektar (ha)' && _toUnit == 'Bahu') {
            _outputValue = input * 7.06;
          } else if (_fromUnit == 'Hektar (ha)' && _toUnit == 'Meter Persegi (m2)') {
            _outputValue = input * 10000;
          } else if (_fromUnit == 'Bahu' && _toUnit == 'Hektar (ha)') {
            _outputValue = input / 7.06;
          } else {
            _outputValue = input;
          }
        } else if (_selectedCategory == 'Takaran Pupuk') {
          if (_fromUnit == 'Sendok Makan (sdm)' && _toUnit == 'Mililiter (mL / cc)') {
            _outputValue = input * 15; // 1 sdm = 15 mL
          } else if (_fromUnit == 'Mililiter (mL / cc)' && _toUnit == 'Liter (L)') {
            _outputValue = input / 1000;
          } else {
            _outputValue = input;
          }
        } else {
          _outputValue = input;
        }
      } else {
        _outputValue = 0;
      }
    });
  }

  String _calculateKebutuhan() {
    double? dose = double.tryParse(_ratioDoseController.text);
    double? water = double.tryParse(_ratioWaterController.text);
    double tank = 17.0; // Assume 17L tank
    
    if (dose != null && water != null && water > 0) {
      double result = (dose / water) * tank;
      return result.toStringAsFixed(0);
    }
    return '0';
  }

  List<String> get _currentInputUnits {
    if (_selectedCategory == 'Luas Lahan') {
      return ['Hektar (ha)', 'Bahu', 'Meter Persegi (m2)'];
    } else if (_selectedCategory == 'Takaran Pupuk') {
      return ['Sendok Makan (sdm)', 'Gram (g)', 'Mililiter (mL / cc)'];
    } else {
      return ['Ton', 'Kilogram (kg)', 'Kuintal'];
    }
  }

  List<String> get _currentOutputUnits {
    if (_selectedCategory == 'Luas Lahan') {
      return ['Hektar (ha)', 'Bahu', 'Meter Persegi (m2)'];
    } else if (_selectedCategory == 'Takaran Pupuk') {
      return ['Mililiter (mL / cc)', 'Liter (L)', 'Sendok Makan (sdm)'];
    } else {
      return ['Kilogram (kg)', 'Gram (g)', 'Ton'];
    }
  }
