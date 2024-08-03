import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/model/comment.dart';
import 'package:online_shop/data/repository/product_repository.dart';
import 'package:online_shop/ui/product/comments/comment_bloc.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';
import 'package:online_shop/ui/widgets/snack_bar_widget.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, required this.productId});

  final int productId;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  CommentBloc? commentBloc;

  //late bool _loading;

  late StreamSubscription<CommentState> _subscription;

  @override
  void initState() {
    //_loading = false;
    super.initState();
  }

  @override
  void dispose() {
    commentBloc?.close();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            final bloc = CommentBloc(productRepository);
            commentBloc = bloc;
            bloc.add(CommentStarted(widget.productId));
            _subscription = bloc.stream.listen(
              (state) {
                if (state is CommentSuccess) {
                  if (state.commented) {
                    const String msg = "نظر شما با موفقیت ثبت شد";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: SnackBarContentWidget(
                              msg: msg,
                              icn: CupertinoIcons.check_mark_circled)),
                    );
                  }
                } else if (state is CommentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar(content: Text("خطا : ${state.exception.message}")),
                    const SnackBar(
                        content: SnackBarContentWidget(
                            msg: "خطا ",
                            icn: CupertinoIcons.exclamationmark_circle)),
                  );
                }
              },
            );

            return bloc;
          },
          child: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentSuccess) {
                return Stack(
                  children: [
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 80, 18, 100),
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CommentItem(
                            item: state.comments[index],
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 14),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: AppbarWidget(
                        title: 'نظرات',
                        backButton: true,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      right: 18,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return BlocProvider.value(
                                  value: commentBloc!,
                                  child: CommentBottomSheet(
                                    addComment: (rate, comment) {
                                      commentBloc!.add(AddCommentButtonClicked(
                                          widget.productId, rate, comment));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              });
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).primaryColor),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is CommentLoading) {
                return const LoadingWidget();
              } else if (state is CommentError) {
                return EmptyView(
                    message: "خطای نامشخص",
                    callToAction: ButtonWidget(
                        text: 'تلاش مجدد',
                        onPressed: () {
                          BlocProvider.of<CommentBloc>(context)
                              .add(CommentStarted(widget.productId));
                        }));
              } else {
                throw Exception('State is not supported');
              }
            },
          ),
        ),
      ),
    );
  }
}

class CommentBottomSheet extends StatefulWidget {
  const CommentBottomSheet({super.key, required this.addComment});

  final Function(int rate, String comment) addComment;

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController commentController = TextEditingController();
  late int rate = 1;

  void onRate(double value) {
    rate = value.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "ارسال نظر",
              style: themeData.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w900),
            ),
            Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  unratedColor: const Color(0xFFEDEDED),
                  itemBuilder: (context, index) => const Icon(
                    Iconsax.star1,
                    color: Color(0xFFF4D42D),
                  ),
                  onRatingUpdate: (rating) {
                    onRate(rating);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: commentController,
              maxLines: 6,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: themeData.hintColor, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: themeData.hintColor, width: 0.5),
                ),
                hintText: "نظر خود را وارد کنید",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonWidget(
              text: "ارسال نظر",
              onPressed: () {
                widget.addComment(rate, commentController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.item,
  });

  final CommentEntity item;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 16, 14),
      decoration: BoxDecoration(
        color: themeData.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: themeData.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.user ?? 'کاربر مهمان',
                style: themeData.textTheme.bodySmall!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const Spacer(),
              Directionality(
                textDirection: TextDirection.ltr,
                child: RatingBarIndicator(
                  rating: item.rate?.toDouble() ?? 2.5,
                  unratedColor: const Color(0xFFEDEDED),
                  itemBuilder: (context, index) => const Icon(
                    Iconsax.star1,
                    color: Color(0xFFF4D42D),
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                  direction: Axis.horizontal,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            item.date ?? "",
            style: themeData.textTheme.bodySmall,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            item.comment ?? "",
            style: themeData.textTheme.bodyLarge,
          ),
          Visibility(
            visible: item.reply != null,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    color: themeData.dividerColor,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'پاسخ : ',
                      style:
                          themeData.textTheme.bodySmall!.copyWith(fontSize: 18),
                    ),
                    Expanded(
                      child: Text(
                        item.reply ?? "",
                        style: themeData.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*

floatingActionButtonLocation:
FloatingActionButtonLocation.startFloat,
floatingActionButton: FloatingActionButton(
onPressed: () {
showModalBottomSheet(
isScrollControlled: true,
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(
top: Radius.circular(25),
),
),
context: context,
builder: (context) {
return BlocProvider.value(
value: commentBloc!,
child: CommentBottomSheet(
addComment: (rate, comment) {
print(rate);
print(comment);
print(widget.productId);
commentBloc!.add(AddCommentButtonClicked(
widget.productId, rate, comment));
Navigator.of(context).pop();
},
),
);
});
},
backgroundColor: Theme.of(context).primaryColor,
child: const Icon(Icons.add),
),*/
