import Foundation

struct MultiplyUseCase: IOperation {
    func execute(_ a: Double, _ b: Double) -> Double {
        return a * b
    }
} 