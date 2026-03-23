import '../../dtos/transaction/transaction_dto.dart';
import '../../interfaces/mapper/imapper.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/enums/transaction_type_enum.dart';

class TransactionMapper implements IMapper<TransactionDTO, Transaction> {
  @override
  Transaction map(TransactionDTO input) {
    return Transaction(
      id: input.id,
      amount: input.amount,
      type: TransactionType.fromString(input.type),
      relativeId: input.relativeId,
      date: input.date,
      note: input.note,
    );
  }
}
