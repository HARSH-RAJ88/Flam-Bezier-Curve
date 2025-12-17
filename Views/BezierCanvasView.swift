import SwiftUI

struct BezierCanvasView: View {
    @ObservedObject var viewModel: BezierSimulationViewModel
    
    private let gridSize: CGFloat = 40
    private let gridColor = Color.blue.opacity(0.1)
    private let axisColor = Color.blue.opacity(0.2)
    
    // Arrowhead settings
    private let arrowheadColor = Color.orange
    private let arrowheadSize: CGFloat = 8
    private let tangentLineWidth: CGFloat = 3
    private let tangentLineColor = Color.purple.opacity(0.7)
    private let basePointColor = Color.green.opacity(0.3)
    private let basePointRadius: CGFloat = 4
    
    var body: some View {
        Canvas { context, size in
            // Draw vertical grid lines
            for x in stride(from: 0, through: size.width, by: gridSize) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(gridColor), lineWidth: 1)
            }
            
            // Draw horizontal grid lines
            for y in stride(from: 0, through: size.height, by: gridSize) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(gridColor), lineWidth: 1)
            }
            
            // Draw axes
            var axisPath = Path()
            // Vertical axis
            axisPath.move(to: CGPoint(x: size.width / 2, y: 0))
            axisPath.addLine(to: CGPoint(x: size.width / 2, y: size.height))
            // Horizontal axis
            axisPath.move(to: CGPoint(x: 0, y: size.height / 2))
            axisPath.addLine(to: CGPoint(x: size.width, y: size.height / 2))
            context.stroke(axisPath, with: .color(axisColor), lineWidth: 1.5)
            
            // Draw the Bézier curve
            drawBezierCurve(context: &context)
            
            // Draw the control polygon
            drawControlPolygon(context: &context)
            
            // Draw tangents with arrowheads
            drawTangents(context: &context)
            
            // Draw control points
            drawControlPoints(context: &context)
        }
        .background(Color(red: 15.0/255.0, green: 23.0/255.0, blue: 42.0/255.0))
    }
    
    private func drawBezierCurve(context: inout GraphicsContext) {
        var bezierPath = Path()
        var first = true
        
        for t in stride(from: CGFloat(0), through: 1, by: viewModel.tStep) {
            let point = BezierMath.bezierPoint(
                t: t,
                p0: viewModel.p0,
                p1: viewModel.p1.position,
                p2: viewModel.p2.position,
                p3: viewModel.p3
            )
            
            if first {
                bezierPath.move(to: point.cgPoint)
                first = false
            } else {
                bezierPath.addLine(to: point.cgPoint)
            }
        }
        
        // Gradient stroke for the curve
        var strokeContext = context
        strokeContext.stroke(
            bezierPath,
            with: .linearGradient(
                Gradient(colors: [.cyan, .blue, .purple]),
                startPoint: viewModel.p0.cgPoint,
                endPoint: viewModel.p3.cgPoint
            ),
            lineWidth: 4
        )
    }
    
    private func drawControlPolygon(context: inout GraphicsContext) {
        var polygonPath = Path()
        polygonPath.move(to: viewModel.p0.cgPoint)
        polygonPath.addLine(to: viewModel.p1.position.cgPoint)
        polygonPath.addLine(to: viewModel.p2.position.cgPoint)
        polygonPath.addLine(to: viewModel.p3.cgPoint)
        
        context.stroke(polygonPath, with: .color(Color.gray.opacity(0.7)),
                      style: StrokeStyle(lineWidth: 2.5, dash: [6, 6], dashPhase: 3))
    }
    
    private func drawTangents(context: inout GraphicsContext) {
        for t in viewModel.tangentPoints {
            let point = BezierMath.bezierPoint(
                t: t,
                p0: viewModel.p0,
                p1: viewModel.p1.position,
                p2: viewModel.p2.position,
                p3: viewModel.p3
            )
            
            let tan = BezierMath.bezierTangent(
                t: t,
                p0: viewModel.p0,
                p1: viewModel.p1.position,
                p2: viewModel.p2.position,
                p3: viewModel.p3
            ).normalize()
            
            // Calculate end point of tangent line
            let end = point.add(tan.multiply(viewModel.tangentLength))
            
            // Draw base point (circle at the tangent point on curve)
            let baseCircle = Path(ellipseIn: CGRect(
                x: point.x - basePointRadius,
                y: point.y - basePointRadius,
                width: basePointRadius * 2,
                height: basePointRadius * 2
            ))
            context.fill(baseCircle, with: .color(basePointColor))
            
            // Draw tangent line
            var tangentPath = Path()
            tangentPath.move(to: point.cgPoint)
            tangentPath.addLine(to: end.cgPoint)
            context.stroke(tangentPath, with: .color(tangentLineColor), lineWidth: tangentLineWidth)
            
            // Draw arrowhead at the end
            drawArrowhead(context: &context, at: end.cgPoint, direction: tan)
        }
    }
    
    private func drawArrowhead(context: inout GraphicsContext, at point: CGPoint, direction: Vector2) {
        let arrowSize = arrowheadSize
        let angle = atan2(direction.y, direction.x)
        
        // Calculate arrowhead points
        let arrowAngle1 = angle + CGFloat.pi * 0.75  // 135 degrees
        let arrowAngle2 = angle - CGFloat.pi * 0.75  // -135 degrees
        
        let point1 = CGPoint(
            x: point.x + arrowSize * cos(arrowAngle1),
            y: point.y + arrowSize * sin(arrowAngle1)
        )
        
        let point2 = CGPoint(
            x: point.x + arrowSize * cos(arrowAngle2),
            y: point.y + arrowSize * sin(arrowAngle2)
        )
        
        // Create arrowhead path (filled triangle)
        var arrowPath = Path()
        arrowPath.move(to: point)
        arrowPath.addLine(to: point1)
        arrowPath.addLine(to: point2)
        arrowPath.closeSubpath()
        
        // Fill the arrowhead
        context.fill(arrowPath, with: .color(arrowheadColor))
        
        // Optional: Stroke the arrowhead for better visibility
        context.stroke(arrowPath, with: .color(Color.orange.opacity(0.8)), lineWidth: 1)
    }
    
    private func drawControlPoints(context: inout GraphicsContext) {
        // Draw control points with glow effect
        drawControlPointWithGlow(context: &context,
                                position: viewModel.p0.cgPoint,
                                color: .red,
                                size: 18,
                                label: "P₁")
        
        drawControlPointWithGlow(context: &context,
                                position: viewModel.p1.position.cgPoint,
                                color: .yellow,
                                size: 22,
                                label: "P₂")
        
        drawControlPointWithGlow(context: &context,
                                position: viewModel.p2.position.cgPoint,
                                color: .yellow,
                                size: 22,
                                label: "P₃")
        
        drawControlPointWithGlow(context: &context,
                                position: viewModel.p3.cgPoint,
                                color: .red,
                                size: 18,
                                label: "P₄")
    }
    
    private func drawControlPointWithGlow(context: inout GraphicsContext, position: CGPoint, color: Color, size: CGFloat, label: String) {
        // Draw glow (outer circle)
        let glowSize = size + 4
        let glowPath = Path(ellipseIn: CGRect(
            x: position.x - glowSize/2,
            y: position.y - glowSize/2,
            width: glowSize,
            height: glowSize
        ))
        context.fill(glowPath, with: .color(color.opacity(0.3)))
        
        // Draw main circle
        let circlePath = Path(ellipseIn: CGRect(
            x: position.x - size/2,
            y: position.y - size/2,
            width: size,
            height: size
        ))
        context.fill(circlePath, with: .color(color))
        
        // Draw inner highlight
        let highlightSize = size * 0.6
        let highlightPath = Path(ellipseIn: CGRect(
            x: position.x - highlightSize/2,
            y: position.y - highlightSize/2,
            width: highlightSize,
            height: highlightSize
        ))
        context.fill(highlightPath, with: .color(color.opacity(0.7)))
        
        // Draw label
        let text = Text(label).font(.system(size: size * 0.6, weight: .bold)).foregroundColor(.white)
        context.draw(text, at: position)
    }
}
