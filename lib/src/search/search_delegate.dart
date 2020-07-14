import 'package:flutter/material.dart';
import 'package:peliculas/src/class/pelicula_class.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculasProvider = new PeliculasProvider();

  final buscadasAntes = new List<Pelicula>();

  // Para cambiar el texto de Buscar es necesario cambiar parte de la documentacion --> https://stackoverflow.com/questions/54518741/flutter-change-search-hint-text-of-searchdelegate
  @override
  String get searchFieldLabel => 'Buscar...';

  @override
  List<Widget> buildActions(BuildContext context) {
    // Icono de cancelar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono de la izquierda
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        Navigator.pop(context);
        print("leading");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando vas escribiendo

    if (query.isEmpty) {
      if (buscadasAntes.isEmpty) {
        return Center(
          child: Text(
            '🤷🏼‍♂️No hay búsquedas anteriores',
            style: TextStyle(fontSize: 20),
          ),
        );
      }
      return ListView(
        children: peliculasBuscadas(context),
      );
    }
    return FutureBuilder(
      future: peliculasProvider.searchPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 100.0,
            child: ListView(
              itemExtent: 100.0,
              children: snapshot.data.map((peli) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/no-image.jpg'),
                      image: NetworkImage(
                        peli.getPosertImg(),
                      ),
                    ),
                  ),
                  title: Text(
                    peli.title,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    peli.releaseDate,
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    // close(context, null); //esto cierra la busqueda cuando pulso en la pelicula
                    if (buscadasAntes.indexOf(peli) > -1) {
                      buscadasAntes.remove(peli);
                    }
                    peliculasBuscadas(context);
                    buscadasAntes.add(peli);
                    Navigator.pushNamed(context, '/detalle', arguments: peli);
                  },
                );
              }).toList(),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  List<Widget> peliculasBuscadas(BuildContext context) {
    final resultado = new List<Widget>();
    for (Pelicula item in buscadasAntes) {
      resultado.add(
        ListTile(
          leading: FadeInImage(
            placeholder: AssetImage('assets/images/no-image.jpg'),
            image: NetworkImage(item.getPosertImg()),
            width: 50.0,
            fit: BoxFit.contain,
          ),
          title: Text(item.title.toString()),
          subtitle: Text(item.releaseDate.toString()),
          onTap: () {
            Navigator.pushNamed(context, '/detalle', arguments: item);
          },
          onLongPress: () {
            buscadasAntes.remove(item);
            print("Elemento eliminado");
          },
        ),
      );
    }
    resultado.add(Center(
      child: Text('👆🏼Búsquedas anteriores👆🏼'),
    ));
    print(resultado);
    return resultado;
  }
}
