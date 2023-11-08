//
//  Optional.swift
//  FunctionalProgramming
//
//  Created by Choiwansik on 2023/08/22.
//

import Foundation

internal func lift0<T>(_ transform: @escaping () -> T) -> (() -> T?) {
    { () -> T? in
        transform()
    }
}

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

internal func lift1<T, U, V>(_ transform: @escaping (T, U) -> V) -> (Optional<T>, U) -> Optional<V> {
    return { (ft: Optional<T>, u: U) in
        let f_u = { (t: T) -> V in
            transform(t, u)
        }
        return lift(f_u)(ft)
    }
}

internal func lift2<T, U, V>(_ transform: @escaping (T, U) -> V) -> (T, Optional<U>) -> Optional<V> {
    return { (t: T, fu: Optional<U>) in
        let f_t = { (u: U) -> V in
            return transform(t, u)
        }
        return lift(f_t)(fu)
    }
}

internal func lift2dEasy<T, U, V>(_ transform: @escaping (T, U) -> V) -> (Optional<T>, Optional<U>) -> Optional<Optional<V>> {
    lift2(lift1(transform))
}

internal func lift2d<T, U, V>(_ transform: @escaping (T, U) -> V) -> (T?, U?) -> V?? {
    { ft, fu in
        lift { (t: T) -> V? in
            lift { (u: U) -> V in
                transform(t, u)
            }(fu)
        }(ft)
    }
}

internal func flat<T>(_ value: Optional<Optional<T>>) -> Optional<T> {
    switch value {
        case .none:
            return .none
        case .some(let wrapped):
            return wrapped
    }
}

internal func flatLift<T, U>(_ transform: @escaping (T) -> Optional<U>) -> ((Optional<T>) -> Optional<U>) {
    { input in
        flat(lift(transform)(input))
    }
}

internal func flatLift2d<T1, T2, U>(_ transform: @escaping (T1, T2) -> U?) -> (T1?, T2?) -> U? {
    { mt1, mt2 in
        flatLift { t1 in
            flatLift { t2 in
                transform(t1, t2)
            }(mt2)
        }(mt1)
    }
}

internal func flatLift3d<T1, T2, T3, U>(_ transform: @escaping (T1, T2, T3) -> U?) -> (T1?, T2?, T3?) -> U? {
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
