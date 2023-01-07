part of 'notifications_bloc.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationEvent {
  final int? page;
  GetNotifications(this.page);
}

class GetUnreadCount extends NotificationEvent {
  GetUnreadCount();
}
