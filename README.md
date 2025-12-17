# Flam Bézier Curve Simulator

An interactive iOS application that brings mathematical Bézier curves to life through physics-based animations and device motion control. This app demonstrates the elegant relationship between mathematical curves and real-world physics, creating a mesmerizing visual experience that responds to your device's movements.

## 📱 Overview

The Flam Bézier Curve Simulator is a SwiftUI-based iOS application that visualizes cubic Bézier curves with dynamic, physics-driven animations. By leveraging your device's accelerometer and gyroscope, the app transforms mathematical curves into interactive art that flows and responds naturally to device tilting and rotation.

Bézier curves are fundamental mathematical constructs widely used in computer graphics, typography, and animation. Named after French engineer Pierre Bézier who popularized their use in automotive design, these curves are defined by control points that determine their shape (Farin, 2002). This application implements cubic Bézier curves (degree 3) with four control points, providing a smooth and predictable interpolation between endpoints.

## ✨ Features

### Core Functionality
- **Real-time Bézier Curve Rendering**: Smooth visualization of cubic Bézier curves with customizable resolution
- **Motion-Controlled Animation**: Device accelerometer and gyroscope data control the curve's control points
- **Physics-Based Simulation**: Spring physics system creates natural, fluid movements
- **Interactive Control Modes**: Switch between controlling different control points or both simultaneously
- **Performance Monitoring**: Real-time FPS (Frames Per Second) display for performance tracking

### Visual Elements
- **Dynamic Gradient Curves**: Beautiful gradient rendering from cyan through blue to purple
- **Tangent Vectors**: Visual representation of curve derivatives with directional arrows
- **Control Polygon**: Dashed lines showing the control point relationships
- **Grid System**: Cartesian coordinate grid for spatial reference
- **Glow Effects**: Enhanced visibility of control points with radial glow effects

## 🔧 Technical Architecture

### Application Structure

The application follows the MVVM (Model-View-ViewModel) architecture pattern, promoting separation of concerns and maintainability (Osmani, 2012).

```
Flam-Bezier-Curve/
├── BezierCurvePhysicsApp.swift    # App entry point and main view
├── Models/
│   ├── BezierMath.swift           # Bézier curve mathematical calculations
│   ├── SpringPoint.swift          # Spring physics implementation
│   └── Vector2.swift              # 2D vector mathematics
├── ViewModels/
│   └── BezierSimulationViewModel.swift  # Business logic and state management
├── Views/
│   ├── BezierCanvasView.swift     # Main canvas rendering
│   ├── ControlButtonsView.swift   # User interface controls
│   └── FPSDisplayView.swift       # Performance display
└── Utils/
    ├── MotionManager.swift        # Device motion handling
    └── DrawingUtils.swift         # Rendering utilities
```

### Key Components

#### 1. Bézier Mathematics (`BezierMath.swift`)

The application implements the standard cubic Bézier curve formula:

**B(t) = (1-t)³P₁ + 3(1-t)²tP₂ + 3(1-t)t²P₃ + t³P₄**

Where:
- **t** ∈ [0, 1] is the curve parameter
- **P₁, P₂, P₃, P₄** are the four control points (as displayed in the app)
- **B(t)** is the point on the curve at parameter t

The tangent vector (first derivative) is calculated as:

**B'(t) = 3(1-t)²(P₂-P₁) + 6(1-t)t(P₃-P₂) + 3t²(P₄-P₃)**

These formulas are based on Bernstein polynomials, which provide the mathematical foundation for Bézier curves (Prautzsch et al., 2002).

#### 2. Spring Physics (`SpringPoint.swift`)

The control points follow spring-damper dynamics, creating smooth and natural motion:

**F = -k·Δx - c·v**

Where:
- **F** is the force applied to the point
- **k** is the spring stiffness constant (0.06-0.08)
- **Δx** is displacement from target position
- **c** is the damping coefficient (0.55-0.65)
- **v** is the current velocity

This implementation follows Hooke's Law combined with viscous damping, providing stable oscillatory behavior (Witkin & Baraff, 2001).

#### 3. Motion Sensing (`MotionManager.swift`)

Utilizes Apple's CoreMotion framework to capture device attitude data:
- **Pitch**: Forward/backward tilt
- **Roll**: Left/right tilt  
- **Yaw**: Rotation around vertical axis

The motion data is processed at 60 Hz and scaled appropriately to control curve control points (Apple Inc., 2024).

## 📋 Requirements

### System Requirements
- **iOS**: 15.0 or later
- **Xcode**: 13.0 or later
- **Swift**: 5.5 or later
- **Device**: iPhone or iPad with accelerometer and gyroscope

### Hardware Requirements
- Physical iOS device recommended for motion control features
- Simulator can be used but will not have motion sensing capabilities

### Dependencies
- **SwiftUI**: Apple's declarative UI framework
- **CoreMotion**: For device motion and orientation data
- **CoreGraphics**: For 2D rendering and path drawing
- **Combine**: For reactive programming and state management

## 🚀 Installation

### Clone the Repository

```bash
git clone https://github.com/HARSH-RAJ88/Flam-Bezier-Curve.git
cd Flam-Bezier-Curve
```

### Open in Xcode

1. Open `Flam-Bezier-Curve.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project (⌘+R)

### Configuration

No additional configuration is required. The app will automatically:
- Initialize curve control points based on screen size
- Start motion sensing on physical devices
- Set up the display link for 60 FPS rendering

## 🎮 Usage

### Basic Controls

The application provides three control modes accessible through the button interface:

1. **P1 Mode**: Device motion controls the first control point (P₂ - first yellow point)
2. **P2 Mode**: Device motion controls the second control point (P₃ - second yellow point)
3. **Both Mode**: Device motion controls both middle control points (P₂ and P₃) simultaneously

### Understanding the Display

- **Red Points**: Endpoint control points (P₁ and P₄) - These remain fixed at the start and end
- **Yellow Points**: Middle control points (P₂ and P₃) - These respond to device motion
- **Gradient Curve**: The actual Bézier curve path interpolating between the control points
- **Dashed Lines**: Control polygon showing relationships between control points
- **Purple Arrows**: Tangent vectors showing the curve's direction at various points
- **Green Dots**: Base points where tangents are calculated on the curve
- **Blue Grid**: Spatial reference grid with Cartesian coordinate axes

### Interacting with the App

1. **Launch the app** on a physical iOS device for best experience
2. **Hold your device** horizontally in landscape orientation
3. **Tilt and rotate** your device to see the curve respond
4. **Switch control modes** using the buttons to explore different behaviors
5. **Observe the FPS counter** in the top-right to monitor performance

## 🧮 Mathematical Concepts

### Cubic Bézier Curves

Cubic Bézier curves are parametric curves defined by four control points. They are part of the broader family of Bézier curves, which can have any degree based on the number of control points (Mortenson, 1997). This application uses 1-based indexing for control point labels (P₁, P₂, P₃, P₄) as displayed in the interface.

**Properties:**
- **Interpolation**: The curve passes through the first and last control points (P₁ and P₄)
- **Approximation**: The curve approximates but doesn't pass through the middle control points (P₂ and P₃)
- **Convex Hull Property**: The curve lies within the convex hull of its control points
- **Affine Invariance**: Transformations can be applied to control points rather than the curve itself
- **Smooth Continuity**: C² continuous, meaning position, velocity, and acceleration are continuous

### Tangent Vectors

The tangent vector at any point on the curve indicates the direction and speed of movement along the curve. This application visualizes tangent vectors at evenly spaced parameter values (t = 0.1, 0.2, ..., 0.9), providing insight into the curve's behavior and flow.

### Spring Dynamics

Spring systems model oscillatory behavior found in nature. The spring-damper model used in this application ensures:
- **Stability**: Points converge to target positions without wild oscillations
- **Responsiveness**: Quick reaction to motion input
- **Naturalness**: Movement feels organic and fluid

The chosen stiffness and damping values were tuned for visual appeal while maintaining stable behavior (Jakobsen, 2001).

## 🎨 Rendering Pipeline

The application uses SwiftUI's Canvas API for high-performance 2D rendering:

1. **Grid Rendering**: Background grid and axes drawn first
2. **Curve Calculation**: Points along the curve calculated using parameterization
3. **Gradient Application**: Linear gradient applied along the curve path
4. **Control Polygon**: Dashed lines connecting control points
5. **Tangent Drawing**: Tangent vectors with directional arrowheads
6. **Control Points**: Final layer showing interactive control points with glow effects

The rendering occurs at display refresh rate (typically 60 FPS) using CADisplayLink synchronization.

## 📚 Code Structure Details

### Vector2 (`Vector2.swift`)

A utility class for 2D vector operations including:
- Addition, subtraction, multiplication
- Magnitude and normalization
- Dot product calculations
- Conversion to/from CGPoint

### BezierSimulationViewModel

The central coordinator managing:
- Physics simulation updates
- Motion data processing
- Screen size adaptation
- FPS calculation
- Control mode switching

### BezierCanvasView

Responsible for rendering all visual elements using SwiftUI's declarative syntax and Canvas API for optimal performance.

## 🔬 Performance Considerations

- **Adaptive Step Size**: The curve is drawn with 0.008 step increments (125 segments) for smooth appearance
- **Display Link Synchronization**: Updates synchronized with screen refresh rate
- **Efficient Rendering**: Canvas API provides hardware-accelerated drawing
- **Spring Physics Optimization**: Calculation complexity is O(1) per point per frame

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository** on GitHub
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request** with a clear description of your changes

### Contribution Guidelines

- Follow Swift coding conventions and style guides
- Add comments for complex algorithms
- Test thoroughly on physical devices
- Update documentation for new features
- Ensure code passes any existing tests

## 📄 License

This project is available for educational and personal use. Please refer to the repository for specific licensing terms.

## 🙏 Acknowledgments

- Pierre Bézier for pioneering the use of these curves in computer-aided design
- Apple Inc. for providing excellent frameworks (SwiftUI, CoreMotion, CoreGraphics)
- The computer graphics community for extensive research on curve visualization

## 📖 References

Apple Inc. (2024). *CoreMotion framework documentation*. Apple Developer Documentation. https://developer.apple.com/documentation/coremotion

Farin, G. (2002). *Curves and surfaces for CAGD: A practical guide* (5th ed.). Morgan Kaufmann Publishers.

Jakobsen, T. (2001). Advanced character physics. *Game Developers Conference Proceedings*, 383-401.

Mortenson, M. E. (1997). *Geometric modeling* (2nd ed.). John Wiley & Sons.

Osmani, A. (2012). *Learning JavaScript design patterns*. O'Reilly Media.

Prautzsch, H., Boehm, W., & Paluszny, M. (2002). *Bézier and B-spline techniques*. Springer.

Witkin, A., & Baraff, D. (2001). Physically based modeling: Principles and practice. *SIGGRAPH Course Notes*.

---

**Built with ❤️ using SwiftUI and Mathematics**

*For questions, suggestions, or issues, please open an issue on the GitHub repository.*
