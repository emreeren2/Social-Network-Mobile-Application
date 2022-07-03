import 'package:cs310_project_s2/utils/color.dart';
import 'package:flutter/cupertino.dart';

class CommentCard extends StatelessWidget {
  final String post;
  CommentCard({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primary),
      ),     
      child: Row(
        children: <Widget>[
          Text(
            'asd'
          ),
        ],
      ), 
    );
  }
}