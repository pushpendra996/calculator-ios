import SwiftUI

struct CalculatorScreen: View {
    @StateObject private var viewModel: CalculatorViewModel
    @State private var showHistory = false
    
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
    
    let buttonSpacing: CGFloat = 12
    let buttonFontSize: CGFloat = 32
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("6:57")
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .regular))
                            .padding(.top, 16)
                        Button(action: { showHistory = true }) {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 8)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    Text(viewModel.displayText)
                        .foregroundColor(.white)
                        .font(.system(size: 80, weight: .light))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.trailing, 32)
                }
                .padding(.bottom, 8)
                VStack(spacing: buttonSpacing) {
                    HStack(spacing: buttonSpacing) {
                        CalcButton(title: "AC", backgroundColor: .gray, foregroundColor: .white, action: { viewModel.onClearClick() }, fontSize: buttonFontSize)
                        CalcButton(title: "+/-", backgroundColor: .gray, foregroundColor: .white, action: {}, fontSize: buttonFontSize)
                        CalcButton(title: "%", backgroundColor: .gray, foregroundColor: .white, action: { viewModel.onOperatorClick("%") }, fontSize: buttonFontSize)
                        CalcButton(title: "÷", backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("÷") }, fontSize: buttonFontSize)
                    }
                    HStack(spacing: buttonSpacing) {
                        CalcButton(title: "7", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("7") }, fontSize: buttonFontSize)
                        CalcButton(title: "8", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("8") }, fontSize: buttonFontSize)
                        CalcButton(title: "9", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("9") }, fontSize: buttonFontSize)
                        CalcButton(title: "×", backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("×") }, fontSize: buttonFontSize)
                    }
                    HStack(spacing: buttonSpacing) {
                        CalcButton(title: "4", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("4") }, fontSize: buttonFontSize)
                        CalcButton(title: "5", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("5") }, fontSize: buttonFontSize)
                        CalcButton(title: "6", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("6") }, fontSize: buttonFontSize)
                        CalcButton(title: "-", backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("-") }, fontSize: buttonFontSize)
                    }
                    HStack(spacing: buttonSpacing) {
                        CalcButton(title: "1", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("1") }, fontSize: buttonFontSize)
                        CalcButton(title: "2", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("2") }, fontSize: buttonFontSize)
                        CalcButton(title: "3", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("3") }, fontSize: buttonFontSize)
                        CalcButton(title: "+", backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onOperatorClick("+") }, fontSize: buttonFontSize)
                    }
                    HStack(spacing: buttonSpacing) {
                        CalcButton(title: "", backgroundColor: .gray, foregroundColor: .white, action: {}, fontSize: buttonFontSize)
                        CalcButton(title: "0", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick("0") }, fontSize: buttonFontSize)
                        CalcButton(title: ".", backgroundColor: .secondary, foregroundColor: .white, action: { viewModel.onDigitClick(".") }, fontSize: buttonFontSize)
                        CalcButton(title: "=", backgroundColor: .orange, foregroundColor: .white, action: { viewModel.onEqualsClick() }, fontSize: buttonFontSize)
                    }
                }
                .padding(.bottom, 24)
            }
            .sheet(isPresented: $showHistory) {
                HistoryDialog(historyList: viewModel.historyList)
            }
        }
    }
}

struct CalculatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorScreen()
            .previewDevice("iPhone 14 Pro")
    }
}
