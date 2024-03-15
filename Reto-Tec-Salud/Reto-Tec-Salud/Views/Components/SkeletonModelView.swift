import SwiftUI
import RealityKit
import RealityKitContent

struct SkeletonModelView: View {
    @State private var rotation: Angle = .zero
    @State private var rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 0, 1) // Default axis
    @GestureState private var isDragging = false

    var body: some View {
        Model3D(named: "Skeleton", bundle: realityKitContentBundle)
            .scaleEffect(0.45)
            .padding(.bottom, 3300)
            .padding(.leading, 1000) // Adds 1000 points of padding on the left side
            .rotation3DEffect(rotation, axis: rotationAxis)
            .gesture(
                DragGesture()
                    .updating($isDragging) { value, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        // Calculate rotation angle based on drag
                        let angle = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                        rotation = Angle(degrees: Double(angle))

                        // Calculate rotation axis
                        let axisX = -value.translation.height / CGFloat(angle)
                        let axisY = value.translation.width / CGFloat(angle)
                        rotationAxis = (x: axisX, y: axisY, z: 0)
                    }
            )
    }
}
