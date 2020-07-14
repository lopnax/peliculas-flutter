import 'dart:async';
import 'package:peliculas/src/class/actores_class.dart';
import 'package:peliculas/src/class/pelicula_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PeliculasProvider {
  String _apiKey = '6754e97d56d51649ba02f9548f08b906';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;
  List<Pelicula> _populares = new List();
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void cerrarStreamController() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesar(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJSONlist(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(
      _url,
      '3/movie/now_playing',
      {
        'api_key': _apiKey,
        'language': _language,
      },
    );
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJSONlist(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getTopRated() async {
    final url = Uri.https(
      _url,
      '3/movie/top_rated',
      {
        'api_key': _apiKey,
        'language': 'en-US',
      },
    );
    return await _procesar(url);
  }

  Future<List<Pelicula>> getPopular() async {
    if (_cargando) {
      return [];
    }
    _cargando = true;
    _popularesPage++;
    final url = Uri.https(
      _url,
      '3/movie/popular',
      {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': _popularesPage.toString()
      },
    );

    final resp = await _procesar(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliID) async {
    final url = Uri.https(_url, '3/movie/$peliID/credits', {
      'api_key': _apiKey,
      'language': 'en-US',
    });
    final respuesta = await http.get(url);
    final decodeData = json.decode(respuesta.body);
    final cast = new Cast.fromJSONlist(decodeData['cast']);
    return cast.actores;
  }

 Future<List<Pelicula>> searchPelicula(String query) async {
    final url = Uri.https(
      _url,
      '3/search/movie',
      {
        'api_key': _apiKey,
        'language': _language,
        'query': query,
      },
    );
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJSONlist(decodedData['results']);
    return peliculas.items;
  }

}
