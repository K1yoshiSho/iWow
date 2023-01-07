part of 'notifications_bloc.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial states
class NotificationsInitial extends NotificationState {}

class CountInitial extends NotificationState {}

// Loading states
class LoadingNotificationsState extends NotificationState {}

class LoadingCountState extends NotificationState {}

// Failure states

class FailureNotificationsState extends NotificationState {
  final String error;
  FailureNotificationsState(this.error);
}

class FailureCountState extends NotificationState {
  final String error;
  FailureCountState(this.error);
}

// Fetched states

class FetchedNotificationsState extends NotificationState {
  final Notifications notifications;
  FetchedNotificationsState(this.notifications);
}

class FetchedCountState extends NotificationState {
  final UnreadCount unread;
  FetchedCountState(this.unread);
}
