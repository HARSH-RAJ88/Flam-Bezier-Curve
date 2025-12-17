import Foundation
import CoreGraphics

class BezierMath {
    static func bezierPoint(t: CGFloat, p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) -> Vector2 {
        let mt = 1 - t
        let mt2 = mt * mt
        let mt3 = mt2 * mt
        let t2 = t * t
        let t3 = t2 * t
        
        let x = mt3 * p0.x + 3 * mt2 * t * p1.x + 3 * mt * t2 * p2.x + t3 * p3.x
        let y = mt3 * p0.y + 3 * mt2 * t * p1.y + 3 * mt * t2 * p2.y + t3 * p3.y
        
        return Vector2(x: x, y: y)
    }
    
    static func bezierTangent(t: CGFloat, p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) -> Vector2 {
        let mt = 1 - t
        let mt2 = mt * mt
        let t2 = t * t
        
        let d0 = p1.subtract(p0)
        let d1 = p2.subtract(p1)
        let d2 = p3.subtract(p2)
        
        let x = 3 * mt2 * d0.x + 6 * mt * t * d1.x + 3 * t2 * d2.x
        let y = 3 * mt2 * d0.y + 6 * mt * t * d1.y + 3 * t2 * d2.y
        
        return Vector2(x: x, y: y)
    }
}
