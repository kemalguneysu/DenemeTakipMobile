import 'package:mobil_denemetakip/constants/layout.dart';
import 'package:mobil_denemetakip/main.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
void successToast(String title, String subtitle, BuildContext context) {
  showToast(
      context: Navigator.of(context).context,
      builder: (context, overlay) {
        return SurfaceCard(
          borderWidth:2,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Basic(
            title: Container(
              child: Text(
                '$title',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                '$subtitle',
                style: TextStyle(fontSize: 14,),
              ),
            ),
          ),
        );
      },
      location: ToastLocation.bottomCenter);
}

void errorToast(String title,String subtitle,BuildContext context) {
  showToast(
      context: Navigator.of(context).context,
      builder: (context, overlay) {
         return SurfaceCard(
          filled: true,
          fillColor: Colors.red,
          borderWidth: 2,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Basic(
            title: Container(
              child: Text('$title',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                '$subtitle',
                style: TextStyle(fontSize: 14,color: Colors.white),
              ),
            ),
          ),
        );
      },
      location: ToastLocation.bottomCenter);
}


