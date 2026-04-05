import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ===============================
            // 🔹 VERIFICATION SECTION
            // ===============================
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Verification Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('verificationStatus', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data?.docs ?? [];

                if (users.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("No pending requests"),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {

                    final doc = users[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(data['name'] ?? 'No Name'),
                        subtitle: Text(data['phone'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // ✅ APPROVE
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                doc.reference.update({
                                  'verificationStatus': 'approved'
                                });
                              },
                            ),

                            // ❌ REJECT
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                doc.reference.update({
                                  'verificationStatus': 'rejected'
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            // ===============================
            // 🚨 REPORTS SECTION
            // ===============================
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "User Reports",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = snapshot.data?.docs ?? [];

                if (reports.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("No reports"),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {

  final doc = reports[index];
  final data = doc.data() as Map<String, dynamic>;

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(data['reportedUserId'])
        .get(),
    builder: (context, reportedSnapshot) {

      if (reportedSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!reportedSnapshot.hasData ||
          reportedSnapshot.data!.data() == null) {
        return const Text("User data not found ❌");
      }

      final reportedUser =
          reportedSnapshot.data!.data() as Map<String, dynamic>;

      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(data['reporterId'])
            .get(),
        builder: (context, reporterSnapshot) {

          Map<String, dynamic>? reporterUser;

          if (reporterSnapshot.hasData &&
              reporterSnapshot.data!.data() != null) {
            reporterUser =
                reporterSnapshot.data!.data() as Map<String, dynamic>;
          }

          return Card(
            margin: const EdgeInsets.all(10),
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔴 REPORTED USER
                  const Text("🚨 Reported User",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Text(reportedUser['name'] ?? ''),
                  Text(reportedUser['phone'] ?? ''),

                  const SizedBox(height: 8),

                  if (reportedUser['profileImage'] != null)
                    Image.network(
                      reportedUser['profileImage'],
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          const Text("Profile load failed ❌"),
                    ),

                  if (reportedUser['idProof'] != null)
                    Image.network(
                      reportedUser['idProof'],
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          const Text("ID load failed ❌"),
                    ),

                  const SizedBox(height: 10),

                  // 🟢 REPORTER USER
                  if (reporterUser != null) ...[
                    const Text("👤 Reported By",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(reporterUser['name'] ?? ''),
                    Text(reporterUser['phone'] ?? ''),
                    const SizedBox(height: 10),
                  ],

                  // 📄 REPORT INFO
                  Text("Reason: ${data['reason']}"),
                  Text("Details: ${data['details'] ?? ''}"),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      // 🚫 BAN
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(data['reportedUserId'])
                              .update({'isBanned': true});

                          await doc.reference.update({
                            'status': 'resolved',
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("User Banned 🚫")),
                          );
                        },
                        child: const Text("Ban"),
                      ),

                      const SizedBox(width: 8),

                      // 🔓 UNBAN
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(data['reportedUserId'])
                              .update({'isBanned': false});

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("User Unbanned 🔓")),
                          );
                        },
                        child: const Text("Unban"),
                      ),

                      const SizedBox(width: 8),

                      // ✅ RESOLVE
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {

                          await doc.reference.update({
                            'status': 'resolved',
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Resolved ✅")),
                          );
                        },
                        child: const Text("Resolve"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
},
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}