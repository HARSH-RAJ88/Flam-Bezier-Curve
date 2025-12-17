import SwiftUI

struct FPSDisplayView: View {
    let fps: Int
    
    var body: some View {
        Text("FPS: \(fps)")
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(Color.green)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}
