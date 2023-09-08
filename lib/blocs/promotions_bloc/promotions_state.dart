part of 'promotions_bloc.dart';

sealed class PromotionsState extends Equatable {
  const PromotionsState({
    required this.promotions,
    required this.displayPromotions,
    this.searchPromotions,
    required this.totalPromotionsCount,
    required this.currentPageIndex,
    required this.lastDocument,
  });

  final List<Promotion> promotions;
  final List<Promotion> displayPromotions;
  final List<Promotion>? searchPromotions;
  final int totalPromotionsCount;
  final DocumentSnapshot? lastDocument;
  final int currentPageIndex;

  int get totalPagesCount =>
      (totalPromotionsCount / AppConstants.numberItemsPerPage).ceil();

  @override
  List<Object?> get props => [
        promotions,
        displayPromotions,
        searchPromotions,
        totalPromotionsCount,
        lastDocument,
        currentPageIndex,
      ];
}

final class PromotionsInitial extends PromotionsState {
  const PromotionsInitial()
      : super(
            promotions: const [],
            displayPromotions: const [],
            searchPromotions: null,
            totalPromotionsCount: 0,
            currentPageIndex: 0,
            lastDocument: null);
}

final class PromotionsLoading extends PromotionsState {
  const PromotionsLoading({
    required super.promotions,
    required super.displayPromotions,
    required super.searchPromotions,
    required super.totalPromotionsCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}

final class PromotionsLoaded extends PromotionsState {
  const PromotionsLoaded({
    required super.promotions,
    required super.displayPromotions,
    required super.searchPromotions,
    required super.totalPromotionsCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}

final class PromotionsError extends PromotionsState {
  const PromotionsError({
    required this.message,
    required super.promotions,
    required super.displayPromotions,
    required super.searchPromotions,
    required super.totalPromotionsCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });

  final String message;

  @override
  List<Object?> get props => [
        message,
        promotions,
        displayPromotions,
        searchPromotions,
        totalPromotionsCount,
        lastDocument,
        currentPageIndex,
      ];
}

final class LoadingMorePromotions extends PromotionsState {
  const LoadingMorePromotions({
    required super.promotions,
    required super.displayPromotions,
    required super.searchPromotions,
    required super.totalPromotionsCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}

final class SearchingPromotions extends PromotionsState {
  const SearchingPromotions({
    required super.promotions,
    required super.displayPromotions,
    required super.searchPromotions,
    required super.totalPromotionsCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}

final class UpdatingPromotion extends PromotionsState {
  const UpdatingPromotion({
    required super.promotions,
    required super.displayPromotions,
    required super.searchPromotions,
    required super.totalPromotionsCount,
    required super.lastDocument,
    required super.currentPageIndex,
  });
}
