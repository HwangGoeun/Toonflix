import 'dart:convert';

// http 패키지 다운로드.
import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/models/webtton_episode_model.dart';

class ApiService {
  // 데이터가 저장되어 있는 url
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  // Future = http.get이 반환하는 데이터 타입. 당장 완료될 수 있는 작업이 아니라는 것을 뜻함.
  // async await = 비동기. 데이터 값이 들어올 때까지 기다린다는 뜻.
  static Future<List<WebtoonModel>> getTodaysToons() async {
    // 웹툰 정보를 저장 할 리스트 생성
    List<WebtoonModel> webtoonsInstances = [];

    // http 요청
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url); // http.get은 Future라는 타입 반환.

    // 데이터가 성공적으로 들어오면 (successful responses는 200 ~ 299)
    if (response.statusCode == 200) {
      // string으로 들어온 response를 json 형식으로 변환
      final List<dynamic> webtoons = jsonDecode(response.body);

      // 리스트에 값 추가
      for (var webtoon in webtoons) {
        webtoonsInstances.add(WebtoonModel.fromJson(webtoon));
      }

      return webtoonsInstances;
    }

    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);

      return WebtoonDetailModel.fromJson(webtoon);
    }

    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }

    throw Error();
  }
}
