import SwiftUI

struct CalcButton: View {
    let title: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    let fontSize: CGFloat
    let size: CGFloat
    var height: CGFloat? = nil
    var cornerRadius: CGFloat? = nil
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .regular))
                .frame(width: size, height: height ?? size)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? size / 2, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

struct CalcButton_Previews: PreviewProvider {
    static var previews: some View {
        CalcButton(title: "5", backgroundColor: .gray, foregroundColor: .white, action: {}, fontSize: 32, size: 80)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)
    }
}
