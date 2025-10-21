import 'package:flutter/material.dart';

class NotiserScreen extends StatefulWidget {
  const NotiserScreen({super.key});

  @override
  State<NotiserScreen> createState() => _NotiserScreenState();
}

class _NotiserScreenState extends State<NotiserScreen> {
  bool pushNotis = true;
  bool emailNotis = false;
  bool smsNotis = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notiser', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSwitchTile(
              context,
              'Pushnotiser',
              pushNotis,
              (val) => setState(() => pushNotis = val),
              icon: Icons.notifications_active_outlined,
              color: color,
              bgColor: bgColor,
              textColor: textColor,
            ),
            _buildSwitchTile(
              context,
              'E-postnotiser',
              emailNotis,
              (val) => setState(() => emailNotis = val),
              icon: Icons.email_outlined,
              color: color,
              bgColor: bgColor,
              textColor: textColor,
            ),
            _buildSwitchTile(
              context,
              'SMS-notiser',
              smsNotis,
              (val) => setState(() => smsNotis = val),
              icon: Icons.sms_outlined,
              color: color,
              bgColor: bgColor,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    bool value,
    Function(bool) onChanged, {
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: TextStyle(color: textColor, fontSize: 16)),
          trailing: Switch(
            value: value,
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
