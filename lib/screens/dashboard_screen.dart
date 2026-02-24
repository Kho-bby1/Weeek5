import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('Dashboard', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1D1E2C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text('Sign Out', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  content: Text('Are you sure you want to sign out?', style: GoogleFonts.outfit()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Sign Out', style: GoogleFonts.outfit(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Hello,',
              style: GoogleFonts.outfit(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            Text(
              user?.email?.split('@')[0] ?? 'Explorer',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D1E2C),
              ),
            ),
            const SizedBox(height: 32),
            
            // Profile Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Color(0xFF4C51BF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileRow(Icons.email_outlined, 'Email', user?.email ?? 'N/A'),
                  const Divider(color: Colors.white24, height: 24),
                  _buildProfileRow(Icons.fingerprint, 'User ID', user?.uid.substring(0, 8) ?? 'N/A', isBadge: true),
                  const Divider(color: Colors.white24, height: 24),
                  _buildProfileRow(
                    Icons.verified_user_outlined, 
                    'Status', 
                    user?.emailVerified == true ? 'Verified' : 'Pending',
                    isBadge: true,
                    badgeColor: user?.emailVerified == true ? Colors.greenAccent : Colors.amberAccent,
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  _buildProfileRow(Icons.calendar_today_outlined, 'Joined', user?.metadata.creationTime?.toString().substring(0, 10) ?? 'Unknown'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Grid Menu
            Text(
              'Quick Actions',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D1E2C),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildActionTile(Icons.person_outline, 'My Profile', Colors.blue),
                _buildActionTile(Icons.history_rounded, 'Activity', Colors.orange),
                _buildActionTile(Icons.notifications_none_rounded, 'Updates', Colors.purple),
                _buildActionTile(Icons.settings_outlined, 'Settings', Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value, {bool isBadge = false, Color? badgeColor}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
        ),
        const Spacer(),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor?.withOpacity(0.2) ?? Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: badgeColor?.withOpacity(0.5) ?? Colors.white24),
            ),
            child: Text(
              value,
              style: GoogleFonts.outfit(
                color: badgeColor ?? Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D1E2C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
