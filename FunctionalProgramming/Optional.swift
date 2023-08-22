//
//  Optional.swift
//  FunctionalProgramming
//
//  Created by Choiwansik on 2023/08/22.
//

import Foundation

internal func lift<T, U>(_ transform: @escaping (T) -> U) -> (Optional<T>) -> Optional<U> {
    return { (input: Optional<T>) -> Optional<U> in
        switch input {
        case .none:
            return .none
        case .some(let wrapped):
            return .some(transform(wrapped))
        }
    }
}
