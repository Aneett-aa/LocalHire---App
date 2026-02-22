import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isHiring = false;

  final Color primaryGold = const Color.fromARGB(255, 124, 89, 22);
  final Color lightCream = const Color(0xFFF6E7C9);
  final Color localRed = const Color.fromARGB(255, 218, 50, 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ❌ BottomNavigationBar REMOVED

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              /// HEADER
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ✅ FIXED BACK BUTTON
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.settings),
                ],
              ),

              const SizedBox(height: 20),

              /// PROFILE IMAGE
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: primaryGold, width: 4),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundImage:
                        NetworkImage("https://i.pravatar.cc/300?img=5"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryGold,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check,
                        size: 14, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 15),
              const Text("Alex Rivera",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text(
                  "New Delhi, DL • Member since Oct 2022",
                  style: TextStyle(
                      color: Colors.grey, fontSize: 13)),

              const SizedBox(height: 25),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGold,
                        padding:
                            const EdgeInsets.symmetric(
                                vertical: 14),
                        shape:
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(12)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label:
                          const Text("Edit Profile"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(
                                vertical: 14),
                        shape:
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(12)),
                      ),
                      onPressed: () {},
                      icon:
                          const Icon(Icons.share),
                      label: const Text("Share"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// TOGGLE
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _toggleButton(
                        "Hiring",
                        true,
                        Icons.search),
                    _toggleButton(
                        "Working",
                        false,
                        Icons.work),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ABOUT
              _sectionTitle("About"),
              const SizedBox(height: 8),
              Text(
                isHiring
                    ? "Regularly looking for reliable help with home maintenance and specialized tasks."
                    : "Experienced handyman and dog lover. I specialize in plumbing and weekend services.",
                style:
                    const TextStyle(height: 1.5),
              ),

              const SizedBox(height: 30),

              _sectionTitle(isHiring
                  ? "Employer Stats"
                  : "Worker Stats"),
              const SizedBox(height: 12),
              isHiring
                  ? _statCard(
                      "24", "Jobs Posted")
                  : _statCard("86",
                      "Jobs Completed"),

              const SizedBox(height: 30),

              _sectionTitle(isHiring
                  ? "Employer Feedback"
                  : "Reviews"),
              const SizedBox(height: 15),
              _reviewCard(),

              if (!isHiring) ...[
                const SizedBox(height: 30),
                _sectionTitle(
                    "Services Offered"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _serviceChip(
                        "🏠 Home Repairs"),
                    _serviceChip(
                        "🚰 Plumbing"),
                    _serviceChip(
                        "🐕 Dog Walking"),
                    _serviceChip(
                        "🛋 Furniture Assembly"),
                  ],
                ),
              ],

              const SizedBox(height: 40),
              _bigButton(
                  "SOS EMERGENCY", localRed),
              const SizedBox(height: 12),
              _bigButton(
                  "LOGOUT", Colors.black),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  Widget _toggleButton(
      String text, bool value, IconData icon) {
    final selected = isHiring == value;

    return Expanded(
      child: GestureDetector(
        onTap: () =>
            setState(() => isHiring = value),
        child: Container(
          padding:
              const EdgeInsets.symmetric(
                  vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    const BoxShadow(
                        blurRadius: 4,
                        color: Colors.black12,
                        offset:
                            Offset(0, 2))
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected
                      ? Colors.black
                      : Colors.grey),
              const SizedBox(width: 6),
              Text(text,
                  style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                      color: selected
                          ? Colors.black
                          : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment:
          Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.bold,
            color: Colors.grey),
      ),
    );
  }

  Widget _statCard(
      String number, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              blurRadius: 6,
              color: Colors.black12,
              offset: Offset(0, 2))
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(number,
              style:
                  const TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold)),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Colors.grey)),
        ],
      ),
    );
  }

  Widget _reviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              blurRadius: 6,
              color: Colors.black12,
              offset: Offset(0, 2))
        ],
        color: Colors.white,
      ),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text("4.9",
              style:
                  TextStyle(
                      fontSize: 40,
                      fontWeight:
                          FontWeight.bold)),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.star,
                  color:
                      Color(0xFFF2B84B)),
              Icon(Icons.star,
                  color:
                      Color(0xFFF2B84B)),
              Icon(Icons.star,
                  color:
                      Color(0xFFF2B84B)),
              Icon(Icons.star,
                  color:
                      Color(0xFFF2B84B)),
              Icon(Icons.star,
                  color:
                      Color(0xFFF2B84B)),
            ],
          ),
          SizedBox(height: 5),
          Text("124 Reviews",
              style: TextStyle(
                  color:
                      Colors.grey)),
        ],
      ),
    );
  }

  Widget _serviceChip(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8),
      decoration: BoxDecoration(
        color: lightCream,
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Text(text,
          style: const TextStyle(
              fontWeight:
                  FontWeight.w600)),
    );
  }

  Widget _bigButton(
      String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding:
              const EdgeInsets.symmetric(
                  vertical: 16),
          shape:
              RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(14)),
        ),
        onPressed: () {},
        child: Text(text,
            style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 14)),
      ),
    );
  }
}