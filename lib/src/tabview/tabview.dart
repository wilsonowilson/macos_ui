import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/macos_ui.dart';

/// The height of the tabs used on [TabView]
const double kTabHeight = 28.0;

const Decoration _tabViewDecoration =
    BoxDecoration(color: MacosColors.windowBackgroundColor);

/// The tab alignment
enum TabsAlignment {
  /// ![Top Tabs](https://developer.apple.com/design/human-interface-guidelines/macos/images/TabView_Top.png)
  top,

  /// ![Bottom Tabs](https://developer.apple.com/design/human-interface-guidelines/macos/images/TabView_Bottom.png)
  bottom,

  /// ![Left Tabs](https://developer.apple.com/design/human-interface-guidelines/macos/images/TabView_Left.png)
  left,

  /// ![Right Tabs](https://developer.apple.com/design/human-interface-guidelines/macos/images/TabView_Right.png)
  right,
}

/// Used on [TabView]'s tabbed control.
///
/// See also:
///
///  * [TabView], used to display multiple tabs.
class Tab {
  final Widget? leading;

  /// The tab content.
  ///
  /// Typically a [Text] widget.
  final Widget content;

  /// Creates a tab used by [TabView].
  const Tab({
    this.leading,
    required this.content,
  });
}

/// A tab view presents multiple mutually exclusive panes of content in
/// the same area. A tab view includes a tabbed control and a content area.
/// Each segment of a tabbed control is known as a *tab*, and clicking a tab
/// displays its corresponding pane in the content area. Although the amount
/// of content can vary from pane to pane, switching tabs doesn’t change the
/// overall size of the tab view or its parent window.
///
/// See also:
///
///  * [Tab], used to tell the tab view how tabs should look like
///  * [TabsAlignment], used to align the tabs horizontally or vertically
class TabView extends StatelessWidget {
  /// Creates a tabbed view.
  ///
  /// [selected] must be non-negative.
  ///
  /// [tabs] must have at least two tabs.
  const TabView({
    Key? key,
    required this.selected,
    required this.onChanged,
    required this.tabs,
    required this.content,
    this.alignment = TabsAlignment.top,
    this.decoration = _tabViewDecoration,
  })  : assert(selected >= 0),
        assert(tabs.length > 2),
        super(key: key);

  /// The current selected index. This must be non-negative.
  final int selected;

  /// Called when the current selected index is changed.
  final ValueChanged<int> onChanged;

  /// The list of tabs to be displayed in the tabbed control.
  final List<Tab> tabs;

  /// Where the tabs should be aligned at.
  final TabsAlignment alignment;

  /// The tab view content. A padding is applied to this content
  final Widget content;

  /// The content background decoration
  final Decoration decoration;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _Tabs(
        tabs: tabs,
        alignment: alignment,
        selected: selected,
        onChanged: onChanged,
      ),
      Container(
        decoration: decoration,
        padding: const EdgeInsets.all(kTabHeight),
        child: content,
      ),
    ]);
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    Key? key,
    required this.tabs,
    required this.alignment,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  final List<Tab> tabs;
  final TabsAlignment alignment;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMacosTheme(context));
    final bool isHorizontal =
        [TabsAlignment.left, TabsAlignment.right].contains(alignment);
    Widget result = SizedBox(
      height: isHorizontal ? null : kTabHeight,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          return Expanded(child: _buildTab(tab, index, context));
        }),
      ),
    );
    if (isHorizontal)
      return RotatedBox(
        quarterTurns: alignment == TabsAlignment.left ? 1 : 3,
        child: result,
      );
    return result;
  }

  Widget _buildTab(Tab tab, int index, BuildContext context) {
    final bool isSelected = index == selected;

    final color = MacosDynamicColor.resolve(
      isSelected
          ? MacosColors.alternatingContentBackgroundColor
          : MacosColors.controlBackgroundColor,
      context,
    );

    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: color,
          border: Border.fromBorderSide(BorderSide(
            style: !isSelected ? BorderStyle.none : BorderStyle.solid,
            color: MacosColors.gridColor,
            width: 1.0,
          )),
        ),
        child: Row(children: [
          if (tab.leading != null)
            SizedBox(
              height: 16.0,
              width: 16.0,
              child: IconTheme.merge(
                child: tab.leading!,
                data: IconThemeData(size: 6),
              ),
            ),
          Expanded(
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 12, color: textLuminance(color)),
              textAlign: TextAlign.center,
              child: tab.content,
            ),
          ),
          // Placeholder
          if (tab.leading != null) SizedBox(width: 16.0),
        ]),
      ),
    );
  }
}
