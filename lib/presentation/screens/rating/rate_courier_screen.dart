import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class RateCourierScreen extends StatefulWidget {
  final String orderId;
  final String? courierName;

  const RateCourierScreen({
    super.key,
    required this.orderId,
    this.courierName,
  });

  @override
  State<RateCourierScreen> createState() => _RateCourierScreenState();
}

class _RateCourierScreenState extends State<RateCourierScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _commentController = TextEditingController();
  
  int _rating = 0;
  bool _isSubmitting = false;
  
  final List<String> _quickComments = [
    'Çok hızlıydı',
    'Güler yüzlü',
    'Profesyonel',
    'Siparişi özenle teslim etti',
    'İletişim iyiydi',
    'Zamanında geldi',
  ];
  
  final List<String> _selectedQuickComments = [];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir puan verin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Combine quick comments and custom comment
      String finalComment = _selectedQuickComments.join(', ');
      if (_commentController.text.isNotEmpty) {
        if (finalComment.isNotEmpty) {
          finalComment += '. ';
        }
        finalComment += _commentController.text;
      }

      await _apiService.rateCourier(
        widget.orderId,
        _rating,
        finalComment,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Değerlendirmeniz kaydedildi'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuryeyi Değerlendir'),
        backgroundColor: const Color(0xFFFF6B35),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Courier Avatar
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Courier Name
            Center(
              child: Text(
                widget.courierName ?? 'Kurye',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Hizmetimizi nasıl buldunuz?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Star Rating
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        size: 48,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            
            // Rating Text
            if (_rating > 0)
              Center(
                child: Text(
                  _getRatingText(_rating),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            
            // Quick Comments
            const Text(
              'Hızlı Yorumlar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickComments.map((comment) {
                final isSelected = _selectedQuickComments.contains(comment);
                return FilterChip(
                  label: Text(comment),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedQuickComments.add(comment);
                      } else {
                        _selectedQuickComments.remove(comment);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFFF6B35).withOpacity(0.2),
                  checkmarkColor: const Color(0xFFFF6B35),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFFFF6B35) : Colors.black87,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Custom Comment
            const Text(
              'Yorumunuz (Opsiyonel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Deneyiminizi bizimle paylaşın...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B35),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Gönder',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            
            // Skip Button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Şimdi Değil',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Çok Kötü';
      case 2:
        return 'Kötü';
      case 3:
        return 'Orta';
      case 4:
        return 'İyi';
      case 5:
        return 'Mükemmel';
      default:
        return '';
    }
  }
}
