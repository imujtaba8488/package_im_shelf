import 'package:flutter/material.dart';

/// Signature of the callback fired when an item is opened.
typedef ItemOpen = void Function(bool isOpen);

/// A widget that contains items placed within a shelf. Everytime an item is tapped it expands to display its content. Any other items that were open prior to opening a new item are closed automatically and tapping an item again closes the item as well. The item opening and closing animation can be customized. Although, typically designed to display images within the content of items, the content can however hold any widget.
class Shelf extends StatefulWidget {
  /// The list of items to be shown within the shelf.
  final List<ShelfItem> shelfItems;

  /// The width of the content area. _Note: Content area is the area that shows the widget when a shelf item is opened._
  final double contentWidth;

  /// The width of the item when it is closed. __Note: Width of the item when it is closed must be less or equal to half of width of the content area.__
  final double itemWidth;

  /// The animation effect to be applied when an item is opened or closed. Use the built-in Curves class to specify the effect.
  final Curve openCloseAnimation;

  /// The duration of the open close animation effect.
  final Duration openCloseDuration;

  Shelf({
    this.shelfItems,
    this.contentWidth = 100.0,
    this.itemWidth = 25.0,
    this.openCloseAnimation = Curves.easeIn,
    this.openCloseDuration = const Duration(milliseconds: 1500),
  }) {
    assert(itemWidth <= contentWidth / 2.0);
  }

  @override
  _ShelfState createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> with SingleTickerProviderStateMixin {
  // Whether to close the item or not.
  bool closeItem = false;

  // The index of the item that is open.
  int openItemIndex;

  // Whether the item is open or not.
  bool isItemOpen = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: _buildItems,
      itemCount: widget.shelfItems != null ? widget.shelfItems.length : 0,
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    // ! What is happening??
    // * The isOpen() method returns true when an item is opened. When that happens closeItem is set to true, along with the index of the item that was opened. The setState() call rebuilds the list with the new values recieved after opening an item. During the rebuild all other items (whether they were open or closed) are closed used the 'close' attribute.
    return _Item(
      // Non-customizable items requried the manage the internal state.
      isOpen: (bool value) {
        setState(() {
          closeItem = value;
          isItemOpen = value;
          openItemIndex = index;
        });
      },
      close: openItemIndex != index ? closeItem : false,

      // customizable items.
      openCloseAnimation: widget.openCloseAnimation,
      openCloseDuration: widget.openCloseDuration,
      contentWidth: widget.contentWidth,
      width: widget.itemWidth,
      label: widget?.shelfItems[index]?.label ?? widget.shelfItems[index].label,
      color: widget.shelfItems != null
          ? widget.shelfItems[index]?.color ?? Colors.blueGrey
          : Colors.blueGrey,
      widget: widget?.shelfItems[index]?.content ??
          widget?.shelfItems[index]?.content,
    );
  }
}

/// This class is purely not meant to be externally or directly. It is used by the MyShelf class internally.
class _Item extends StatefulWidget {
  /// A callback which is fired when the item is opened.
  final ItemOpen isOpen;

  /// Whether to close the item or not.
  final bool close;
  final Text label;
  final Widget widget;
  final Color color;
  final double contentWidth;

  /// The width of the item when it is closed. __Note: Width of the item when it is closed must be less or equal to half of width of the content area.__
  final double width;
  final Curve openCloseAnimation;
  final Duration openCloseDuration;

  _Item({
    @required this.isOpen,
    this.close = false,
    this.label,
    this.widget,
    this.color = Colors.blueGrey,
    this.contentWidth = 100.0,
    this.width = 25.0,
    this.openCloseAnimation = Curves.easeIn,
    this.openCloseDuration = const Duration(milliseconds: 1500),
  }) {
    assert(
      width <= contentWidth / 2.0,
      'Label width must be less than content width',
    );
  }

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<_Item> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  /// Whether the item is open = 'true' or closed = 'false'. This internally controls what needs to be displayed within the item.
  bool _opened;

  @override
  void initState() {
    super.initState();

    _opened = false;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.openCloseDuration,
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween(
      begin: widget.width,
      end: widget.contentWidth,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.openCloseAnimation,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If item was open and is asked to close.
    if (widget.close && _animation.isCompleted) {
      _animationController.reverse();
      _opened = false;
    }

    return InkWell(
      onTap: () {
        setState(() {
          if (widget.close || _animation.isDismissed) {
            _animationController.forward();
            _opened = true;

            // Notify.
            widget.isOpen(true);
          } else {
            _animationController.reverse();
            _opened = false;

            // Notify.
            widget.isOpen(false);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(5.0),
        ),
        margin: EdgeInsets.all(1.0),
        width: _animation.value,
        child: RotatedBox(
          quarterTurns: _opened ? 0 : 3,
          child: _opened
              ? widget?.widget ?? Container()
              : Center(
                  child: widget?.label ??
                      Hero(
                        tag: 'label',
                        child: Text('Label'),
                      ),
                ),
        ),
      ),
    );
  }
}

/// The item to be used within the shelf.
class ShelfItem {
  /// The label to display when the item is closed.
  final Text label;

  /// The widget to display when the item is opened.
  final Widget content;

  /// Item color.
  final color;

  ShelfItem({this.label, this.content, this.color});
}
