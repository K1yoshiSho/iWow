import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_wow/components/global/http_query.dart';
import 'package:i_wow/components/global/snackbar.dart';
import 'package:i_wow/components/widgets/card_widget.dart';
import 'package:i_wow/components/widgets/loading.dart';
import 'package:i_wow/notifications/bloc/notifications_bloc.dart';
import 'package:i_wow/notifications/models/notifications.dart';
import '../../components/widgets/custon_icon_button.dart';
import '../../components/style/theme.dart';
import 'package:flutter/material.dart';

class NotificationsListWidget extends StatefulWidget {
  final UnreadCount unreadCount;
  NotificationsListWidget({Key? key, required this.unreadCount}) : super(key: key);

  @override
  _NotificationsListWidgetState createState() => _NotificationsListWidgetState();
}

class _NotificationsListWidgetState extends State<NotificationsListWidget> {
  // BloC
  late NotificationBloc notificationBloc;

  // Main fields
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Notifications notifications;
  List<Data> dataList = [];
  late ScrollController _controller;

  // Read all field
  bool allReaded = true;

  // Pagination fields
  int _page = 1;
  int _limit = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  @override
  void initState() {
    _controller = ScrollController()..addListener(_loadMore);
    notificationBloc = NotificationBloc();
    if (widget.unreadCount.count != 0) {
      setState(() {
        allReaded = false;
      });
    }
    _firstLoad();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isPortrait ? 70 : 40),
        child: buildAppBar(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        if (allReaded == false) {
                          await HttpQuery().post(
                            url: '/notifications/mark-read',
                          );
                          dataList.clear();
                          _firstLoad();
                          setState(() {
                            allReaded = true;
                          });
                        } else {
                          SnackBarManager(duration: 1500).informSnackBar(context, "Нет непрочитанных уведомлений ;)");
                        }
                      }, // Action
                      child: Ink(
                        height: isPortrait
                            ? MediaQuery.of(context).size.height * 0.035
                            : MediaQuery.of(context).size.width * 0.035,
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Отметить все как прочитанные',
                                textAlign: TextAlign.center,
                                style: AppTheme.of(context).bodyText1.copyWith(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<NotificationBloc, NotificationState>(
                bloc: notificationBloc,
                listener: (context, state) {
                  if (state is FetchedNotificationsState) {
                    setState(() {
                      notifications = state.notifications;
                      _limit = notifications.meta.lastPage!;
                      if (state.notifications.data != null) dataList = state.notifications.data!;
                    });
                  } else if (state is FailureNotificationsState) {
                    SnackBarManager(duration: 1500).failureSnackBar(context, state.error);
                  }
                },
                builder: (context, state) {
                  if (state is FetchedNotificationsState) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.77,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: _controller,
                              itemCount: dataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CardWidget(
                                  index: index,
                                  singleData: dataList[index],
                                );
                              },
                            ),
                          ),
                        ),
                        if (_isLoadMoreRunning == true)
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 40),
                            child: Center(
                              child: loadingWidget(context),
                            ),
                          ),
                      ],
                    );
                  } else if (state is LoadingNotificationsState) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.77,
                        child: ShimmerList(
                          shimmerColor: Colors.grey,
                          count: 10,
                          height: MediaQuery.of(context).size.height * 0.12,
                        ),
                      ),
                    );
                  } else if (state is FailureNotificationsState) {
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
    );
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    notificationBloc.add(GetNotifications(_page));
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        if (_page <= _limit) {
          dynamic data = await HttpQuery().get(
            url: '/notifications?page=$_page',
          );
          Notifications temp = Notifications.fromJson(data);
          List<Data> fetchedPosts = [];
          fetchedPosts.addAll(temp.data!);
          if (fetchedPosts.isNotEmpty) {
            setState(() {
              dataList.addAll(fetchedPosts);
            });
          }
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print(err);
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      backgroundColor: AppTheme.of(context).primaryBackground,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            borderColor: Colors.transparent,
            borderRadius: 4,
            buttonSize: 40,
            borderWidth: 1,
            icon: SvgPicture.asset(
              'assets/images/arrow_left.svg',
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          Text(
            'Уведомления',
            style: TextStyle(
              fontFamily: 'Roboto',
              color: AppTheme.of(context).primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          emptyButton(),
        ],
      ),
      actions: [],
      centerTitle: false,
      elevation: 0,
    );
  }
}
