//
//  Array.swift
//  FunctionalProgramming
//
//  Created by Choiwansik on 2023/08/22.
//

import Foundation

internal func lift<T, U>(_ transform: @escaping (T) -> U) -> ([T]) -> [U] {
    return { (input: [T]) -> [U] in
        var result: [U] = []
        for index in input.indices {
            result.append(transform(input[index]))
        }
        return result
    }
}
