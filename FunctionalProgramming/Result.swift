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

internal func lift1<T, U, V>(_ transform: @escaping (T, U) -> V) -> (Result<T, Error>, U) -> Result<V, Error> {
    { (ft: Result<T, Error>, u: U) in
        let f_u = { (t: T) -> V in
            transform(t, u)
        }
        return lift(f_u)(ft)
    }
}

internal func lift2<T, U, V>(_ transform: @escaping (T, U) -> V) -> (T, Result<U, Error>) -> Result<V, Error> {
    { (t: T, fu: Result<U, Error>) in
        let f_v = { (u: U) -> V in
            transform(t, u)
        }
        return lift(f_v)(fu)
    }
}

internal func lift2dEasy<T, U, V>(_ transform: @escaping (T, U) -> V) -> (Result<T, Error>, Result<U, Error>) -> Result<Result<V, Error>, Error> {
    lift2(lift1(transform))
}

internal func lift2d<T, U, V>(_ transform: @escaping (T, U) -> V) -> (Result<T, Error>, Result<U, Error>) -> Result<Result<V, Error>, Error> {
    { ft, fu in
        lift { (t: T) -> Result<V, Error> in
            lift { (u: U) -> V in
                transform(t, u)
            }(fu)
        }(ft)
    }
}
