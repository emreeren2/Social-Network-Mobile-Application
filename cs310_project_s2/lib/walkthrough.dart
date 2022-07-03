import 'package:cs310_project_s2/utils/color.dart';
import 'package:flutter/material.dart';

class PageList{
  String mainTitle;
  String title;
  String url;
  String caption;


  PageList({this.mainTitle, this.title, this.url, this.caption});
}

class WalkThrough extends StatefulWidget {
  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State{

List <PageList> pages= [
  PageList(mainTitle: 'WELCOME', title: 'Welcome to our app', url: 'https://media.istockphoto.com/vectors/icon-vector-id609810734?b=1&k=6&m=609810734&s=612x612&w=0&h=a-gUPul1glnv0q2Qwm8Dy4NCY9P2-fOBbmuHI_LqIbM=', caption: 'Push next and see our features'),
  PageList(mainTitle: 'INTRO', title: 'Learn new things', url: 'https://thumbs.dreamstime.com/b/learning-icon-flat-style-open-book-symbol-learning-icon-flat-style-open-book-symbol-isolated-white-background-simple-114365319.jpg', caption: 'Do not spend your time to needless posts'),
  PageList(mainTitle: 'PROFILES', title: 'Create your account', url: 'https://previews.123rf.com/images/bsd555/bsd5551909/bsd555190901994/130215118-create-account-blue-concept-icon-network-profile-registration-idea-thin-line-illustration-new-user-w.jpg', caption: 'Share your knowledge with others'),
  PageList(mainTitle: 'CONTENT', title: 'Meet new people', url: 'https://static.thenounproject.com/png/62507-200.png', caption: 'Connect with your friends'),
];

int totalPage = 4;
int currentPage = 1;


  void nextPage() {
    setState(() {
      currentPage++;
      if(currentPage == 5){
        currentPage = 4;
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  void prevPage() {
    setState(() {
      currentPage--;
      if(currentPage == 0){
        currentPage = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          pages[currentPage-1].mainTitle,
          style: TextStyle(
            color: AppColors.textWhite,
            wordSpacing: -1,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(10.0),
          child: 
            Column( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Text(
                pages[currentPage-1].title,
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w800,
                  wordSpacing: -1,
                ),
              ),
                CircleAvatar(
                  backgroundImage: NetworkImage(pages[currentPage-1].url),
                  backgroundColor: AppColors.textWhite,
                  radius: 140.0,
                ),

                Text(
                   pages[currentPage-1].caption,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1,                   
                    color: AppColors.secondary,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      //color: AppColors.box,
                      decoration: BoxDecoration(
                      /*  border: Border.all(
                          color: AppColors.primary,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(18))*/
                      ),
                      child: TextButton(

                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.box),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {prevPage();},
                        child: Text(
                          'prev',
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    
                    Text(
                      '$currentPage/$totalPage',
                        style: TextStyle(
                          color: AppColors.primary,
                        ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        /*border: Border.all(
                          color: AppColors.primary,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(18))*/
                      ),                      
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.box),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {nextPage();},
                        child: Text(
                          'next',
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
      ),
    );
  }
}