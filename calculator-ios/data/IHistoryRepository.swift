import Foundation
import Combine

protocol IHistoryRepository {
    func saveHistory(expression: String, result: String)
    func getHistory() -> AnyPublisher<[HistoryItemModel], Never>
} 