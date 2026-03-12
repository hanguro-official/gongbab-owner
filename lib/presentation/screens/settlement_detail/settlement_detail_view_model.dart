import 'package:flutter/foundation.dart';
import 'package:gongbab_owner/domain/usecases/confirm_settlement_usecase.dart';
import 'package:gongbab_owner/domain/usecases/get_settlement_detail_usecase.dart';
import 'package:gongbab_owner/presentation/screens/settlement_detail/settlement_detail_event.dart';
import 'package:gongbab_owner/presentation/screens/settlement_detail/settlement_detail_ui_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettlementDetailViewModel extends ChangeNotifier {
  final GetSettlementDetailUseCase _getSettlementDetailUseCase;
  final ConfirmSettlementUseCase _confirmSettlementUseCase;

  SettlementDetailViewModel(
    this._getSettlementDetailUseCase,
    this._confirmSettlementUseCase,
  );

  SettlementDetailUiState _uiState = const SettlementDetailInitial();
  SettlementDetailUiState get uiState => _uiState;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void onEvent(SettlementDetailEvent event) {
    if (event is LoadSettlementDetail) {
      _loadSettlementDetail(event.year, event.month);
    } else if (event is ConfirmSettlement) {
      _confirmSettlement(event.id);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _loadSettlementDetail(int year, int month) async {
    _uiState = const SettlementDetailLoading();
    notifyListeners();

    final result = await _getSettlementDetailUseCase.execute(year: year, month: month);

    result.when(
      success: (settlement) {
        _uiState = SettlementDetailSuccess(settlement);
      },
      failure: (success, error) {
        _uiState = SettlementDetailError(error?['message'] ?? '정산 정보를 불러오지 못했습니다.');
      },
      error: (error) {
        _uiState = SettlementDetailError(error);
      },
    );
    notifyListeners();
  }

  Future<void> _confirmSettlement(int id) async {
    final result = await _confirmSettlementUseCase.execute(id: id);

    result.when(
      success: (settlement) {
        _uiState = SettlementDetailSuccess(settlement);
        notifyListeners();
      },
      failure: (success, error) {
        final errorCode = error?['code'] as String?;
        if (errorCode == 'SETTLEMENT_NOT_FOUND') {
          _errorMessage = '정산을 찾을 수 없습니다.';
        } else if (errorCode == 'SETTLEMENT_ALREADY_CONFIRMED') {
          _errorMessage = '이미 확정된 정산입니다.';
        } else {
          _errorMessage = error?['message'] ?? '정산 확정에 실패했습니다.';
        }
        notifyListeners();
      },
      error: (error) {
        _errorMessage = error;
        notifyListeners();
      },
    );
  }
}
