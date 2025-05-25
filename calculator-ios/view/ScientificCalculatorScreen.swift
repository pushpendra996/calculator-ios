import SwiftUI

struct ScientificCalculatorScreen: View {
    @ObservedObject var viewModel: CalculatorViewModel
    let buttonSpacing: CGFloat = 10
    let buttonFontSize: CGFloat = 28
    
    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 8
            let totalSpacing = buttonSpacing * 7
            let buttonCount: CGFloat = 8
            let buttonSize = (geometry.size.width - (horizontalPadding * 2) - totalSpacing) / buttonCount
            ZStack(alignment: .topLeading) {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            if !viewModel.expressionLine.isEmpty {
                                Text(viewModel.expressionLine)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 22, weight: .regular))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .transition(.opacity)
                                    .animation(.easeInOut(duration: 0.25), value: viewModel.expressionLine)
                            }
                            Text(viewModel.displayText)
                                .foregroundColor(.white)
                                .font(.system(size: 48, weight: .light))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .padding(.trailing, horizontalPadding + 8)
                    }
                    .padding(.bottom, 8)
                    VStack(spacing: buttonSpacing) {
                        HStack(spacing: buttonSpacing) {
                            SciButton(title: "sin", action: { viewModel.onScientificFunction("sin") }, size: buttonSize)
                            SciButton(title: "cos", action: { viewModel.onScientificFunction("cos") }, size: buttonSize)
                            SciButton(title: "tan", action: { viewModel.onScientificFunction("tan") }, size: buttonSize)
                            SciButton(title: "ln", action: { viewModel.onScientificFunction("ln") }, size: buttonSize)
                            SciButton(title: "log", action: { viewModel.onScientificFunction("log") }, size: buttonSize)
                            SciButton(title: "π", action: { viewModel.onScientificFunction("pi") }, size: buttonSize)
                            SciButton(title: "e", action: { viewModel.onScientificFunction("e") }, size: buttonSize)
                            SciButton(title: "^", action: { viewModel.onOperatorClick("^") }, size: buttonSize)
                        }
                        HStack(spacing: buttonSpacing) {
                            SciButton(title: "AC", action: { viewModel.onClearClick() }, size: buttonSize)
                            SciButton(title: "(", action: { viewModel.onScientificFunction("(") }, size: buttonSize)
                            SciButton(title: ")", action: { viewModel.onScientificFunction(")") }, size: buttonSize)
                            SciButton(title: "%", action: { viewModel.onOperatorClick("%") }, size: buttonSize)
                            SciButton(title: "÷", action: { viewModel.onOperatorClick("÷") }, size: buttonSize)
                            SciButton(title: "×", action: { viewModel.onOperatorClick("×") }, size: buttonSize)
                            SciButton(title: "-", action: { viewModel.onOperatorClick("-") }, size: buttonSize)
                            SciButton(title: "+", action: { viewModel.onOperatorClick("+") }, size: buttonSize)
                        }
                        HStack(spacing: buttonSpacing) {
                            ForEach(["7","8","9","4","5","6","1","2","3","0",".","=",], id: \ .self) { label in
                                if label == "=" {
                                    SciButton(title: label, action: { viewModel.onEqualsClick() }, size: buttonSize)
                                } else {
                                    SciButton(title: label, action: { viewModel.onDigitClick(label) }, size: buttonSize)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }
} 