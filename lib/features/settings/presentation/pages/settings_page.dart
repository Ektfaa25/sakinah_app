import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _autoBackupEnabled = true;
  String _selectedLanguage = 'العربية';
  int _dailyGoal = 5;
  String _reminderTime = '07:00';

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkTheme
              ? [
                  AppColors.darkBackground.withOpacity(0.9),
                  AppColors.darkSurface.withOpacity(0.9),
                ]
              : [
                  _getGradientColor(0).withOpacity(0.6),
                  _getGradientColor(1).withOpacity(0.4),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () => Navigator.pop(context),
            tooltip: 'رجوع',
          ),
          title: Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),

                      // Profile Section
                      _buildProfileSection(),

                      const SizedBox(height: 32),

                      // Preferences Section
                      _buildSectionTitle('التفضيلات', Icons.tune),
                      const SizedBox(height: 16),
                      _buildPreferencesSection(),

                      const SizedBox(height: 32),

                      // Notifications Section
                      _buildSectionTitle(
                        'الإشعارات',
                        Icons.notifications_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildNotificationsSection(),

                      const SizedBox(height: 32),

                      // Data & Backup Section
                      _buildSectionTitle(
                        'البيانات والنسخ الاحتياطي',
                        Icons.backup_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildDataBackupSection(),

                      const SizedBox(height: 32),

                      // About Section
                      _buildSectionTitle('حول التطبيق', Icons.info_outlined),
                      const SizedBox(height: 16),
                      _buildAboutSection(),

                      const SizedBox(height: 32),

                      // Footer
                      Center(
                        child: Text(
                          '💙Made with love by Ektfaa💙',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6366F1).withOpacity(0.08),
              const Color(0xFF8B5CF6).withOpacity(0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF6366F1).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              'مستخدم سكينة',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              'عضو منذ يناير 2024',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      children: [
        _buildSettingsCard(
          children: [
            _buildDropdownTile(
              title: 'اللغة',
              subtitle: 'اختر لغة التطبيق',
              icon: Icons.language,
              value: _selectedLanguage,
              items: ['العربية', 'English'],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              color: Color.lerp(_getGradientColor(0), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildSliderTile(
              title: 'الهدف اليومي',
              subtitle: '$_dailyGoal أذكار يومياً',
              icon: Icons.flag,
              value: _dailyGoal.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (value) {
                setState(() {
                  _dailyGoal = value.toInt();
                });
              },
              color: Color.lerp(_getGradientColor(4), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildTimeTile(
              title: 'وقت التذكير',
              subtitle: 'تذكير يومي للأذكار',
              icon: Icons.schedule,
              time: _reminderTime,
              onChanged: (time) {
                setState(() {
                  _reminderTime = time;
                });
              },
              color: Color.lerp(_getGradientColor(6), Colors.black, 0.2)!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      children: [
        _buildSettingsCard(
          children: [
            _buildSwitchTile(
              title: 'الإشعارات',
              subtitle: 'تفعيل الإشعارات العامة',
              icon: Icons.notifications,
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              color: Color.lerp(_getGradientColor(1), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildSwitchTile(
              title: 'الصوت',
              subtitle: 'تشغيل أصوات الإشعارات',
              icon: Icons.volume_up,
              value: _soundEnabled,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    }
                  : null,
              color: Color.lerp(_getGradientColor(5), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildSwitchTile(
              title: 'الاهتزاز',
              subtitle: 'تفعيل الاهتزاز مع الإشعارات',
              icon: Icons.vibration,
              value: _vibrationEnabled,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    }
                  : null,
              color: Color.lerp(_getGradientColor(7), Colors.black, 0.2)!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataBackupSection() {
    return Column(
      children: [
        _buildSettingsCard(
          children: [
            _buildSwitchTile(
              title: 'النسخ الاحتياطي التلقائي',
              subtitle: 'حفظ تلقائي للبيانات',
              icon: Icons.backup,
              value: _autoBackupEnabled,
              onChanged: (value) {
                setState(() {
                  _autoBackupEnabled = value;
                });
              },
              color: Color.lerp(_getGradientColor(2), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildActionTile(
              title: 'إنشاء نسخة احتياطية',
              subtitle: 'حفظ بياناتك الحالية',
              icon: Icons.cloud_upload,
              onTap: () {
                _showBackupDialog();
              },
              color: Color.lerp(_getGradientColor(3), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildActionTile(
              title: 'استعادة البيانات',
              subtitle: 'استعادة من نسخة احتياطية',
              icon: Icons.cloud_download,
              onTap: () {
                _showRestoreDialog();
              },
              color: Color.lerp(_getGradientColor(8), Colors.black, 0.2)!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        _buildSettingsCard(
          children: [
            _buildActionTile(
              title: 'حول التطبيق',
              subtitle: 'الإصدار 1.0.0',
              icon: Icons.info,
              onTap: () {
                _showAboutDialog();
              },
              color: Color.lerp(_getGradientColor(9), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildActionTile(
              title: 'المساعدة والدعم',
              subtitle: 'احصل على المساعدة',
              icon: Icons.help,
              onTap: () {
                _showHelpDialog();
              },
              color: Color.lerp(_getGradientColor(0), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildActionTile(
              title: 'شروط الاستخدام',
              subtitle: 'اقرأ شروط الخدمة',
              icon: Icons.description,
              onTap: () {
                _showTermsDialog();
              },
              color: Color.lerp(_getGradientColor(1), Colors.black, 0.2)!,
            ),
            _buildDivider(),
            _buildActionTile(
              title: 'تقييم التطبيق',
              subtitle: 'قيم تجربتك',
              icon: Icons.star,
              onTap: () {
                _showRatingDialog();
              },
              color: Color.lerp(_getGradientColor(6), Colors.black, 0.2)!,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkTheme
              ? AppColors.darkSurface.withOpacity(0.8)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkTheme
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkTheme
                ? AppColors.darkSurface.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool)? onChanged,
    required Color color,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            inactiveThumbColor: isDarkTheme
                ? Colors.grey[400]
                : Colors.grey[300],
            inactiveTrackColor: isDarkTheme
                ? Colors.grey[600]
                : Colors.grey[200],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: onChanged != null
                        ? (isDarkTheme ? Colors.white : const Color(0xFF1A1A2E))
                        : Colors.grey[500],
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: onChanged != null
                        ? (isDarkTheme ? Colors.grey[300] : Colors.grey[600])
                        : Colors.grey[400],
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkTheme ? Colors.grey[400] : Colors.grey[400],
              size: 16,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkTheme
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required Color color,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: Container(),
              dropdownColor: isDarkTheme ? AppColors.darkSurface : Colors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: isDarkTheme
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
    required Color color,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkTheme
                            ? Colors.white
                            : const Color(0xFF1A1A2E),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkTheme
                            ? Colors.grey[300]
                            : Colors.grey[600],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.9),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String time,
    required Function(String) onChanged,
    required Color color,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(time.split(':')[0]),
            minute: int.parse(time.split(':')[1]),
          ),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: isDarkTheme
                      ? AppColors.darkSurface
                      : Colors.white,
                  hourMinuteTextColor: isDarkTheme
                      ? Colors.white
                      : const Color(0xFF1A1A2E),
                  hourMinuteColor: const Color(
                    0xFFE3F2FD,
                  ), // Light baby blue background
                  dayPeriodTextColor: isDarkTheme
                      ? Colors.white
                      : const Color(0xFF1A1A2E),
                  dayPeriodColor: const Color(
                    0xFFE3F2FD,
                  ), // Light baby blue background
                  dialHandColor: const Color(
                    0xFF64B5F6,
                  ), // Baby blue for dial hand
                  dialTextColor: isDarkTheme
                      ? Colors.white
                      : const Color(0xFF1A1A2E),
                  entryModeIconColor: const Color(
                    0xFF64B5F6,
                  ), // Baby blue for icons
                  helpTextStyle: TextStyle(
                    color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF64B5F6), // Baby blue
                  brightness: isDarkTheme ? Brightness.dark : Brightness.light,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          final formattedTime =
              '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
          onChanged(formattedTime);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : color,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkTheme
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.1),
      indent: 20,
      endIndent: 20,
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إنشاء نسخة احتياطية',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل تريد إنشاء نسخة احتياطية من بياناتك؟',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', textDirection: TextDirection.rtl),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم إنشاء النسخة الاحتياطية بنجاح',
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: Text('موافق', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'استعادة البيانات',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل تريد استعادة البيانات من النسخة الاحتياطية؟ سيتم استبدال البيانات الحالية.',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', textDirection: TextDirection.rtl),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم استعادة البيانات بنجاح',
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: const Color(0xFFF59E0B),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
            ),
            child: Text('استعادة', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حول تطبيق سكينة',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.spa, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              'تطبيق سكينة للأذكار\nالإصدار 1.0.0\n\nتطبيق يساعدك على ذكر الله والحفاظ على الأذكار اليومية\n',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
            child: Text('موافق', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'المساعدة والدعم',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'إذا كنت بحاجة للمساعدة، يمكنك التواصل معنا عبر:\n\n• البريد الإلكتروني: support@sakinah.app\n• الموقع الإلكتروني: www.sakinah.app\n• الهاتف: +966123456789',
          textDirection: TextDirection.rtl,
          style: TextStyle(height: 1.5),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: Text('موافق', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'شروط الاستخدام',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            '1. استخدام التطبيق مجاني للجميع\n2. يحق لك استخدام التطبيق للأغراض الشخصية\n3. لا يحق نسخ أو توزيع التطبيق بدون إذن\n4. نحتفظ بحق تحديث الشروط\n5. البيانات الشخصية محمية ولا تُشارك مع أطراف ثالثة',
            textDirection: TextDirection.rtl,
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
            ),
            child: Text('موافق', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تقييم التطبيق',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'هل أعجبك التطبيق؟ نسعد بتقييمك',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: const Color(0xFFF59E0B),
                  size: 32,
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('لاحقاً', textDirection: TextDirection.rtl),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'شكراً لتقييمك!',
                    textDirection: TextDirection.rtl,
                  ),
                  backgroundColor: const Color(0xFFE91E63),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
            ),
            child: Text('تقييم', textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }

  // Get gradient colors that match the home page design
  Color _getGradientColor(int index) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final darkColors = [
      _getColorFromHex('#E8E2B8'), // Muted warm yellow
      _getColorFromHex('#9BB3D9'), // Muted soft blue
      _getColorFromHex('#E8CDB8'), // Muted warm peach
      _getColorFromHex('#89C5D9'), // Muted cyan
      _getColorFromHex('#94D9CC'), // Muted mint green
      _getColorFromHex('#B0D9B8'), // Muted light green
      _getColorFromHex('#D9B8BC'), // Muted light pink
      _getColorFromHex('#D4B8D1'), // Muted light purple
      _getColorFromHex('#C2A8D4'), // Muted light lavender
      _getColorFromHex('#7FC4D9'), // Muted light turquoise
    ];

    final lightColors = [
      _getColorFromHex('#FBF8CC'), // Light yellow
      _getColorFromHex('#A3C4F3'), // Light blue
      _getColorFromHex('#FDE4CF'), // Light peach
      _getColorFromHex('#90DBF4'), // Light cyan
      _getColorFromHex('#98F5E1'), // Light mint
      _getColorFromHex('#B9FBC0'), // Light green
      _getColorFromHex('#FFCFD2'), // Light pink
      _getColorFromHex('#F1C0E8'), // Light purple
      _getColorFromHex('#CFBAF0'), // Light lavender
      _getColorFromHex('#8EECF5'), // Light turquoise
    ];

    final colors = isDarkTheme ? darkColors : lightColors;
    return colors[index % colors.length];
  }

  /// Helper method to convert hex color string to Color object
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add alpha channel
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
