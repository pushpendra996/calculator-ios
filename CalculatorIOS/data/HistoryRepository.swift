import Foundation
import Combine

class HistoryRepository: IHistoryRepository {
    private var history: [HistoryItemModel] = []
    private let historySubject = CurrentValueSubject<[HistoryItemModel], Never>([])
    
    func saveHistory(expression: String, result: String) {
        let item = HistoryItemModel(expression: expression, result: result)
        history.insert(item, at: 0)
        historySubject.send(history)
    }
    
    func getHistory() -> AnyPublisher<[HistoryItemModel], Never> {
        return historySubject.eraseToAnyPublisher()
    }
} 