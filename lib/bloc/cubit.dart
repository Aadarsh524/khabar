import 'package:bloc/bloc.dart';
import 'package:khabar/bloc/state.dart';
import 'package:khabar/model/news_model.dart';
import 'package:khabar/repository/new_repository.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository repository;

  NewsCubit({required this.repository}) : super(NewsInitial());

  void fetchNews() async {
    try {
      emit(NewsLoading());
      final NewsModel news = await repository.fetchNews();
      emit(NewsLoaded(newsModel: news));
    } catch (_) {
      emit(const NewsError(message: 'Failed to Load News'));
    }
  }
}
