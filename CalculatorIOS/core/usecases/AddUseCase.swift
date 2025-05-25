import Foundation

struct AddUseCase: IOperation {
    func execute(_ a: Double, _ b: Double) -> Double {
        return a + b
    }
} 