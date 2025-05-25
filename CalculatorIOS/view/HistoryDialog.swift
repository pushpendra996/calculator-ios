import SwiftUI

struct HistoryDialog: View {
    let historyList: [HistoryItemModel]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("History")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button("Close") { dismiss() }
                    .foregroundColor(.orange)
            }
            .padding()
            Divider().background(Color.white.opacity(0.2))
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(historyList) { item in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.expression)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(item.result)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 4)
                        Divider().background(Color.white.opacity(0.1))
                    }
                }
                .padding()
            }
        }
        .background(Color.black)
        .cornerRadius(20)
    }
}

struct HistoryDialog_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDialog(historyList: [])
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}
