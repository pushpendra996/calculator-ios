import SwiftUI

struct HistoryDialog: View {
    var body: some View {
        Text("History will appear here.")
            .foregroundColor(.white)
            .padding()
            .background(Color.gray.opacity(0.9))
            .cornerRadius(16)
    }
}

struct HistoryDialog_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDialog()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}
