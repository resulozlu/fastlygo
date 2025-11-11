import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedLanguage = 'tr';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
      _smsNotifications = prefs.getBool('sms_notifications') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'tr';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: const Color(0xFFFF6B35),
      ),
      body: ListView(
        children: [
          // Notifications Section
          _buildSectionHeader('Bildirimler'),
          _buildSwitchTile(
            title: 'Bildirimleri Aç',
            subtitle: 'Tüm bildirimleri al',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _saveSetting('notifications_enabled', value);
            },
            icon: Icons.notifications,
          ),
          if (_notificationsEnabled) ...[
            _buildSwitchTile(
              title: 'E-posta Bildirimleri',
              subtitle: 'Sipariş güncellemelerini e-posta ile al',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
                _saveSetting('email_notifications', value);
              },
              icon: Icons.email,
              indent: true,
            ),
            _buildSwitchTile(
              title: 'SMS Bildirimleri',
              subtitle: 'Önemli güncellemeleri SMS ile al',
              value: _smsNotifications,
              onChanged: (value) {
                setState(() {
                  _smsNotifications = value;
                });
                _saveSetting('sms_notifications', value);
              },
              icon: Icons.sms,
              indent: true,
            ),
            _buildSwitchTile(
              title: 'Ses',
              subtitle: 'Bildirim sesi çal',
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                _saveSetting('sound_enabled', value);
              },
              icon: Icons.volume_up,
              indent: true,
            ),
            _buildSwitchTile(
              title: 'Titreşim',
              subtitle: 'Bildirimde titreşim',
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _vibrationEnabled = value;
                });
                _saveSetting('vibration_enabled', value);
              },
              icon: Icons.vibration,
              indent: true,
            ),
          ],

          const Divider(height: 32),

          // Language Section
          _buildSectionHeader('Dil'),
          _buildLanguageTile(),

          const Divider(height: 32),

          // Account Section
          _buildSectionHeader('Hesap'),
          _buildTile(
            title: 'Kayıtlı Adresler',
            subtitle: 'Sık kullanılan adreslerinizi yönetin',
            icon: Icons.location_on,
            onTap: () {
              // Navigate to saved addresses
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kayıtlı adresler yakında eklenecek')),
              );
            },
          ),
          _buildTile(
            title: 'Ödeme Yöntemleri',
            subtitle: 'Kredi kartlarınızı yönetin',
            icon: Icons.credit_card,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ödeme yöntemleri yakında eklenecek')),
              );
            },
          ),

          const Divider(height: 32),

          // Support Section
          _buildSectionHeader('Destek'),
          _buildTile(
            title: 'Yardım Merkezi',
            subtitle: 'Sıkça sorulan sorular',
            icon: Icons.help,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Yardım merkezi yakında eklenecek')),
              );
            },
          ),
          _buildTile(
            title: 'İletişim',
            subtitle: 'Bizimle iletişime geçin',
            icon: Icons.contact_support,
            onTap: () {
              _showContactDialog();
            },
          ),

          const Divider(height: 32),

          // About Section
          _buildSectionHeader('Hakkında'),
          _buildTile(
            title: 'Kullanım Koşulları',
            icon: Icons.description,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kullanım koşulları yakında eklenecek')),
              );
            },
          ),
          _buildTile(
            title: 'Gizlilik Politikası',
            icon: Icons.privacy_tip,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gizlilik politikası yakında eklenecek')),
              );
            },
          ),
          _buildTile(
            title: 'Uygulama Hakkında',
            subtitle: 'Versiyon 14.3.0',
            icon: Icons.info,
            onTap: () {
              _showAboutDialog();
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF6B35),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    bool indent = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(indent ? 32 : 16, 8, 16, 8),
      leading: Icon(icon, color: const Color(0xFFFF6B35)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFF6B35),
      ),
    );
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      leading: Icon(icon, color: const Color(0xFFFF6B35)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLanguageTile() {
    final languages = {
      'tr': 'Türkçe',
      'en': 'English',
      'mk': 'Македонски',
    };

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      leading: const Icon(Icons.language, color: Color(0xFFFF6B35)),
      title: const Text('Uygulama Dili'),
      subtitle: Text(languages[_selectedLanguage] ?? 'Türkçe'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Dil Seçin'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: languages.entries.map((entry) {
                  return RadioListTile<String>(
                    title: Text(entry.value),
                    value: entry.key,
                    groupValue: _selectedLanguage,
                    activeColor: const Color(0xFFFF6B35),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                        _saveSetting('language', value);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dil değişikliği için uygulamayı yeniden başlatın'),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('İletişim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactItem(Icons.email, 'E-posta', 'support@fastlygo.com'),
              const SizedBox(height: 12),
              _buildContactItem(Icons.phone, 'Telefon', '+90 555 123 4567'),
              const SizedBox(height: 12),
              _buildContactItem(Icons.language, 'Web', 'www.fastlygo.com'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFFF6B35)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('FastlyGo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Versiyon 14.3.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'FastlyGo, modern ve hızlı teslimat çözümleri sunan bir platformdur.',
              ),
              const SizedBox(height: 16),
              Text(
                '© 2025 FastlyGo. Tüm hakları saklıdır.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}
