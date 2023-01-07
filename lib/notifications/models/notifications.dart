// Notifications

class Notifications {
  final List<Data>? data;
  final Links links;
  final Meta meta;

  Notifications({
    this.data,
    required this.links,
    required this.meta,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    List<Data> dataList = [];
    for (var data in (json['data'] as List)) {
      dataList.add(Data.fromJson(data));
    }
    return Notifications(
      data: dataList,
      links: Links.fromJson(json['links']),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

// Notifications data

class Data {
  final int id;
  final String? title;
  final String? description;
  final String? imageUrl;
  bool isRead;
  final String? createdAt;

  Data({
    required this.id,
    this.title,
    this.description,
    this.imageUrl,
    required this.isRead,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['image_url'] ?? null,
        isRead: json['is_read'],
        createdAt: json['notified_at']);
  }
}

// Notifications links

class Links {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}

// Notifications meta

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      total: json['total'],
    );
  }
}

// Notifications unread

class UnreadCount {
  final int? count;

  UnreadCount({
    this.count,
  });

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    return UnreadCount(count: json['count'] ?? 0);
  }
}
