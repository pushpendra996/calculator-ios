import SwiftUI

struct CalculatorScreen: View {
    @StateObject private var viewModel: CalculatorViewModel
    @State private var showHistory = false
    @State private var showScientific = false
    
    init() {
        // Manual DI for ViewModel and UseCases
        let add = AddUseCase()
        let sub = SubtractUseCase()
        let mul = MultiplyUseCase()
        let div = DivideUseCase()
        let perc = PercentageUseCase()
        let repo = HistoryRepository()
        _viewModel = StateObject(wrappedValue: CalculatorViewModel(
            addUseCase: add,
            subtractUseCase: sub,
            multiplyUseCase: mul,
            divideUseCase: div,
            percentageUseCase: perc,
            historyRepository: repo
        ))
    }
    
    let buttonSpacing: CGFloat = 10
    let buttonFontSize: CGFloat = 25
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                let horizontalPadding: CGFloat = 8
                let verticalPadding: CGFloat = 8
                let buttonCount: CGFloat = 4
                let totalSpacing = buttonSpacing * (buttonCount - 1)
                let availableWidth = geometry.size.width - (horizontalPadding * 2) - totalSpacing
                let standardButtonSize = availableWidth / buttonCount
                let sciButtonCount = CGFloat(ScientificPanelFullWidth.maxButtonsPerRow)
                let sciButtonSize = (availableWidth / sciButtonCount)
                let sciPanelHeight = showScientific ? (sciButtonSize * 4 + buttonSpacing * 3 + 8) : 0
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Button(action: { showHistory = true }) {
                                Image(systemName: "list.bullet")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.orange)
                            }
                            .padding(.top, 16)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, horizontalPadding)
                    Spacer(minLength: 0)
                    VStack(spacing: 0) {
                        Spacer(minLength: showScientific ? 12 : 32)
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                if !viewModel.expressionLine.isEmpty {
                                    Text(viewModel.expressionLine)
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 28, weight: .regular))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .transition(.opacity)
                                        .animation(.easeInOut(duration: 0.25), value: viewModel.expressionLine)
                                }
                                ZStack(alignment: .topTrailing) {
                                    Text(viewModel.displayText)
                                        .foregroundColor(Color(.label))
                                        .font(.system(size: 80, weight: .light))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                            }
                            .padding(.trailing, horizontalPadding + 8)
                        }
                        .padding(.bottom, 8)
                        Spacer(minLength: showScientific ? 8 : 24)
                    }
                    if showScientific {
                        ScientificPanelFullWidth(viewModel: viewModel, buttonSize: sciButtonSize)
                            .frame(height: sciPanelHeight)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: showScientific)
                    }
                    VStack(spacing: buttonSpacing) {
                        ForEach(standardRows, id: \ .self) { row in
                            HStack(spacing: buttonSpacing) {
                                ForEach(row, id: \ .self) { label in
                                    if label == "f(x)" {
                                        Button(action: { withAnimation { showScientific.toggle() } }) {
                                            Image(systemName: "function")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: standardButtonSize/2, height: standardButtonSize/2)
                                        }
                                        
                                        .foregroundColor(.white.opacity(0.7))
                                        .frame(width: standardButtonSize, height: showScientific ? standardButtonSize * 0.6 : standardButtonSize)
                                        .background(Color.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: showScientific ? standardButtonSize / 2 : standardButtonSize / 2, style: .continuous))
                                    } else {
                                        calcButtonForLabel(label: label, size: standardButtonSize)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, verticalPadding)
                    Spacer(minLength: showScientific ? 12 : 0)
                }
                .sheet(isPresented: $showHistory) {
                    HistoryDialog(historyList: viewModel.historyList)
                }
            }
        }
        .preferredColorScheme(nil) // Support both light and dark mode
    }
    
    private var standardRows: [[String]] {
        [
            ["AC", "+/-", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["f(x)", "0", ".", "="]
        ]
    }
    
    @ViewBuilder
    private func calcButtonForLabel(label: String, size: CGFloat) -> some View {
        let buttonWidth = size // Always use the original width
        let buttonHeight = showScientific ? size * 0.6 : size
        let cornerRadius = showScientific ? buttonHeight / 2 : size / 2
        switch label {
        case "AC":
            CalcButton(title: label, backgroundColor: .gray, foregroundColor: .white, action: { viewModel.onClearClick() }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        case "+/-":
            CalcButton(title: label, backgroundColor: .gray, foregroundColor: .white, action: {}, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        case "%":
            CalcButton(title: label, backgroundColor: .gray, foregroundColor: .white, action: { viewModel.onOperatorClick("%") }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        case "÷":
            CalcButton(title: label, backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("÷") }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        case "×":
            CalcButton(title: label, backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("×") }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        case "-":
            CalcButton(title: label, backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("-") }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        case "+":
            CalcButton(title: label, backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("+") }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        case "=":
            CalcButton(title: label, backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onEqualsClick() }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        default:
            CalcButton(title: label, backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick(label) }, fontSize: buttonFontSize, size: buttonWidth, height: buttonHeight, cornerRadius: cornerRadius)
        }
    }
}

struct ScientificPanelFullWidth: View {
    let viewModel: CalculatorViewModel
    let buttonSize: CGFloat
    let buttonSpacing: CGFloat = 5
    static let scientificRows: [[String]] = [
        ["Rad", "(", ")", "mc", "m+", "m-", "mr"],
        ["2nd", "x²", "x³", "xʸ", "eˣ", "10ˣ", "1/x"],
        ["x!", "sin", "cos", "tan", "e", "EE", "π"],
        ["Rand", "sinh", "cosh", "tanh", "ln", "log₁₀", "Deg"]
    ]
    static var maxButtonsPerRow: Int { scientificRows.map { $0.count }.max() ?? 7 }
    var body: some View {
        VStack(spacing: buttonSpacing) {
            ForEach(Self.scientificRows, id: \ .self) { row in
                HStack(spacing: buttonSpacing) {
                    ForEach(row, id: \ .self) { label in
                        SciButton(title: label, action: { viewModel.onScientificFunction(label) }, size: buttonSize)
                    }
                }
            }
        }
        .padding(.bottom, 8)
        .padding(.horizontal, 4)
    }
}

struct SciButton: View {
    let title: String
    let action: () -> Void
    let size: CGFloat
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .frame(width: size, height: size)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.orange)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalculatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorScreen()
    }
}
