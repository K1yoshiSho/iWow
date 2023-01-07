import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_wow/components/global/global_functions.dart';
import 'package:i_wow/components/global/snackbar.dart';
import 'package:i_wow/components/style/theme.dart';
import 'package:i_wow/notifications/bloc/notifications_bloc.dart';
import 'package:i_wow/notifications/models/notifications.dart';
import 'package:i_wow/notifications/screens/notifications_list_widget.dart';
import 'package:shimmer/shimmer.dart';

class InitialPageWidget extends StatefulWidget {
  const InitialPageWidget({Key? key}) : super(key: key);

  @override
  _InitialPageWidgetState createState() => _InitialPageWidgetState();
}

class _InitialPageWidgetState extends State<InitialPageWidget> {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late NotificationBloc counterBloc;
  late UnreadCount unreadCount;

  @override
  void initState() {
    counterBloc = NotificationBloc();
    counterBloc.add(GetUnreadCount());
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  void dispose() {
    counterBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: buildAppBar(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 40, 16, 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      width: 2,
                      color: AppTheme.of(context).lineColor,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        BlocConsumer<NotificationBloc, NotificationState>(
                          bloc: counterBloc,
                          listener: (context, state) {
                            if (state is FetchedCountState) {
                              setState(() {
                                unreadCount = state.unread;
                              });
                            } else if (state is FailureCountState) {
                              SnackBarManager(duration: 1500).failureSnackBar(context, state.error);
                            }
                          },
                          builder: (context, state) {
                            if (state is FetchedCountState) {
                              return cardWidget(context, 'assets/images/Union.svg', 'Уведомления', () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.scale,
                                    alignment: Alignment.center,
                                    duration: Duration(milliseconds: 250),
                                    reverseDuration: Duration(milliseconds: 250),
                                    child: NotificationsListWidget(
                                      unreadCount: unreadCount,
                                    ),
                                  ),
                                ).then((value) => setState(() async {
                                      counterBloc.add(GetUnreadCount());
                                    }));
                              });
                            } else if (state is LoadingCountState) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                    )),
                              );
                            } else if (state is FailureCountState) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  state.error,
                                  style: AppTheme.of(context).bodyText1.copyWith(
                                        fontFamily: 'Roboto',
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardWidget(BuildContext context, String svgIcon, String title, Function() onTap) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: InkWell(
        splashColor: AppTheme.of(context).lineColor,
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8, 16, 8, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        SvgPicture.asset(
                          svgIcon,
                          width: 25,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                        unreadCount.count! > 0
                            ? Positioned(
                                right: 0,
                                top: -3,
                                child: Badge(
                                  badgeContent: Text(
                                    '',
                                    style: AppTheme.of(context).bodyText1.copyWith(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                  showBadge: true,
                                  shape: BadgeShape.circle,
                                  badgeColor: AppTheme.of(context).badgeColor,
                                  elevation: 0,
                                  position: BadgePosition.topEnd(),
                                  animationType: BadgeAnimationType.scale,
                                  toAnimate: true,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(22, 0, 0, 0),
                      child: Text(
                        title,
                        style: AppTheme.of(context).bodyText1.copyWith(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  'assets/images/arrow_rigth.svg',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.of(context).primaryBackground,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          'Мой профиль',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: AppTheme.of(context).primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actions: [],
      centerTitle: true,
      elevation: 0,
    );
  }
}
