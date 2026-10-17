import 'package:flutter/material.dart';

void main() {
  runApp(const WorldBestMusicApp());
}

class WorldBestMusicApp extends StatelessWidget {
  const WorldBestMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const RootApp(),
    );
  }
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool isLoggedIn = false;
  int navIndex = 0;
  String currentSong = "No song playing";
  bool isPlaying = false;
  String searchQuery = "";

  final List<String> playlists = const ['1. NIGHT', '2. RAIN', '3. ELFER', '4. PAIN', '5. GREL', '6. DEATH'];
  final List<String> searchResults = const ['Starboy - The Weeknd', 'Unstoppable - Sia', 'Night Changes - 1D', 'Mockingbird - Eminem'];

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('WELCOME TO', style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 1.5)),
                const SizedBox(height: 5),
                const Text('KIL', style: TextStyle(color: Colors.redAccent, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const SizedBox(height: 40),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter Phone Number',
                    prefixIcon: const Icon(Icons.phone, color: Colors.redAccent),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => setState(() => isLoggedIn = true),
                  child: const Text('Get OTP & Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget getBody() {
      if (navIndex == 0) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Feel',
                  prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Text(searchQuery.isEmpty ? 'Trending World Banner' : 'Feel Search Results', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (searchQuery.isEmpty)
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(16)),
                  child: const Center(child: Text('✨ Swipeable World Trending Songs ✨', style: TextStyle(color: Colors.grey))),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(searchResults[i], style: const TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.play_arrow, color: Colors.redAccent),
                      onTap: () => setState(() {
                        currentSong = searchResults[i];
                        isPlaying = true;
                      }),
                    ),
                  ),
                ),
            ],
          ),
        );
      } else if (navIndex == 1) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('BLOOD', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent)),
              const SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('🔥 Seamless Trending Swiping Songs 🔥', style: TextStyle(color: Colors.grey))),
              ),
              const SizedBox(height: 15),
              const Text('Offline Playlists', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2),
                  itemCount: playlists.length,
                  itemBuilder: (ctx, i) => Container(
                    decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
                    child: Center(child: Text(playlists[i], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('EU', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Row(
                children: [
                  CircleAvatar(radius: 25, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.black)),
                  SizedBox(width: 15),
                  Text('Eren Yeager', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.download_done, color: Colors.redAccent),
                        SizedBox(width: 12),
                        Text('SOUL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 60), child: getBody()),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[900],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currentSong, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Music', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.redAccent, size: 30),
                      onPressed: () => setState(() => isPlaying = !isPlaying),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: 'Leaf'),
          BottomNavigationBarItem(icon: Icon(Icons.opacity), label: 'Blood'),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'EU'),
        ],
      ),
    );
  }
}
