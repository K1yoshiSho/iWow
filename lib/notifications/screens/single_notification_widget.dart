import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_wow/components/global/global_functions.dart';
import 'package:i_wow/components/widgets/image_view.dart';
import 'package:i_wow/notifications/models/notifications.dart';
import '../../components/widgets/custon_icon_button.dart';
import '../../components/style/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SingleNotificationWidget extends StatefulWidget {
  final Data singleData;
  SingleNotificationWidget({Key? key, required this.singleData}) : super(key: key);

  @override
  _SingleNotificationWidgetState createState() => _SingleNotificationWidgetState();
}

class _SingleNotificationWidgetState extends State<SingleNotificationWidget> {
  final _unfocusNode = FocusNode();
  final widgetKey = GlobalKey<ScaffoldState>();
  Data get singleData => widget.singleData;
  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widgetKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: CustomIconButton(
                borderColor: Colors.transparent,
                borderRadius: 4,
                buttonSize: 40,
                borderWidth: 1,
                icon: SvgPicture.asset(
                  'assets/images/arrow_left.svg',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: AppTheme.of(context).primaryColor,
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            collapsedHeight: MediaQuery.of(context).size.height * 0.15,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SelectionArea(
                              child: Text(
                            singleData.title ?? "Нет значений",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTheme.of(context).bodyText1.copyWith(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                          )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: SelectionArea(
                                child: AutoSizeText(
                              singleData.createdAt != null
                                  ? dateTimeFormat(
                                      'relative',
                                      stringToDateTime(singleData.createdAt!),
                                      locale: "ru",
                                    )
                                  : "Нет значений",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.of(context).bodyText1.copyWith(
                                    fontFamily: 'Roboto',
                                    color: AppTheme.of(context).lineColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              background: InkWell(
                onTap: () async {
                  print('tap');
                  if (singleData.imageUrl != null) {
                    await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          alignment: Alignment.bottomCenter,
                          duration: const Duration(milliseconds: 100),
                          reverseDuration: const Duration(milliseconds: 100),
                          child: DoubleTappableInteractiveViewer(
                            scaleDuration: const Duration(milliseconds: 600),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.6,
                              fadeInDuration: const Duration(milliseconds: 0),
                              fadeOutDuration: const Duration(milliseconds: 0),
                              placeholder: (context, url) => Image.asset(
                                'assets/images/placeholder.webp',
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.contain,
                              imageUrl: singleData.imageUrl!,
                            ),
                          ),
                        ));
                  }
                },
                child: Hero(
                  tag: singleData.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                      child: singleData.imageUrl != null
                          ? CachedNetworkImage(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.6,
                              fadeInDuration: const Duration(milliseconds: 0),
                              fadeOutDuration: const Duration(milliseconds: 0),
                              placeholder: (context, url) => Image.asset(
                                'assets/images/placeholder.webp',
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                              imageUrl: singleData.imageUrl!,
                            )
                          : Image.asset(
                              'assets/images/placeholder.webp',
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.6,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            fillOverscroll: true,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectionArea(child: Text(singleData.description ?? "")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
