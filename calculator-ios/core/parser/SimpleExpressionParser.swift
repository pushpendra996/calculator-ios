import Foundation

class SimpleExpressionParser {
    private let add: IOperation
    private let subtract: IOperation
    private let multiply: IOperation
    private let divide: IOperation
    private let percentage: IOperation
    
    init(add: IOperation, subtract: IOperation, multiply: IOperation, divide: IOperation, percentage: IOperation) {
        self.add = add
        self.subtract = subtract
        self.multiply = multiply
        self.divide = divide
        self.percentage = percentage
    }
    
    /// Evaluates a simple expression string left-to-right (no operator precedence)
    func evaluate(expression: String) -> Double? {
        let tokens = tokenize(expression: expression)
        guard !tokens.isEmpty else { return nil }
        var result: Double? = nil
        var currentOp: String? = nil
        for token in tokens {
            if let value = Double(token) {
                if let op = currentOp, let lhs = result {
                    result = performOperation(op, lhs, value)
                } else {
                    result = value
                }
            } else {
                currentOp = token
            }
        }
        return result
    }
    
    private func tokenize(expression: String) -> [String] {
        var tokens: [String] = []
        var number = ""
        for char in expression {
            if char.isNumber || char == "." {
                number.append(char)
            } else if "+-×÷%".contains(char) {
                if !number.isEmpty {
                    tokens.append(number)
                    number = ""
                }
                tokens.append(String(char))
            }
        }
        if !number.isEmpty {
            tokens.append(number)
        }
        return tokens
    }
    
    private func performOperation(_ op: String, _ a: Double, _ b: Double) -> Double {
        switch op {
        case "+": return add.execute(a, b)
        case "-": return subtract.execute(a, b)
        case "×": return multiply.execute(a, b)
        case "÷": return divide.execute(a, b)
        case "%": return percentage.execute(a, b)
        default: return b
        }
    }
} 
