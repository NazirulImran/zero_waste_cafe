import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/food_item.dart';

class AddFoodModal extends StatefulWidget {
  const AddFoodModal({super.key});

  @override
  State<AddFoodModal> createState() => _AddFoodModalState();
}

class _AddFoodModalState extends State<AddFoodModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController(); // New Controller

  String _selectedCafe = 'Kafe Limbong';
  String _selectedCategory = 'Malaysian';
  
  // Free Item Logic
  bool _isFree = false;

  // Time Selection State
  String _startHour = '1';
  String _startAmPm = 'PM';
  String _endHour = '2';
  String _endAmPm = 'PM';

  final List<String> _hours = List.generate(12, (index) => (index + 1).toString());
  final List<String> _amPm = ['AM', 'PM'];

  final List<String> _cafes = [
    'Kafe Limbong',
    'Kafe KKSAM',
    'Bus Stop Belakang UMT',
    'Kafe Kompleks Kuliah',
    'Kedai Bawah FSKM',
  ];

  final List<String> _categories = [
    'Malaysian',
    'Asian',
    'Western',
    'Indonesian',
    'Breakfast',
    'Drinks',
    'Desserts',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _quantityController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);

      // Construct the pickup time string (e.g., "1:00 PM - 2:00 PM")
      final String formattedPickupTime = 
          "$_startHour:00 $_startAmPm - $_endHour:00 $_endAmPm";

      // Handle Free Logic
      final double finalDiscountedPrice = _isFree 
          ? 0.0 
          : double.parse(_discountedPriceController.text);

      final newItem = FoodItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        cafe: _selectedCafe,
        originalPrice: double.parse(_originalPriceController.text),
        discountedPrice: finalDiscountedPrice,
        pickupTime: formattedPickupTime,
        category: _selectedCategory,
        imageUrl: _imageUrlController.text,
        availableQuantity: int.parse(_quantityController.text),
        description: _descriptionController.text, // Save description
      );

      appState.addFoodItem(newItem);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food item added successfully!'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Surplus Food',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- 1. Basic Info ---
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Food Name *',
                      hintText: 'e.g., Nasi Lemak Bunian',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _selectedCafe,
                    decoration: const InputDecoration(
                      labelText: 'Café Location *',
                      border: OutlineInputBorder(),
                    ),
                    items: _cafes.map((cafe) {
                      return DropdownMenuItem(value: cafe, child: Text(cafe));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedCafe = value!),
                  ),
                  const SizedBox(height: 16),

                  // --- 2. Free Option Checkbox ---
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFDCFCE7)),
                    ),
                    child: CheckboxListTile(
                      value: _isFree,
                      onChanged: (bool? value) {
                        setState(() {
                          _isFree = value ?? false;
                          if (_isFree) {
                            _discountedPriceController.clear();
                          }
                        });
                      },
                      title: const Text("Offer this food for free"),
                      activeColor: const Color.fromARGB(255, 22, 180, 80),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- 3. Prices ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _originalPriceController,
                          decoration: const InputDecoration(
                            labelText: 'Original Price (RM) *',
                            hintText: '0.00',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Only show Discounted Price if NOT free
                      if (!_isFree)
                        Expanded(
                          child: TextFormField(
                            controller: _discountedPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Discounted Price (RM) *',
                              hintText: '0.00',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (_isFree) return null;
                              if (value == null || value.isEmpty) return 'Required';
                              return null;
                            },
                          ),
                        )
                      else
                        // Placeholder to keep alignment when hidden
                        const Expanded(child: SizedBox()), 
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- 4. Quantity ---
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity Available *',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),

                  // --- 5. Pickup Time (Double Dropdown Layout) ---
                  const Text(
                    "Pickup Time *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // FROM TIME
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("From", style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimeDropdown(
                                    _hours, _startHour, 
                                    (val) => setState(() => _startHour = val!)
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildTimeDropdown(
                                    _amPm, _startAmPm, 
                                    (val) => setState(() => _startAmPm = val!)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // "To" Separator
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        child: Text("to", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),

                      // TO TIME
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("To", style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimeDropdown(
                                    _hours, _endHour, 
                                    (val) => setState(() => _endHour = val!)
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildTimeDropdown(
                                    _amPm, _endAmPm, 
                                    (val) => setState(() => _endAmPm = val!)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- 6. Image URL ---
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL (Optional)',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- 7. Description (New Field) ---
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3, // Makes it a larger text area
                    decoration: const InputDecoration(
                      labelText: 'Food Description (Optional)',
                      hintText: 'e.g., Contains nuts, spicy, made this morning...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Submit Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add Food Item',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper for consistent dropdown styling
  Widget _buildTimeDropdown(
      List<String> items, String value, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11), // Reduced padding slightly
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          // 1. Add 'isDense' to compact the layout
          isDense: true, 
          // 2. Set the style for the SELECTED item text
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13, // <--- Smaller font size (try 12 or 13)
            fontWeight: FontWeight.w500,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              // 3. Set the style for the MENU items text
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13, // <--- Match the size here
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}