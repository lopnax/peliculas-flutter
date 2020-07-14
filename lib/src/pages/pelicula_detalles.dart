import 'package:flutter/material.dart';
import 'package:peliculas/src/class/actores_class.dart';
import 'package:peliculas/src/class/pelicula_class.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula, context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 5.0,
                ),
                _detallesPelicula(context, pelicula),
                _descripcionPelicula(pelicula),
                _crearActores(pelicula),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula, context) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      // expandedHeight: MediaQuery.of(context).size.height,
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/images/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _detallesPelicula(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              height: 150.0,
              image: NetworkImage(
                pelicula.getPosertImg(),
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  pelicula.releaseDate,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star_border,
                      color: Colors.black54,
                    ),
                    Text(
                      pelicula.voteAverage.toString(),
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripcionPelicula(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearActores(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresListView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresListView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        scrollDirection: Axis.horizontal,
        itemCount: actores.length,
        itemBuilder: (context, index) {
          return _actorTarjeta(actores[index]);
        },
        controller: PageController(
          initialPage: 0,
          keepPage: true,
          viewportFraction: 0.3,
        ),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.0),
      width: 100.0,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: NetworkImage('https://s3.amazonaws.com/37assets/svn/765-default-avatar.png'),
              image: NetworkImage(actor.getProfileImg()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
