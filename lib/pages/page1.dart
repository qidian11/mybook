import 'package:flutter/material.dart';
import 'components/page1/todo_swiper.dart';
import 'components/page1/date_card.dart';
import 'detail_page/detail.dart';
import 'components/page1/add_button.dart';
import '../../UI/ui_size.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with AutomaticKeepAliveClientMixin {
  double appBarHeight = 48;

  @override
  Widget build(BuildContext context) {
    Size mSize = MediaQuery.of(context).size;
    PageController controller =
        new PageController(viewportFraction: 0.7, keepPage: true);
    final pages = List.generate(6, (index) {
      return Container(
        width: 50,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        color: Colors.white,
        child: Text("$index"),
      );
    });
    return Container(
        // color: Colors.greenAccent,
        width: mSize.width,
        height: mSize.height,
        child: Stack(
          children: [
            DateCard(),
            Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  // color: Colors.orangeAccent,
                  width: MediaQuery.of(context).size.width,
                  height: FOOTER_HEIGHT,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xFFEEEEEE))),
                  ),
                )),
            Positioned(
              left: 0,
              // top: 0,
              top: (mSize.height -
                          APP_BAR_HEIGHT -
                          DATE_CARD_HEIGHT -
                          FOOTER_HEIGHT -
                          FRACTION * mSize.width) /
                      2.0 +
                  DATE_CARD_HEIGHT,
              child: TodoSwiper(
                type: "todo",
                key: ValueKey(1),
              ),
            ),
            Positioned(
              bottom: FOOTER_HEIGHT - APP_BAR_HEIGHT / 2.0,
              left: 0,
              right: 0,
              child: Center(
                // FloatingActionButton的大小会自动扩展至父容器 因此要加以限制
                child: Container(
                  // color: Colors.deepPurpleAccent,
                  width: 80,
                  child: AddButton(),
                ),
              ),
            ),
            // Positioned(
            //   top: 0,
            //   // top: (MediaQuery.of(context).size.height -
            //   //             appBarHeight -
            //   //             120 -
            //   //             100 -
            //   //             0.75 * MediaQuery.of(context).size.width) /
            //   //         2.0 +
            //   //     120 +
            //   //     appBarHeight,
            //   left: 0,
            //   child: Detail(mSize),
            // ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
