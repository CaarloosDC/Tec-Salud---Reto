//
//  BodyPartClassifierExtension.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/15/24.
//

import CoreML
import Vision

/// Wrapper for the input to include bounding box coordinates
class BodyPartClassifierInputWithBoundingBox {
    let input: BodyPartClassifier_2Input
    let boundingBox: CGRect
    
    init(input: BodyPartClassifier_2Input, boundingBox: CGRect) {
        self.input = input
        self.boundingBox = boundingBox
    }
}

/// Wrapper for the output to include bounding box coordinates
class BodyPartClassifierOutputWithBoundingBox {
    let output: BodyPartClassifier_2Output
    let boundingBox: CGRect
    
    init(output: BodyPartClassifier_2Output, boundingBox: CGRect) {
        self.output = output
        self.boundingBox = boundingBox
    }
}

/// Extension to BodyPartClassifier_2 for convenience methods with bounding box
extension BodyPartClassifier_2 {
    /// Perform prediction and return output with bounding box coordinates
    func predictionWithBoundingBox(input: BodyPartClassifierInputWithBoundingBox) throws -> BodyPartClassifierOutputWithBoundingBox {
        let output = try self.prediction(input: input.input)
        return BodyPartClassifierOutputWithBoundingBox(output: output, boundingBox: input.boundingBox)
    }
}

