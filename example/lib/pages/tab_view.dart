import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({Key? key}) : super(key: key);

  @override
  _TabViewPageState createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return TabView(
      selected: page,
      onChanged: (i) => setState(() => page = i),
      content: SizedBox(
        height: 350,
        width: double.infinity,
        child: [
          Center(child: Text('SOUND EFFECTS')),
          Center(child: Text('OUTPUT')),
          Center(child: Text('INPUT')),
        ][page],
      ),
      tabs: [
        Tab(content: Text('Sound Effects')),
        Tab(content: Text('Output')),
        Tab(content: Text('Input')),
      ],
    );
  }
}
