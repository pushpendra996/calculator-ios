import Foundation

struct HistoryItemModel: Identifiable, Codable {
    let id = UUID()
    let expression: String
    let result: String
} 