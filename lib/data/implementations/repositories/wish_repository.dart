import 'dart:math';
import '../../../domain/entities/wish.dart';
import '../../interfaces/repositories/iwish_repository.dart';
import '../api/wish_api.dart';

class WishRepository implements IWishRepository {
  final WishApi _api;
  WishRepository(this._api);

  Wish _toEntity(dto) => Wish(
    id: dto.id, title: dto.title, subtitle: dto.subtitle);

  @override
  Future<List<Wish>> getAll() async {
    final dtos = await _api.getAll();
    return dtos.map(_toEntity).toList();
  }

  @override
  Future<Wish?> getRandom() async {
    final all = await getAll();
    if (all.isEmpty) return null;
    return all[Random().nextInt(all.length)];
  }
}
