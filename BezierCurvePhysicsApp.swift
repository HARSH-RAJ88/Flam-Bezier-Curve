import SwiftUI

@main
struct BezierCurvePhysicsApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    @StateObject private var viewModel = BezierSimulationViewModel(screenSize: CGSize(width: 900, height: 650))
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                BezierCanvasView(viewModel: viewModel)
                    .onAppear {
                        viewModel.updateScreenSize(geometry.size)
                        viewModel.setUpdateCallback {
                            // Force view update
                            viewModel.objectWillChange.send()
                        }
                    }
                    .onChange(of: geometry.size) { newSize in
                        viewModel.updateScreenSize(newSize)
                    }
                
                VStack {
                    FPSDisplayView(fps: viewModel.fps)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    
                    Spacer()
                    
                    ControlButtonsView(viewModel: viewModel)
                        .padding(.bottom, 20)
                }
            }
        }
        .ignoresSafeArea()
    }
}
