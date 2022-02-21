part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
}

class AddFeedEvent extends FeedEvent {
  String type;
  String? pageId;
  String content;
  List<String> media;


  AddFeedEvent({required this.type, this.pageId, required this.content, required this.media});

  @override
  // TODO: implement props
  List<Object?> get props => [type,pageId,content,media];
}