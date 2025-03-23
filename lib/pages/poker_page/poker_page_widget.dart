import '/flutter_flow/flutter_flow_ad_banner.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'poker_page_model.dart';
export 'poker_page_model.dart';

class PokerPageWidget extends StatefulWidget {
  const PokerPageWidget({super.key});

  static String routeName = 'pokerPage';
  static String routePath = '/pokerPage';

  @override
  State<PokerPageWidget> createState() => _PokerPageWidgetState();
}

class _PokerPageWidgetState extends State<PokerPageWidget> {
  late PokerPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PokerPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.93,
                  child: custom_widgets.PokerGame(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 0.93,
                  ),
                ),
              ),
              FlutterFlowAdBanner(
                height: MediaQuery.sizeOf(context).height * 0.07,
                showsTestAd: false,
                androidAdUnitID: 'ca-app-pub-6843318091304139/4315870711',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
