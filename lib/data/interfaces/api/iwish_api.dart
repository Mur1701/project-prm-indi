import '../../dtos/wish/wish_dto.dart';

abstract class IWishApi {
  Future<List<WishDTO>> getAll();
  Future<WishDTO?> getById(int id);
}
