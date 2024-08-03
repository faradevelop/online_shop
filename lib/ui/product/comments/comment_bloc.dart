import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/comment.dart';
import 'package:online_shop/data/repository/product_repository.dart';

part 'comment_event.dart';

part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final IProductRepository productRepository;

  CommentBloc(this.productRepository) : super(CommentLoading()) {
    on<CommentEvent>((event, emit) async {
      if (event is CommentStarted) {
        emit(CommentLoading());
        try {
          final comments = await productRepository.getComment(event.id);
          emit(CommentSuccess(comments));
        } catch (e) {
          emit(CommentError(exception: e is AppException ? e : AppException()));
        }
      } else if (event is AddCommentButtonClicked) {
        try {
          if (state is CommentSuccess) {
            final successState = (state as CommentSuccess);

            emit(CommentSuccess(successState.comments, isLoading: true));
          }
          await Future.delayed(const Duration(milliseconds: 1000));
          final res = await productRepository.addComment(
            event.productId,
            event.rate,
            event.comment,
          );

          if (state is CommentSuccess) {
           // final successState = (state as CommentSuccess);
            if (res) {
              final comments =
                  await productRepository.getComment(event.productId);
              emit(CommentSuccess(comments,commented: true));
            }else {
              emit(CommentError(exception: AppException()));
            }
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
