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
@override
  void dispose() {
    _inputController.dispose();
    _ratioDoseController.dispose();
    _ratioWaterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Base background
      body: SafeArea(
        child: Container(
          // Subtle elegant background gradient
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F7F4), Color(0xFFE8EFE7)],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'AgriCalc',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Categories
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _categories.map((category) {
                              bool isSelected = _selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) _onCategoryChanged(category);
                                  },
                                  showCheckmark: false,
                                  selectedColor: const Color(0xFF2E7D32),
                                  backgroundColor: Colors.white,
                                  elevation: isSelected ? 4 : 0,
                                  shadowColor: const Color(0xFF2E7D32).withOpacity(0.3),
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                         const SizedBox(height: 32),
                        
                        // Main Content Area (Dynamic based on state)
                        if (_selectedCategory == null)
                          _buildEmptyState()
                        else
                          _buildCalculatorContent(),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom AdMob Placeholder Banner
              _buildAdBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildIllustrationPlaceholder(),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Highlight the first category automatically
              _onCategoryChanged('Luas Lahan');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Pill shaped button
              ),
              elevation: 6,
              shadowColor: const Color(0xFF2E7D32).withOpacity(0.4),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF388E3C), Color(0xFF1B5E20)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                alignment: Alignment.center,
                child: const Text(
                  'Pilih Kategori',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
Widget _buildIllustrationPlaceholder() {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative background circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),
          // Center Farmer
          const Icon(Icons.nature_people_outlined, size: 100, color: Color(0xFF1B5E20)),
          // Surrounding tool icons
          Positioned(
            top: 40,
            left: 50,
            child: Icon(Icons.calculate_outlined, size: 36, color: const Color(0xFF2E7D32)),
          ),
          Positioned(
            bottom: 40,
            right: 50,
            child: Icon(Icons.scale_outlined, size: 36, color: const Color(0xFF2E7D32)),
          ),
          Positioned(
            top: 50,
            right: 60,
            child: Icon(Icons.bar_chart, size: 36, color: const Color(0xFF2E7D32)),
          ),
          Positioned(
            bottom: 60,
            left: 60,
            child: Icon(Icons.speed_outlined, size: 36, color: const Color(0xFF2E7D32)),
          ),
          // A few connecting dots/lines (simplified as small dots)
          Positioned(top: 100, left: 100, child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle))),
          Positioned(bottom: 90, right: 110, child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle))),
          Positioned(top: 80, right: 100, child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle))),
        ],
      ),
    );
  }
Widget _buildAdBanner() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 6, top: 8,
                child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(4))),
              ),
              Positioned(
                right: 6, bottom: 8,
                child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.circular(4))),
              ),
              Positioned(
                left: 8, bottom: 6,
                child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.yellow.shade600, shape: BoxShape.circle)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorContent() {
    return Column(
      children: [
        // Input Card
        _buildInputCard(),