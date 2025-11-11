import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'courier_searching_screen.dart';
import 'address_selection_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _notesController = TextEditingController();
  final _promoCodeController = TextEditingController();
  
  String _packageSize = 'medium';
  bool _isFragile = false;
  bool _promoCodeApplied = false;
  String? _promoCodeDiscount;

  @override
  void dispose() {
    _pickupController.dispose();
    _deliveryController.dispose();
    _notesController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _completeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Check if user is logged in
    if (!authProvider.isAuthenticated) {
      // Show login dialog
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to login to complete your order. Would you like to login now?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      );

      if (result == true && mounted) {
        // Navigate to login screen
        final loginResult = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        
        if (loginResult == true) {
          _proceedToSearch();
        }
      }
    } else {
      _proceedToSearch();
    }
  }

  void _proceedToSearch() {
    // Navigate to courier searching screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourierSearchingScreen(
          pickupAddress: _pickupController.text,
          deliveryAddress: _deliveryController.text,
          packageSize: _packageSize,
          isFragile: _isFragile,
          notes: _notesController.text,
        ),
      ),
    );
  }

  void _applyPromoCode() {
    final code = _promoCodeController.text.trim().toUpperCase();
    
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir promo kod girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Demo promo codes
    final Map<String, String> promoCodes = {
      'WELCOME10': '10%',
      'FASTLY20': '20%',
      'SAVE15': '15%',
      'FIRST50': '50%',
    };

    if (promoCodes.containsKey(code)) {
      setState(() {
        _promoCodeApplied = true;
        _promoCodeDiscount = promoCodes[code];
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo kod uygulandı! ${promoCodes[code]} indirim'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçersiz promo kod'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removePromoCode() {
    setState(() {
      _promoCodeApplied = false;
      _promoCodeDiscount = null;
      _promoCodeController.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Promo kod kaldırıldı'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        title: Text(l10n.createOrder),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pickup Address
                Text(
                  l10n.pickupAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pickupController,
                  readOnly: true,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddressSelectionScreen(
                          title: 'Select Pickup Location',
                        ),
                      ),
                    );
                    if (result != null && result is Map) {
                      setState(() {
                        _pickupController.text = result['address'];
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Tap to select pickup location',
                    prefixIcon: const Icon(Icons.location_on, color: Color(0xFF0081F2)),
                    suffixIcon: const Icon(Icons.map, color: Color(0xFF0081F2)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pickup address';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Delivery Address
                Text(
                  l10n.deliveryAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deliveryController,
                  readOnly: true,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddressSelectionScreen(
                          title: 'Select Delivery Location',
                        ),
                      ),
                    );
                    if (result != null && result is Map) {
                      setState(() {
                        _deliveryController.text = result['address'];
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Tap to select delivery location',
                    prefixIcon: const Icon(Icons.flag, color: Color(0xFF00B336)),
                    suffixIcon: const Icon(Icons.map, color: Color(0xFF00B336)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter delivery address';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Package Size
                Text(
                  l10n.packageSize,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PackageSizeCard(
                        icon: Icons.shopping_bag,
                        label: 'Small',
                        value: 'small',
                        groupValue: _packageSize,
                        onChanged: (value) => setState(() => _packageSize = value!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PackageSizeCard(
                        icon: Icons.backpack,
                        label: 'Medium',
                        value: 'medium',
                        groupValue: _packageSize,
                        onChanged: (value) => setState(() => _packageSize = value!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PackageSizeCard(
                        icon: Icons.inventory_2,
                        label: 'Large',
                        value: 'large',
                        groupValue: _packageSize,
                        onChanged: (value) => setState(() => _packageSize = value!),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Fragile Checkbox
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isFragile,
                        onChanged: (value) => setState(() => _isFragile = value!),
                        activeColor: const Color(0xFFFF6B35),
                      ),
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Fragile Item (Handle with care)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Notes
                const Text(
                  'Additional Notes (Optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add any special instructions...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Promo Code
                const Text(
                  'Promo Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _promoCodeController,
                        enabled: !_promoCodeApplied,
                        decoration: InputDecoration(
                          hintText: 'Enter promo code',
                          prefixIcon: const Icon(Icons.local_offer),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.green[300]!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _promoCodeApplied ? _removePromoCode : _applyPromoCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _promoCodeApplied ? Colors.red : const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(_promoCodeApplied ? 'Remove' : 'Apply'),
                    ),
                  ],
                ),
                if (_promoCodeApplied && _promoCodeDiscount != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Promo code applied! $_promoCodeDiscount discount',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Complete Order Button
                ElevatedButton(
                  onPressed: _completeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Complete Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PackageSizeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PackageSizeCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
