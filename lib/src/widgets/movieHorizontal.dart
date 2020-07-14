import 'package:flutter/material.dart';
import 'package:peliculas/src/class/pelicula_class.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientPage;

  MovieHorizontal({@required this.peliculas, @required this.siguientPage});
  final _pageController = new PageController(
    initialPage: 0,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final screnSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 100) {
        siguientPage();
      }
    });

    return Container(
      height: screnSize.height * 0.2,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 13.0),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (BuildContext context, int index) {
          return _tarjeta(context, peliculas[index]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    final peliTarjeta = Container(
      width: 100.0,
      margin: EdgeInsets.only(right: 15.0),
      height: 200,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              height: 150,
              image: NetworkImage(pelicula.getPosertImg()),
              placeholder: AssetImage('assets/images/no-image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: peliTarjeta,
      onTap: () {
        print(pelicula.id);
        Navigator.pushNamed(context, '/detalle', arguments: pelicula);
      },
    );
  }

  // List<Widget> _tarjetas(context) {
  //   return peliculas.map((pelicula) {
  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),
  //       height: 200,
  //       child: Column(
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20.0),
  //             child: FadeInImage(
  //               height: 150,
  //               image: NetworkImage(pelicula.getPosertImg()),
  //               placeholder: AssetImage('assets/images/no-image.jpg'),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           SizedBox(height: 5.0),
  //           Text(
  //             pelicula.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
