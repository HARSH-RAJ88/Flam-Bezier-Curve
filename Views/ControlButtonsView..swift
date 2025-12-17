import SwiftUI

struct ControlButtonsView: View {
    @ObservedObject var viewModel: BezierSimulationViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            ControlButton(
                title: "Control P₁",
                isActive: viewModel.controlMode == .p1
            ) {
                viewModel.setControlMode(.p1)
            }
            
            ControlButton(
                title: "Control P₂",
                isActive: viewModel.controlMode == .p2
            ) {
                viewModel.setControlMode(.p2)
            }
            
            ControlButton(
                title: "Control Both",
                isActive: viewModel.controlMode == .both
            ) {
                viewModel.setControlMode(.both)
            }
        }
        .padding()
    }
}

struct ControlButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isActive ?
                            Color.blue.opacity(0.7) :
                            Color.blue.opacity(0.6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue.opacity(isActive ? 1 : 0.8), lineWidth: 2)
                        )
                        .shadow(color: isActive ?
                            Color.blue.opacity(0.6) :
                            Color.clear,
                        radius: 5)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isActive ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isActive)
    }
}
