import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PomodoroLinks extends StatefulWidget {
  const PomodoroLinks({super.key});

  @override
  State<PomodoroLinks> createState() => _PomodoroLinksState();
}

class _PomodoroLinksState extends State<PomodoroLinks> {
  ValueNotifier<String?> youtubeLink=ValueNotifier(null);
  ValueNotifier<String?> spotifyLink = ValueNotifier(null);


  Future<void> _loadLinks() async {
    final prefs = await SharedPreferences.getInstance();
    youtubeLink.value = prefs.getString('pomodoro-youtubeLink');
    spotifyLink.value = prefs.getString('pomodoro-spotifyLink');
  }

  Future<void> _setLink(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setString(key, value);
    } else {
      await prefs.remove(key);
    }
  }

  String? convertToEmbedYoutube(String link) {
    final videoId = link.split("v=").length > 1 ? link.split("v=")[1].split("&")[0] : null;
    return videoId != null ? "https://www.youtube.com/embed/$videoId" : null;
  }

  String? convertToEmbedSpotify(String link) {
    if (link.contains('/playlist/')) {
      final playlistId = link.split("/playlist/")[1].split("?")[0];
      return "https://open.spotify.com/embed/playlist/$playlistId";
    } else if (link.contains('/album/')) {
      final albumId = link.split("/album/")[1].split("?")[0];
      return "https://open.spotify.com/embed/album/$albumId";
    } else if (link.contains('/track/')) {
      final trackId = link.split("/track/")[1].split("?")[0];
      return "https://open.spotify.com/embed/track/$trackId?utm_source=generator";
    }
    return null;
  }

  void handleYoutubeLinkChange(String link) {
    final embedLink = convertToEmbedYoutube(link);
    youtubeLink.value = embedLink;
    _setLink('pomodoro-youtubeLink', embedLink);
  }

  void handleSpotifyLinkChange(String link) {
    final embedLink = convertToEmbedSpotify(link);
    spotifyLink.value = embedLink;
    _setLink('pomodoro-spotifyLink', embedLink);
  }

  void handleDeleteYoutube() {
    youtubeLink.value = null;
    _setLink('pomodoro-youtubeLink', null);
  }

  void handleDeleteSpotify() {
    spotifyLink.value = null;
    _setLink('pomodoro-spotifyLink', null);
  }
  
  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  @override
  void dispose() {
    youtubeLink.dispose();
    spotifyLink.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: OutlinedContainer(
        clipBehavior: Clip.antiAlias,
        child: ResizablePanel.vertical(
          draggerBuilder: (context) {
            return const VerticalResizableDragger();
          },
          children: [
            ResizablePane(
              initialSize: 80, 
              child: 
              Column(
                children: [
                  Container(
                    child:Text("1") 
                  )
                ],
              )
              ),
            ResizablePane(initialSize: 120, child: Text("2")),
          ],
        ),
      ),
    ) ;

  }
}