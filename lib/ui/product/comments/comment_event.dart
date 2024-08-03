part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

class CommentStarted extends CommentEvent {
  final int id;

  CommentStarted(this.id);
}

class AddCommentButtonClicked extends CommentEvent {
  final int productId;
  final int rate;
  final String comment;

  AddCommentButtonClicked(this.productId, this.rate, this.comment);
}
