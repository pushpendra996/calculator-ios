import Foundation

struct SubtractUseCase: IOperation {
    func execute(_ a: Double, _ b: Double) -> Double {
        return a - b
    }
} 