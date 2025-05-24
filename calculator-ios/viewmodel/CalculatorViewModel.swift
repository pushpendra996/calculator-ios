import Foundation
import Combine

class CalculatorViewModel: ObservableObject {
    // Published properties for UI binding
    @Published var displayText: String = "0"
    @Published var historyList: [HistoryItemModel] = []
    
    // Dependencies (injected)
    private let addUseCase: IOperation
    private let subtractUseCase: IOperation
    private let multiplyUseCase: IOperation
    private let divideUseCase: IOperation
    private let percentageUseCase: IOperation
    private let historyRepository: IHistoryRepository
    
    // Internal state
    private var inputModel = CalculatorInputModel()
    private var cancellables = Set<AnyCancellable>()
    
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
        if inputModel.isResult {
            inputModel.currentInput = digit
            inputModel.isResult = false
        } else if inputModel.currentInput == "0" {
            inputModel.currentInput = digit
        } else {
            inputModel.currentInput += digit
        }
        displayText = inputModel.currentInput
    }
    
    func onOperatorClick(_ op: String) {
        if let prev = inputModel.previousInput, let oper = inputModel.operation, let prevVal = Double(prev), let currVal = Double(inputModel.currentInput) {
            let result = performOperation(oper, prevVal, currVal)
            inputModel.previousInput = String(result)
            displayText = String(result)
        } else {
            inputModel.previousInput = inputModel.currentInput
        }
        inputModel.currentInput = "0"
        inputModel.operation = op
        inputModel.isResult = false
    }
    
    func onEqualsClick() {
        guard let oper = inputModel.operation, let prev = inputModel.previousInput, let prevVal = Double(prev), let currVal = Double(inputModel.currentInput) else { return }
        let result = performOperation(oper, prevVal, currVal)
        displayText = String(result)
        // Save to history
        let expr = "\(prev) \(oper) \(inputModel.currentInput)"
        historyRepository.saveHistory(expression: expr, result: String(result))
        // Reset state
        inputModel.currentInput = String(result)
        inputModel.previousInput = nil
        inputModel.operation = nil
        inputModel.isResult = true
    }
    
    func onClearClick() {
        inputModel = CalculatorInputModel()
        displayText = "0"
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
} 
