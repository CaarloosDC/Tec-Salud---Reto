//
//  Throttler.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/22/24.
//

import Foundation

class Throttler {
    private var dispatchWorkItem: DispatchWorkItem = DispatchWorkItem {}
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval
    
    init(queue: DispatchQueue = DispatchQueue.global(qos: .userInteractive), minimumDelay: TimeInterval) {
        self.queue = queue
        self.minimumDelay = minimumDelay
    }
    
    func throttle(_ block: @escaping () -> Void) {
        // Cancel any work item that hasn't been excecuted
        dispatchWorkItem.cancel()
        
        // Reassign a newer work item
        dispatchWorkItem = DispatchWorkItem { [weak self] in
            self?.previousRun = Date()
            block() // Place holder for an actual block of code
        }
        
        let delay = previousRun.timeIntervalSinceNow > minimumDelay ? 0: minimumDelay
        queue.asyncAfter(deadline: .now() + Double(delay), execute: dispatchWorkItem)
    }
}
