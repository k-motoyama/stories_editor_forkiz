// ignore_for_file: must_be_immutable
library stories_editor;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/gradient_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/keyboard_height_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/language_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/main_view/main_view.dart';

export 'package:stories_editor/stories_editor.dart';

class StoriesEditor extends StatefulWidget {
  /// editor custom font families
  final List<String>? fontFamilyList;

  /// editor custom font families package
  final bool? isCustomFontList;

  /// giphy api key
  final String giphyKey;

  /// editor custom color gradients
  final List<List<Color>>? gradientColors;

  /// editor custom logo
  final Widget? middleBottomWidget;

  /// on done
  final Function(String, bool)? onDone;

  /// on done button Text
  final Widget? onDoneButtonStyle;

  /// on back pressed
  final Future<bool>? onBackPress;

  /// editor custom color palette list
  final List<Color>? colorList;

  /// editor background color
  final Color? editorBackgroundColor;

  /// gallery thumbnail quality
  final int? galleryThumbnailQuality;

  /// To select a photo first and move it to the editor
  final String? initialImagePath;

  final bool? isInitialImageLocked;

  final String? onDoneButtonTitle;

  final String? showAddImageButtonTitle;

  final int? colorDefaultOffsetIndex;

  final Color? placeholderColor;

  final String? languageCode;

  const StoriesEditor({
    super.key,
    required this.giphyKey,
    required this.onDone,
    this.middleBottomWidget,
    this.colorList,
    this.gradientColors,
    this.fontFamilyList,
    this.isCustomFontList,
    this.onBackPress,
    this.onDoneButtonStyle,
    this.editorBackgroundColor,
    this.galleryThumbnailQuality,
    this.initialImagePath,
    this.isInitialImageLocked,
    this.onDoneButtonTitle,
    this.showAddImageButtonTitle,
    this.colorDefaultOffsetIndex,
    this.placeholderColor,
    this.languageCode,
  });

  @override
  StoriesEditorState createState() => StoriesEditorState();
}

class StoriesEditorState extends State<StoriesEditor> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (_, __) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ControlNotifier()),
            ChangeNotifierProvider(create: (_) => ScrollNotifier()),
            ChangeNotifierProvider(create: (_) => DraggableWidgetNotifier()),
            ChangeNotifierProvider(create: (_) => GradientNotifier()),
            ChangeNotifierProvider(create: (_) => PaintingNotifier()),
            ChangeNotifierProvider(create: (_) => TextEditingNotifier()),
            ChangeNotifierProvider(create: (_) => KeyboardHeightNotifier()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ],
          child: Consumer<KeyboardHeightNotifier>(
              builder: (context, keyboard, __) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              keyboard.keyboardHeight = keyboardHeight;
            });
            return MainView(
              giphyKey: widget.giphyKey,
              onDone: widget.onDone,
              fontFamilyList: widget.fontFamilyList,
              isCustomFontList: widget.isCustomFontList,
              middleBottomWidget: widget.middleBottomWidget,
              gradientColors: widget.gradientColors,
              colorList: widget.colorList,
              onDoneButtonStyle: widget.onDoneButtonStyle,
              onBackPress: widget.onBackPress,
              editorBackgroundColor: widget.editorBackgroundColor,
              galleryThumbnailQuality: widget.galleryThumbnailQuality,
              initialImagePath: widget.initialImagePath,
              isInitialImageLocked: widget.isInitialImageLocked,
              onDoneButtonTitle: widget.onDoneButtonTitle,
              showAddImageButtonTitle: widget.showAddImageButtonTitle,
              colorDefaultOffsetIndex: widget.colorDefaultOffsetIndex,
              placeholderColor: widget.placeholderColor,
              languageCode: widget.languageCode ?? 'en',
            );
          }),
        ),
      ),
    );
  }
}
