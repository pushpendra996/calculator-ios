import Foundation

struct DivideUseCase: IOperation {
    func execute(_ a: Double, _ b: Double) -> Double {
        precondition(b != 0, "Cannot divide by zero")
        return a / b
    }
} 