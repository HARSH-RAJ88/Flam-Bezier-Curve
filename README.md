# Flam-Bezier-Curve

An interactive Bézier curve visualization and control app with real-time physics-based sensor interaction. This project implements smooth parametric curves and allows dynamic manipulation of control points using device sensor input (e.g., accelerometer/gyroscope) and touch gestures. The implementation emphasizes both mathematical correctness and real-world responsiveness on mobile platforms.

## Table of Contents

1. [Overview]  
2. [Mathematical Background]
3. [Physics & Interaction Model]
4. [Implementation Details]
5. [Design Choices]
6. [Usage] 
7. [References]

## Overview

This project draws smooth Bézier curves based on user-defined control points and applies physical inputs from device sensors to interactively influence the shape and behavior of the curve. Bézier curves are widely used in computer graphics to represent smooth, continuous paths defined by a small set of control points.

Interactive manipulation is achieved through gyroscopic and sensor data that updates control points dynamically, giving feedback that feels intuitive and responsive.


## Mathematical Background

### What is a Bézier Curve?

A Bézier curve is a parametric curve defined by a set of control points. For an order-n curve, there are (n+1) control points. The position on the curve (B(t)) for a parameter (t in [0,1]) can be computed as:

[B(t) = sum_{i=0}^{n} {n choose i}(1-t)^{n-i}t^iP_i]

where:
- (P0, P1, ..., Pn) are control points,
- ({n choose i}) are binomial coefficients,
- (t) determines how far along the curve the evaluation occurs.

For example:
- **Linear Bézier curve** (two points) yields a straight line segment.
- **Quadratic or cubic** curves (three or four points) create increasingly complex and smooth shapes.

### Parameter Evaluation

Curves are evaluated by iterating (t) from 0 to 1, interpolating between control points using recursive linear interpolation (e.g., De Casteljau’s algorithm), which is both numerically stable and suitable for animation and real-time interaction.

## Physics & Interaction Model

To make the curve interactive and responsive, this project maps input from physical sensors (e.g., accelerometer and gyroscope) to control point movement and curve modulation:
- **Device tilt/rotation** can alter the position of specific control points.
- **Damping or spring models** smooth the motion so sudden input doesn’t result in sharp discontinuities.

By introducing these forces and constraints, the curve reacts in a way that feels both natural and visually engaging. The physics layer mediates between raw sensor input and curve parameters, ensuring stability and preventing erratic behavior.


## Implementation Details

### Language & Frameworks

- **Swift / SwiftUI (or UIKit)** — Native UI framework for rendering and interaction.
- Modular structure with distinct directories for models, views, and utilities.

### Core Modules

#### `BezierCurvePhysicsApp.swift`

Acts as the entry point of the app and sets up the main view containing the interactive curve.

#### Models

- **Control Point Model** — Represents a point in 2D space with properties that can be updated based on user and sensor input.
- **Curve Evaluator** — Computes points on the Bézier curve for rendering at each frame.

#### ViewModels

- **Input Manager** — Listens to sensor updates and translates them into coordinate changes.
- **Curve Updater** — Aggregates gyroscopic and sensor data and updates the curve in response.

#### Views

Visual components that display:
- Dynamic curves with smooth transitions.
- Control points that can be interacted with.
- Optional guides / hulls for debugging or visualization.

#### Utils

Reusable utilities for mathematical interpolation, smoothing functions (e.g., low-pass filters on sensor data), and rendering helpers.


## Design Choices

### Why Parametric Bézier Curves?

Bézier curves are:
- Efficient to compute and animate.
- Intuitive to manipulate with a small number of control points.
- Well understood in graphics and UI design.

These properties make them ideal for an interactive tool where responsiveness and performance matter.

### Sensor Modulation Strategy

Real-world sensors (e.g., accelerometers) are noisy. Rather than applying raw data directly to control points, this implementation uses filtering and optional damping to produce smooth motion, which improves usability and reduces jitter.

### Render Performance

Rendering prioritizes real-time updates over ultra-high fidelity. The curve is re-evaluated at a sufficient number of samples to appear smooth but stays within performance budgets for mobile hardware.


## Usage

1. Launch the app on a device with motion sensors enabled.
2. Choose control points with buttons to shape the curve.(p1, p2 or both)
3. Tilt or rotate the device to influence control points dynamically.
4. Observe how the curve evolves in response to gyroscopic — sensor's complex interactions.


## References

1. Bézier curve definition and properties — https://developer.apple.com/documentation/uikit/uibezierpath  
2. Documentation for Swift - https://www.swift.org/documentation/
3. Documentations for CADisplayLink - https://developer.apple.com/documentation/quartzcore/cadisplaylink
4. Documentation for Coremotion -https://developer.apple.com/documentation/coremotion
