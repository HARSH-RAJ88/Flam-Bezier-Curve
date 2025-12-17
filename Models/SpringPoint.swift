import Foundation
import CoreGraphics

class SpringPoint: ObservableObject {
    @Published var position: Vector2
    @Published var velocity: Vector2
    var target: Vector2
    
    let stiffness: CGFloat
    let damping: CGFloat
    
    init(x: CGFloat, y: CGFloat, stiffness: CGFloat = 0.08, damping: CGFloat = 0.65) {
        self.position = Vector2(x: x, y: y)
        self.velocity = Vector2(x: 0, y: 0)
        self.target = Vector2(x: x, y: y)
        self.stiffness = stiffness
        self.damping = damping
    }
    
    func update() {
        let displacement = position.subtract(target)
        let spring = displacement.multiply(-stiffness)
        let dampingForce = velocity.multiply(-damping)
        let acceleration = spring.add(dampingForce)
        
        velocity = velocity.add(acceleration)
        position = position.add(velocity)
    }
    
    func setTarget(x: CGFloat, y: CGFloat) {
        target.x = x
        target.y = y
    }
}
