part of 'promotions_bloc.dart';

sealed class PromotionsEvent extends Equatable {
  const PromotionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPromotions extends PromotionsEvent {
  const LoadPromotions();
}

// class SetPromotions extends PromotionsEvent {
//   const SetPromotions({
//     required this.promotions,
//     required this.totalPromotionsCount,
//     this.lastDocument,
//   });

//   final List< Promotion> promotions;
//   final int totalPromotionsCount;
//   final DocumentSnapshot? lastDocument;

//   @override
//   List<Object?> get props => [promotions, totalPromotionsCount, lastDocument];
// }

class LoadMorePromotions extends PromotionsEvent {
  const LoadMorePromotions();
}

class SearchPromotions extends PromotionsEvent {
  const SearchPromotions({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class NextPage extends PromotionsEvent {
  const NextPage();
}

class PreviousPage extends PromotionsEvent {
  const PreviousPage();
}

class ClearSearch extends PromotionsEvent {
  const ClearSearch();
}

class DeletePromotion extends PromotionsEvent {
  const DeletePromotion({required this.promotion});

  final Promotion promotion;

  @override
  List<Object?> get props => [promotion];
}

class UpdatePromotion extends PromotionsEvent {
  const UpdatePromotion({
    required this.id,
    required this.code,
    required this.content,
    required this.type,
    required this.imageBytes,
    required this.currentImgUrl,
    required this.startTime,
    required this.endTime,
    required this.minimumOrderValue,
    required this.maximumDiscountValue,
    required this.discountAmount,
    required this.quantity,
  });

  final String id;
  final String code;
  final String content;
  final PromotionType type;
  final Uint8List? imageBytes;
  final String currentImgUrl;
  final DateTime startTime;
  final DateTime endTime;
  final double? minimumOrderValue;
  final double? maximumDiscountValue;
  final double discountAmount;
  final int? quantity;

  @override
  List<Object?> get props => [
        id,
        code,
        content,
        type,
        imageBytes,
        startTime,
        endTime,
        minimumOrderValue,
        maximumDiscountValue,
        discountAmount,
        quantity,
      ];
}

class AddPromotion extends PromotionsEvent {
  const AddPromotion({
    required this.code,
    required this.content,
    required this.type,
    required this.imageBytes,
    required this.startTime,
    required this.endTime,
    required this.minimumOrderValue,
    required this.maximumDiscountValue,
    required this.discountAmount,
    required this.quantity,
  });

  final String code;
  final String content;
  final PromotionType type;
  final Uint8List imageBytes;
  final DateTime startTime;
  final DateTime endTime;
  final double? minimumOrderValue;
  final double? maximumDiscountValue;
  final double discountAmount;
  final int? quantity;

  @override
  List<Object?> get props => [
        code,
        content,
        type,
        imageBytes,
        startTime,
        endTime,
        minimumOrderValue,
        maximumDiscountValue,
        discountAmount,
        quantity,
      ];
}
