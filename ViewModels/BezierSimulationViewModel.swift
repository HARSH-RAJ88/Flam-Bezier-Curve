import Foundation
import SwiftUI
import Combine
import CoreMotion

class BezierSimulationViewModel: ObservableObject {
    @Published var controlMode: ControlMode = .p1
    @Published var fps: Int = 60
    @Published var screenSize: CGSize
    
    // Properties with initial values
    var p0: Vector2
    var p3: Vector2
    var p1: SpringPoint
    var p2: SpringPoint
    var p1Fixed: Vector2
    var p2Fixed: Vector2
    
    var tangentPoints: [CGFloat] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
    let tangentLength: CGFloat = 35
    let tStep: CGFloat = 0.008
    
    private var motionManager = MotionManager()
    private var frameCount = 0
    private var lastFpsUpdate = Date()
    private var displayLink: CADisplayLink?
    private var updateCallback: (() -> Void)?
    
    enum ControlMode {
        case p1, p2, both
    }
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        
        // Calculate positions based on screen size
        let centerY = screenSize.height / 2
        
        self.p1Fixed = Vector2(x: screenSize.width / 3, y: centerY)
        self.p2Fixed = Vector2(x: 2 * screenSize.width / 3, y: centerY)
        
        self.p0 = Vector2(x: 120, y: centerY)
        self.p3 = Vector2(x: screenSize.width - 120, y: centerY)
        
        self.p1 = SpringPoint(x: p1Fixed.x, y: p1Fixed.y, stiffness: 0.06, damping: 0.55)
        self.p2 = SpringPoint(x: p2Fixed.x, y: p2Fixed.y, stiffness: 0.08, damping: 0.6)
        
        setupDisplayLink()
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateFrame() {
        updatePhysics()
        updateFPS()
        updateCallback?()
    }
    
    private func updatePhysics() {
        let motionScale: CGFloat = 150
        let centerX = screenSize.width / 2
        let centerY = screenSize.height / 2
        
        if motionManager.isActive {
            switch controlMode {
            case .p1:
                let targetX = centerX + CGFloat(motionManager.roll) * motionScale
                let targetY = centerY + CGFloat(motionManager.pitch) * motionScale
                p1.setTarget(x: targetX, y: targetY)
                p2.setTarget(x: p2Fixed.x, y: p2Fixed.y)
                
            case .p2:
                let targetX = centerX + CGFloat(motionManager.roll) * motionScale
                let targetY = centerY + CGFloat(motionManager.pitch) * motionScale
                p2.setTarget(x: targetX, y: targetY)
                p1.setTarget(x: p1Fixed.x, y: p1Fixed.y)
                
            case .both:
                let offsetX = CGFloat(motionManager.roll) * motionScale
                let offsetY = CGFloat(motionManager.pitch) * motionScale * 0.6
                p1.setTarget(x: centerX - 100 + offsetX, y: centerY + offsetY)
                p2.setTarget(x: centerX + 100 + offsetX, y: centerY + offsetY)
            }
        } else {
            p1.setTarget(x: p1Fixed.x, y: p1Fixed.y)
            p2.setTarget(x: p2Fixed.x, y: p2Fixed.y)
        }
        
        p1.update()
        p2.update()
    }
    
    private func updateFPS() {
        frameCount += 1
        let now = Date()
        let delta = now.timeIntervalSince(lastFpsUpdate)
        
        if delta >= 0.5 {
            fps = Int(round(Double(frameCount) / delta))
            frameCount = 0
            lastFpsUpdate = now
        }
    }
    
    func setControlMode(_ mode: ControlMode) {
        controlMode = mode
    }
    
    func setUpdateCallback(_ callback: @escaping () -> Void) {
        self.updateCallback = callback
    }
    
    func updateScreenSize(_ size: CGSize) {
        self.screenSize = size
        
        // Update all points with new size
        let centerY = size.height / 2
        
        self.p1Fixed = Vector2(x: size.width / 3, y: centerY)
        self.p2Fixed = Vector2(x: 2 * size.width / 3, y: centerY)
        
        self.p0 = Vector2(x: 120, y: centerY)
        self.p3 = Vector2(x: size.width - 120, y: centerY)
        
        // Reset spring points
        self.p1 = SpringPoint(x: p1Fixed.x, y: p1Fixed.y, stiffness: 0.06, damping: 0.55)
        self.p2 = SpringPoint(x: p2Fixed.x, y: p2Fixed.y, stiffness: 0.08, damping: 0.6)
    }
    
    deinit {
        displayLink?.invalidate()
    }
}
