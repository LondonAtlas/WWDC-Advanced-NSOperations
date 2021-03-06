/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The file shows how to make an OperationCondition that composes another OperationCondition.
*/

import Foundation

/**
    A simple condition that negates the evaluation of another condition.
    This is useful (for example) if you want to only execute an operation if the
    network is NOT reachable.
*/
public struct NegatedCondition<T: OperationCondition>: OperationCondition {
    
    public static var name: String {
        return "Not<\(T.name)>"
    }
    
    public static var negatedConditionKey: String {
        return "NegatedCondition"
    }
    
    public static var isMutuallyExclusive: Bool {
        return T.isMutuallyExclusive
    }
    
    let condition: T

    public init(condition: T) {
        self.condition = condition
    }
    
    public func dependencyForOperation(operation: Operation) -> Operation? {
        return condition.dependencyForOperation(operation: operation)
    }
    
    public func evaluateForOperation(operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        condition.evaluateForOperation(operation: operation) { result in
            if result == .satisfied {
                // If the composed condition succeeded, then this one failed.
                
                let typeOfSelf = type(of: self)
                let error = NSError(code: .conditionFailed, userInfo: [
                    OperationConditionKey: typeOfSelf.name,
                    typeOfSelf.negatedConditionKey: type(of: self.condition).name
                    ])
                
                completion(.failed(error))
            }
            else {
                // If the composed condition failed, then this one succeeded.
                completion(.satisfied)
            }
        }
    }
}
