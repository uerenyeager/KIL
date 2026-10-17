import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const KilApp());
}

class KilApp extends StatelessWidget {
  const KilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          surface: Colors.black,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const LeafPage(),
    const BloodPage(),
    const EuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Leaf'),
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Blood'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'EU'),
        ],
      ),
    );
  }
}

// ---------------- LEAF PAGE WITH WORKING SEARCH ----------------
class LeafPage extends StatefulWidget {
  const LeafPage({super.key});

  @override
  State<LeafPage> createState() => _LeafPageState();
}

class _LeafPageState extends State<LeafPage> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  bool _forward = true;
  Timer? _bannerTimer;

  bool _isPlaying = false;
  String _currentPlayingSong = "Demon Hunter";
  String _searchQuery = "";

  final List<Map<String, dynamic>> _allSongs = [
    {"title": "Starboy", "artist": "The Weeknd", "color": Colors.red.shade900},
    {"title": "Metamorphosis", "artist": "INTERWORLD", "color": Colors.grey.shade900},
    {"title": "KIL Theme", "artist": "Eren Yeager", "color": Colors.deepOrange.shade900},
    {"title": "Goth", "artist": "Sidewalks & Skeletons", "color": Colors.blueGrey.shade900},
    {"title": "Rave", "artist": "Dxrk", "color": Colors.purple.shade900},
    {"title": "Nightwork", "artist": "Kavinsky", "color": Colors.indigo.shade900},
    {"title": "Dark Hours", "artist": "Night Playlist", "color": Colors.brown.shade900},
    {"title": "Heavy Drops", "artist": "Rain Playlist", "color": Colors.teal.shade900},
  ];

  @override
  void initState() {
    super.initState();
    _startBannerAutoSwipe();
  }

  void _playSong(String songName) {
    setState(() {
      _isPlaying = true;
      _currentPlayingSong = songName;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Now Playing: $songName 🎶"),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _startBannerAutoSwipe() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients && _searchQuery.isEmpty) {
        if (_forward) {
          if (_currentBannerIndex < 5) {
            _currentBannerIndex++;
          } else {
            _forward = false;
            _currentBannerIndex--;
          }
        } else {
          if (_currentBannerIndex > 0) {
            _currentBannerIndex--;
          } else {
            _forward = true;
            _currentBannerIndex++;
          }
        }
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSongs = _allSongs.where((song) {
      return song["title"]!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             song["artist"]!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[950],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.6)),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.redAccent),
                      hintText: "Search song or feel...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // If searching, show search results list. Otherwise show Banners.
              if (_searchQuery.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                  child: Text("SEARCH RESULTS", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: song["color"], borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.music_note, color: Colors.white, size: 20),
                      ),
                      title: Text(song["title"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(song["artist"], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      trailing: const Icon(Icons.play_arrow_rounded, color: Colors.redAccent),
                      onTap: () => _playSong(song["title"]),
                    );
                  },
                ),
              ] else ...[
                // Trending Banners
                SizedBox(
                  height: 210,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final song = _allSongs[index];
                      return GestureDetector(
                        onTap: () => _playSong(song["title"]),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: song["color"],
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song["title"], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(song["artist"], style: const TextStyle(fontSize: 15, color: Colors.white70)),
                              const SizedBox(height: 6),
                              const Text("Tap to Play 🎶", style: TextStyle(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text("NOW PLAYING", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                ),

                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[950],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_currentPlayingSong, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                                const SizedBox(height: 2),
                                Text(_isPlaying ? "Playing Offline Audio..." : "Paused", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded, color: Colors.redAccent, size: 36),
                            onPressed: () => _playSong(_allSongs[0]["title"]),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
                            child: IconButton(
                              icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 34),
                              onPressed: _togglePlayPause,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, color: Colors.redAccent, size: 36),
                            onPressed: () => _playSong(_allSongs[1]["title"]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- BLOOD PAGE ----------------
class BloodPage extends StatefulWidget {
  const BloodPage({super.key});

  @override
  State<BloodPage> createState() => _BloodPageState();
}

class _BloodPageState extends State<BloodPage> {
  final PageController _bloodBannerController = PageController();

  final List<Map<String, String>> playlistData = const [
    {"name": "1. NIGHT", "topSong": "Most Played: Dark Hours"},
    {"name": "2. RAIN", "topSong": "Most Played: Heavy Drops"},
    {"name": "3. ELFER", "topSong": "Most Played: Ancient Echo"},
    {"name": "4. PAIN", "topSong": "Most Played: Silent Tears"},
    {"name": "5. GREL", "topSong": "Most Played: Shadow Realm"},
    {"name": "6. DEATH", "topSong": "Most Played: Final Horizon"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Blood",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: _bloodBannerController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade900, Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("DARK VAULT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(height: 6),
                        Text("Trending Offline Beats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlistData.length,
              itemBuilder: (context, index) {
                final item = playlistData[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Playing ${item["name"]}..."), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 1)),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[950],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"]!,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["topSong"]!,
                              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        const Icon(Icons.play_circle_fill_rounded, color: Colors.redAccent, size: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- EU PAGE (PROFILE & Z SETTINGS) ----------------
class EuPage extends StatefulWidget {
  const EuPage({super.key});

  @override
  State<EuPage> createState() => _EuPageState();
}

class _EuPageState extends State<EuPage> {
  String userName = "Eren Yeager";

  void _showZSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[950],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 18),
              const Row(
                children: [
                  Text("( Z )", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  SizedBox(width: 12),
                  Text("Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const Divider(color: Colors.white24, height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                ),
                child: const Text(
                  "SOUL",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editName() {
    TextEditingController controller = TextEditingController(text: userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Edit Profile Name", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() => userName = controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("EU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(
            icon: const Text("( Z )", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18)),
            onPressed: _showZSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile Photo Selected")),
                    );
                  },
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.redAccent,
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor: Colors.black,
                          child: Icon(Icons.person, size: 42, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_a_photo, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                        onPressed: _editName,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[950],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withOpacity(0.6)),
              ),
              child: const Center(
                child: Text(
                  "SOUL",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
