import 'package:macos_ui/src/library.dart';
import 'package:macos_ui/macos_ui.dart';

/// The height of the tabs used on [TabView]
const double kTabHeight = 24.0;

const _tabViewDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
  border: Border.fromBorderSide(const BorderSide(
    color: MacosColors.black,
    width: 0.4,
  )),
  color: MacosColors.windowBackgroundColor,
);

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
  /// The tab content.
  ///
  /// Typically a [Text] widget.
  final Widget content;

  /// Creates a tab used by [TabView].
  const Tab({required this.content});
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
    return Stack(children: [
      Container(
        decoration: decoration,
        margin: _calculateMargin(),
        padding: const EdgeInsets.all(kTabHeight),
        child: content,
      ),
      _positionChild(_Tabs(
        tabs: tabs,
        alignment: alignment,
        selected: selected,
        onChanged: onChanged,
      )),
    ]);
  }

  EdgeInsetsGeometry _calculateMargin() {
    switch (alignment) {
      case TabsAlignment.top:
        return const EdgeInsets.only(top: kTabHeight / 2);
      case TabsAlignment.bottom:
        return const EdgeInsets.only(bottom: kTabHeight / 2);
      case TabsAlignment.left:
        return const EdgeInsets.only(left: kTabHeight / 2);
      case TabsAlignment.right:
        return const EdgeInsets.only(right: kTabHeight / 2);
    }
  }

  Widget _positionChild(Widget child) {
    switch (alignment) {
      case TabsAlignment.top:
        return Positioned(top: 0, right: 0, left: 0, child: child);
      case TabsAlignment.bottom:
        return Positioned(bottom: 0, right: 0, left: 0, child: child);
      case TabsAlignment.left:
        return Positioned(left: 0, top: 0, bottom: 0, child: child);
      case TabsAlignment.right:
        return Positioned(right: 0, top: 0, bottom: 0, child: child);
    }
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
    final bool isHorizontal =
        [TabsAlignment.left, TabsAlignment.right].contains(alignment);
    Widget result = SizedBox(
      height: isHorizontal ? null : kTabHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          return _buildTab(tab, index, context);
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
    final Radius radius = Radius.circular(4.0);

    final color = MacosDynamicColor.resolve(
      isSelected
          ? MacosColors.selectedControlBackgroundColor
          : MacosColors.controlBackgroundColor,
      context,
    );
    return GestureDetector(
      onTap: () => onChanged(index),
      child: Container(
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.horizontal(
            left: index == 0 ? radius : Radius.zero,
            right: index == tabs.length - 1 ? radius : Radius.zero,
          ),
          border: Border.fromBorderSide(BorderSide(
            style: isSelected ? BorderStyle.none : BorderStyle.solid,
            color: MacosColors.separatorColor,
            width: 0.4,
          )),
        ),
        child: DefaultTextStyle(
          style: TextStyle(fontSize: 12, color: textLuminance(color)),
          child: tab.content,
        ),
      ),
    );
  }
}
