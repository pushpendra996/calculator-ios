import Foundation

struct PercentageUseCase: IOperation {
    func execute(_ a: Double, _ b: Double) -> Double {
        return (a * b) / 100
    }
} 
