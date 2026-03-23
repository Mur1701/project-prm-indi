import '../../../domain/entities/wish.dart';

abstract class IWishRepository {
  Future<List<Wish>> getAll();
  Future<Wish?> getRandom();
}
