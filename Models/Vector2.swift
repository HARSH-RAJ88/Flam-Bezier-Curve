import Foundation
import CoreGraphics

struct Vector2 {
    var x: CGFloat
    var y: CGFloat
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    init(point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }
    
    func add(_ v: Vector2) -> Vector2 {
        return Vector2(x: self.x + v.x, y: self.y + v.y)
    }
    
    func subtract(_ v: Vector2) -> Vector2 {
        return Vector2(x: self.x - v.x, y: self.y - v.y)
    }
    
    func multiply(_ s: CGFloat) -> Vector2 {
        return Vector2(x: self.x * s, y: self.y * s)
    }
    
    func magnitude() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    func normalize() -> Vector2 {
        let m = self.magnitude()
        return m == 0 ? Vector2(x: 0, y: 0) : Vector2(x: self.x / m, y: self.y / m)
    }
    
    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}
