part of 'comment_bloc.dart';

@immutable
sealed class CommentState {}

class CommentLoading extends CommentState {}

class CommentSuccess extends CommentState {
  final List<CommentEntity> comments;
  final bool isLoading;
  final bool commented;

  CommentSuccess(this.comments,
      {this.isLoading = false, this.commented = false});
}

class CommentError extends CommentState {
  final AppException exception;

  CommentError({required this.exception});
}

class AddCommentButtonSuccess extends CommentState {
  final List<CommentEntity> comments;

  AddCommentButtonSuccess(this.comments);
}

class AddCommentButtonLoading extends CommentState {}

class AddCommentButtonError extends CommentState {
  final AppException exception;

  AddCommentButtonError(this.exception);
}
