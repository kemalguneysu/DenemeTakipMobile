import 'package:shadcn_flutter/shadcn_flutter.dart';

Widget buildToast(BuildContext context, ToastOverlay overlay) {
  return SurfaceCard(
    child: Basic(
      title: Container(
        child: Text("title",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,decoration: TextDecoration.none),),
      ),
      subtitle: Container(
        padding: EdgeInsets.only(top: 10),
        child: Text("subtitle",style: TextStyle(fontSize: 14,decoration: TextDecoration.none),),
      ),
    ),
  );
}
