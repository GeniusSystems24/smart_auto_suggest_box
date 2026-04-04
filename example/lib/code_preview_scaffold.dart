import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodePreviewScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final String code;

  const CodePreviewScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Preview', icon: Icon(Icons.preview)),
              Tab(text: 'Code', icon: Icon(Icons.code)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Preview Tab
            SafeArea(child: child),
            // Code Tab
            SafeArea(
              child: Stack(
                children: [
                  SyntaxView(
                    code: code,
                    syntax: Syntax.DART,
                    syntaxTheme: Theme.of(context).brightness == Brightness.dark
                        ? SyntaxTheme.vscodeDark()
                        : SyntaxTheme.vscodeLight(),
                    fontSize: 12.0,
                    withZoom: true,
                    withLinesCount: true,
                    expanded: true,
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Builder(
                      builder: (context) {
                        return FloatingActionButton.small(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نسخ الكود!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          tooltip: 'نسخ الكود',
                          child: const Icon(Icons.copy, size: 20),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
