import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:i_wow/notifications/models/notifications.dart';
import 'package:i_wow/notifications/resource/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationsRepository _repository = NotificationsRepository();
  NotificationBloc() : super(NotificationsInitial()) {
    on<GetNotifications>(_repository.getNotificationsInfo);
    on<GetUnreadCount>(_repository.getUnreadInfo);
  }
}
