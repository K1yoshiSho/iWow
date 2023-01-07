import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:i_wow/components/global/global_functions.dart';
import 'package:i_wow/components/global/http_query.dart';
import 'package:i_wow/components/style/theme.dart';
import 'package:i_wow/notifications/models/notifications.dart';
import 'package:i_wow/notifications/screens/single_notification_widget.dart';

class CardWidget extends StatefulWidget {
  final Data singleData;
  final int index;
  CardWidget({Key? key, required this.singleData, required this.index});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  Data get singleData => widget.singleData;
  int get index => widget.index;
  bool isRead = false;

  @override
  void initState() {
    isRead = singleData.isRead;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          bool readed = false;
          if (singleData.isRead != true) {
            await HttpQuery().post(url: '/notifications/mark-read', data: {"id": singleData.id});
            setState(() {
              isRead = true;
              print(readed);
            });
          }
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: Duration(milliseconds: 250),
              reverseDuration: Duration(milliseconds: 250),
              child: SingleNotificationWidget(
                singleData: singleData,
              ),
            ),
          );
        },
        child: Container(
          width: 100,
          height: isPortrait ? MediaQuery.of(context).size.height * 0.12 : MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead ? AppTheme.of(context).lineColor : AppTheme.of(context).borderCard,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Hero(
                  tag: singleData.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (singleData.imageUrl != null)
                        ? CachedNetworkImage(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: isPortrait
                                ? MediaQuery.of(context).size.height * 0.09
                                : MediaQuery.of(context).size.width * 0.12,
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
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: isPortrait
                                ? MediaQuery.of(context).size.height * 0.09
                                : MediaQuery.of(context).size.width * 0.12,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  singleData.title ?? "Нет значений",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: AppTheme.of(context).bodyText1.copyWith(
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  singleData.createdAt != null
                                      ? dateTimeFormat(
                                          'relative',
                                          stringToDateTime(singleData.createdAt!),
                                          locale: "ru",
                                        )
                                      : "Нет значений",
                                  maxLines: 1,
                                  style: AppTheme.of(context).bodyText1.copyWith(
                                        fontFamily: 'Roboto',
                                        color: Color(0xFF9A9A9A),
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
