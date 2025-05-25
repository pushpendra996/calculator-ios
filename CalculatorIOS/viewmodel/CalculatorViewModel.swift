import Foundation
import Combine

class CalculatorViewModel: ObservableObject {
    // Published properties for UI binding
    @Published var displayText: String = "0"
    @Published var historyList: [HistoryItemModel] = []
    @Published var expressionLine: String = ""
    @Published var scientificSuperscript: String = ""
    
    // Dependencies (injected)
    private let addUseCase: IOperation
    private let subtractUseCase: IOperation
    private let multiplyUseCase: IOperation
    private let divideUseCase: IOperation
    private let percentageUseCase: IOperation
    private let historyRepository: IHistoryRepository
    
    // Internal state
    private var inputModel = CalculatorInputModel()
    private var lastEvaluatedExpression: String = ""
    private var cancellables = Set<AnyCancellable>()
    private var pendingScientific: (base: String, op: String, exp: String)? = nil
    
    init(
        addUseCase: IOperation,
        subtractUseCase: IOperation,
        multiplyUseCase: IOperation,
        divideUseCase: IOperation,
        percentageUseCase: IOperation,
        historyRepository: IHistoryRepository
    ) {
        self.addUseCase = addUseCase
        self.subtractUseCase = subtractUseCase
        self.multiplyUseCase = multiplyUseCase
        self.divideUseCase = divideUseCase
        self.percentageUseCase = percentageUseCase
        self.historyRepository = historyRepository
        
        // Observe history
        historyRepository.getHistory()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.historyList = items
            }
            .store(in: &cancellables)
    }
    
    func onDigitClick(_ digit: String) {
        if let pending = pendingScientific, pending.op == "ʸ" && pending.exp.isEmpty {
            // Start entering exponent for xʸ
            pendingScientific = (pending.base, pending.op, digit)
            inputModel.expression = "\(formatNumber(pending.base))ʸ\(digit)"
            scientificSuperscript = "ʸ\(digit)"
            inputModel.isResult = false
            updateDisplay()
            return
        } else if let pending = pendingScientific, pending.op == "ʸ" {
            // Continue entering exponent for xʸ
            let newExp = pending.exp + digit
            pendingScientific = (pending.base, pending.op, newExp)
            inputModel.expression = "\(formatNumber(pending.base))ʸ\(newExp)"
            scientificSuperscript = "ʸ\(newExp)"
            inputModel.isResult = false
            updateDisplay()
            return
        }
        if inputModel.isResult {
            inputModel.currentInput = digit
            inputModel.isResult = false
            inputModel.expression = digit
            lastEvaluatedExpression = ""
            scientificSuperscript = ""
            pendingScientific = nil
        } else if inputModel.currentInput == "0" {
            inputModel.currentInput = digit
            if inputModel.expression.isEmpty {
                inputModel.expression = digit
            } else {
                inputModel.expression += digit
            }
            scientificSuperscript = ""
            pendingScientific = nil
        } else {
            inputModel.currentInput += digit
            inputModel.expression += digit
            scientificSuperscript = ""
            pendingScientific = nil
        }
        updateDisplay()
    }
    
    func onOperatorClick(_ op: String) {
        if let prev = inputModel.previousInput, let oper = inputModel.operation, let prevVal = Double(prev), let currVal = Double(inputModel.currentInput) {
            let result = performOperation(oper, prevVal, currVal)
            inputModel.previousInput = String(result)
            inputModel.expression = "\(result)\(op)"
        } else {
            inputModel.previousInput = inputModel.currentInput
            if inputModel.expression.isEmpty {
                inputModel.expression = inputModel.currentInput + op
            } else if inputModel.isResult {
                inputModel.expression = inputModel.currentInput + op
            } else {
                inputModel.expression += op
            }
        }
        inputModel.currentInput = "0"
        inputModel.operation = op
        inputModel.isResult = false
        lastEvaluatedExpression = ""
        updateDisplay()
    }
    
    func onEqualsClick() {
        // Handle scientific calculation if pending
        if let pending = pendingScientific {
            let base = Double(pending.base) ?? 0
            var result: Double = 0
            var expr: String = ""
            
            switch pending.op {
            case "²":
                result = pow(base, 2)
                expr = "\(formatNumber(pending.base))²"
            case "³":
                result = pow(base, 3)
                 expr = "\(formatNumber(pending.base))³"
            case "ʸ":
                 let exp = Double(pending.exp.isEmpty ? "0" : pending.exp) ?? 0
                 result = pow(base, exp)
                 expr = "\(formatNumber(pending.base))ʸ\(pending.exp)"
            case "sin":
                // Assuming radians for now
                 result = sin(base)
                 expr = "sin(\(formatNumber(pending.base)))"
            case "cos":
                // Assuming radians for now
                 result = cos(base)
                 expr = "cos(\(formatNumber(pending.base)))"
            case "tan":
                // Assuming radians for now
                result = tan(base)
                expr = "tan(\(formatNumber(pending.base)))"
            case "√":
                result = sqrt(base)
                expr = "√(\(formatNumber(pending.base)))"
            // Add other scientific calculations here...
            default:
                 // Should not happen with current functions
                result = base // Or handle error
                expr = inputModel.expression // Keep current expression
            }
            
            inputModel.expression = expr
            inputModel.currentInput = String(result)
            inputModel.isResult = true
            scientificSuperscript = ""
            pendingScientific = nil
            
            // Save to history for scientific calculations
            historyRepository.saveHistory(expression: inputModel.expression, result: inputModel.currentInput)
            
            updateDisplay()
            return
        }
        
        guard let oper = inputModel.operation, let prev = inputModel.previousInput, let prevVal = Double(prev), let currVal = Double(inputModel.currentInput) else { return }
        let result = performOperation(oper, prevVal, currVal)
        // Save to history for standard operations
        let expr = "\(prev) \(oper) \(inputModel.currentInput)"
        historyRepository.saveHistory(expression: expr, result: String(result))
        // Update expression line
        inputModel.expression = expr
        inputModel.currentInput = String(result)
        inputModel.previousInput = nil
        inputModel.operation = nil
        inputModel.isResult = true
        lastEvaluatedExpression = expr
        updateDisplay()
    }
    
    func onClearClick() {
        inputModel = CalculatorInputModel()
        lastEvaluatedExpression = ""
        scientificSuperscript = ""
        pendingScientific = nil
        updateDisplay()
    }
    
    func onScientificFunction(_ function: String) {
        switch function {
        case "x²":
            pendingScientific = (inputModel.currentInput, "²", "2")
            inputModel.expression = "\(formatNumber(inputModel.currentInput))²"
            scientificSuperscript = "²"
            inputModel.isResult = false
            updateDisplay()
        case "x³":
            pendingScientific = (inputModel.currentInput, "³", "3")
            inputModel.expression = "\(formatNumber(inputModel.currentInput))³"
            scientificSuperscript = "³"
            inputModel.isResult = false
            updateDisplay()
        case "xʸ":
            // Wait for exponent input
            pendingScientific = (inputModel.currentInput, "ʸ", "")
            inputModel.expression = "\(formatNumber(inputModel.currentInput))ʸ"
            scientificSuperscript = "ʸ"
            inputModel.isResult = false
            updateDisplay()
        case "sin":
            pendingScientific = (inputModel.currentInput, "sin", "")
            inputModel.expression = "sin(\(formatNumber(inputModel.currentInput)))"
            scientificSuperscript = ""
            inputModel.isResult = false
            updateDisplay()
        case "cos":
            pendingScientific = (inputModel.currentInput, "cos", "")
            inputModel.expression = "cos(\(formatNumber(inputModel.currentInput)))"
            scientificSuperscript = ""
            inputModel.isResult = false
            updateDisplay()
        case "tan":
             pendingScientific = (inputModel.currentInput, "tan", "")
            inputModel.expression = "tan(\(formatNumber(inputModel.currentInput)))"
            scientificSuperscript = ""
            inputModel.isResult = false
            updateDisplay()
        case "√x":
            pendingScientific = (inputModel.currentInput, "√", "")
            inputModel.expression = "√(\(formatNumber(inputModel.currentInput)))"
            scientificSuperscript = ""
            inputModel.isResult = false
            updateDisplay()
        case "π":
            inputModel.currentInput = String(Double.pi)
            inputModel.expression = "π"
            scientificSuperscript = ""
            inputModel.isResult = false
            updateDisplay()
        case "e":
            inputModel.currentInput = String(M_E)
            inputModel.expression = "e"
            scientificSuperscript = ""
            inputModel.isResult = false
            updateDisplay()
        // Add other scientific functions here...
        default:
            // Handle other scientific functions or append to expression
             inputModel.expression += function // Append for now
             updateDisplay()
            break
        }
    }
    
    private func performOperation(_ op: String, _ a: Double, _ b: Double) -> Double {
        switch op {
        case "+": return addUseCase.execute(a, b)
        case "-": return subtractUseCase.execute(a, b)
        case "×": return multiplyUseCase.execute(a, b)
        case "÷": return divideUseCase.execute(a, b)
        case "%": return percentageUseCase.execute(a, b)
        default: return b
        }
    }

    private func updateDisplay() {
        // Only show the expression line after equals
        expressionLine = inputModel.isResult ? (inputModel.expression.isEmpty ? lastEvaluatedExpression : inputModel.expression) : ""
        if inputModel.isResult {
            displayText = formatNumber(inputModel.currentInput)
        } else {
            displayText = inputModel.expression.isEmpty ? formatNumber(inputModel.currentInput) : inputModel.expression
        }
    }

    private func formatNumber(_ value: String) -> String {
        if let doubleValue = Double(value) {
            if doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                return String(Int(doubleValue))
            } else {
                return String(doubleValue)
            }
        }
        return value
    }
} 
