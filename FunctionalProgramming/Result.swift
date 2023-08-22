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

internal func flat<T>(_ value: Result<Result<T, Error>, Error>) -> Result<T, Error> {
    switch value {
    case let .success(success):
        switch success {
        case let .success(success):
            return .success(success)
        case let .failure(failure):
            return .failure(failure)
        }
    case let .failure(failure):
        return .failure(failure)
    }
}

internal func flatLift<T, U>(_ transform: @escaping (T) -> Result<U, Error>) -> ((Result<T, Error>) -> Result<U, Error>) {
    { input in
        flat(lift(transform)(input))
    }
}

internal func flatLift2d<T1, T2, U>(_ transform: @escaping (T1, T2) -> Result<U, Error>) -> (Result<T1, Error>, Result<T2, Error>) -> Result<U, Error> {
    { mt1, mt2 in
        flatLift { t1 in
            flatLift { t2 in
                transform(t1, t2)
            }(mt2)
        }(mt1)
    }
}

internal func flatLift3d<T1, T2, T3, U>(_ transform: @escaping (T1, T2, T3) -> Result<U, Error>) -> (Result<T1, Error>, Result<T2, Error>, Result<T3, Error>) -> Result<U, Error> {
    { mt1, mt2, mt3 in
        flatLift { t1 in
            flatLift { t2 in
                flatLift { t3 in
                    transform(t1, t2, t3)
                }(mt3)
            }(mt2)
        }(mt1)
    }
}
