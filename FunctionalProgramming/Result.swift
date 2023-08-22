//
//  Result.swift
//  FunctionalProgramming
//
//  Created by Choiwansik on 2023/08/22.
//

import Foundation

internal func lift<T, U>(_ transform: @escaping (T) -> U) -> (Result<T, Error>) -> Result<U, Error> {
    return { (input: Result<T, Error>) -> Result<U, Error> in
        switch input {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            return .success(transform(value))
        }
    }
}
