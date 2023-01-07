import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_wow/components/global/http_query.dart';
import 'package:i_wow/notifications/bloc/notifications_bloc.dart';
import 'package:i_wow/notifications/models/notifications.dart';

class NotificationsRepository {
  Future<void> getNotificationsInfo(GetNotifications event, Emitter<NotificationState> emit) async {
    try {
      emit(LoadingNotificationsState());
      dynamic data = await HttpQuery().get(
        url: '/notifications?page=${event.page}',
      );
      emit(FetchedNotificationsState(Notifications.fromJson(data)));
    } on DioError catch (e) {
      emit(FailureNotificationsState(e.message));
    } catch (e) {
      emit(FailureNotificationsState(e.toString()));
    }
  }

  Future<void> getUnreadInfo(GetUnreadCount event, Emitter<NotificationState> emit) async {
    try {
      emit(LoadingCountState());
      dynamic data = await HttpQuery().get(
        url: '/notifications/unread-count',
      );
      emit(FetchedCountState(UnreadCount.fromJson(data)));
    } on DioError catch (e) {
      emit(FailureCountState(e.message));
    } catch (e) {
      emit(FailureCountState(e.toString()));
    }
  }
}
