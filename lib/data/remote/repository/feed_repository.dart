import 'dart:developer';

import 'package:creative_movers/constants/enpoints.dart';
import 'package:creative_movers/data/remote/model/feed_response.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/data/remote/model/like_response.dart';
import 'package:creative_movers/data/remote/model/post_comments_response.dart';
import 'package:creative_movers/data/remote/model/server_error_model.dart';
import 'package:creative_movers/data/remote/model/state.dart';
import 'package:creative_movers/helpers/api_helper.dart';
import 'package:creative_movers/helpers/http_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FeedRepository {
  final HttpHelper httpHelper;

  FeedRepository(this.httpHelper);

  Future<State> adFeed({
    required String type,
    String? page_id,
    required String content,
    required List<String> media,
  }) async {
    var formData = FormData.fromMap({
      "type": type,
      "page_id": page_id,
      "content": content,
    });
    log("IMAGES: $media");
    for (var file in media) {
      formData.files.addAll([
        MapEntry("media", await MultipartFile.fromFile(file)),
      ]);
    }
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.addFeedEndpoint, body: formData),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: response.data['message']),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER:$response');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> getFeeds() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.fetchFeedEndpoint),
      successResponse: (data) {
        return State<FeedsResponse?>.success(
            data != null ? FeedsResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> getFeedItem(int feedId) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.feedItem, body: {"feed_id": feedId}),
      successResponse: (data) {
        return State<Feed?>.success(
            data != null ? Feed.fromJson(data['feeds']) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> postComments(
      {required String feed_id, required String comment}) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.commentEndpoint, body: {
        "feed_id": feed_id,
        "comment": comment,
      }),
      successResponse: (data) {
        return State<PostCommentResponse?>.success(
            data != null ? PostCommentResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> postLike({required String feed_id}) async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.likeEndpoint, body: {
        "feed_id": feed_id,
      }),
      successResponse: (data) {
        return State<LikeResponse?>.success(
            data != null ? LikeResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> getLike() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.addFeedEndpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> getComments() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.addFeedEndpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> getReplies() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.addFeedEndpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> replyComment() async {
    return SimplifyApiConsuming.makeRequest(
      () => httpHelper.post(Endpoints.addFeedEndpoint),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> deletePost({required String feed_id}) async {
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.deleteFeedEndpoint,body: {
        "feed_id": feed_id,

      }),
      successResponse: (data) {
        return State<LikeResponse?>.success(
            data != null ? LikeResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: null),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }

  Future<State> editFeed({
    String? page_id,
    required String feed_id,
    required String content,
    // required List<String> media,
  }) async {
    var formData = FormData.fromMap({
      "type" :'user_feed',
      "page_id" :page_id,
      "feed_id" :feed_id,
      "content" :content,
    });
    // log("IMAGES: $media");
    // for (var file in media) {
    //   formData.files.addAll([
    //     MapEntry("media", await MultipartFile.fromFile(file)),
    //   ]);
    // }
    return SimplifyApiConsuming.makeRequest(
          () => httpHelper.post(Endpoints.editFeedEndpoint, body:formData),
      successResponse: (data) {
        return State<AddFeedResponse?>.success(
            data != null ? AddFeedResponse.fromJson(data) : null);
      },
      statusCodeSuccess: 200,
      errorResponse: (response) {
        debugPrint('ERROR SERVER');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data.toString(),
              data: response.data['message']),
        );
      },
      dioErrorResponse: (response) {
        debugPrint('DIO SERVER:$response');
        return State<ServerErrorModel>.error(
          ServerErrorModel(
              statusCode: response.statusCode!,
              errorMessage: response.data['message'],
              data: null),
        );
      },
    );
  }
}
