/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how to implement the OperationObserver protocol.
*/

import Foundation

/**
    `TimeoutObserver` is a way to make an `Operation` automatically time out and
    cancel after a specified time interval.
*/
public struct TimeoutObserver: OperationObserver {
    // MARK: Properties

    static let timeoutKey = "Timeout"
    
    private let timeout: TimeInterval
    
    // MARK: Initialization
    
    public init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    // MARK: OperationObserver
    
    public func operationDidStart(operation: TMOperation) {
        // When the operation starts, queue up a block to cause it to time out.
        let when: DispatchTime = .now() + timeout

        DispatchQueue.global().asyncAfter(deadline: when) {
            /*
             Cancel the operation if it hasn't finished and hasn't already
             been cancelled.
             */
            if !operation.isFinished && !operation.isCancelled {
                let error = NSError(code: .executionFailed, userInfo: [
                    type(of: self).timeoutKey: self.timeout
                    ])
                
                operation.cancelWithError(error: error)
            }
        }
    }

    public func operation(operation: TMOperation, didProduceOperation newOperation: Operation) {
        // No op.
    }

    public func operationDidFinish(operation: TMOperation, errors: [Error]) {
        // No op.
    }
}
