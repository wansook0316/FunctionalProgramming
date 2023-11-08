//
//  MonoidalFunctor.swift
//  FunctionalProgramming
//
//  Created by Choiwansik on 11/8/23.
//

import Foundation

internal func empty() -> Void {
    ()
}

internal func unite<T, U>(_ t: T, _ u: U) -> (T, U) {
    (t, u)
}

internal func e1<T, U>(_ tu: (T, U)) -> T {
    tu.0
}

internal func e2<T, U>(_ tu: (T, U)) -> U {
    tu.1
}

internal func identity<T>(_ value: T) -> T {
    value
}

internal func unite0() -> Void {
    empty()
}

internal func unite1<T>(_ t: T) -> T {
    identity(t)
}

internal func unite3<T1, T2, T3>(_ t1: T1, _ t2: T2, _ t3: T3) -> ((T1, T2), T3) {
    unite(unite(t1, t2), t3)
}

internal func unite4<T1, T2, T3, T4>(_ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4) -> (((T1, T2), T3), T4) {
    unite(unite3(t1, t2, t3), t4)
}

internal func pure<T>(_ value: T) -> Optional<T> {
    Optional(value)
}

internal func gather<T, U>(_ tuple: (Optional<T>, Optional<U>)) -> Optional<(T, U)> {
    switch tuple {
    case (.some(let t), .some(let u)):
        return Optional((t, u))
    default:
        return nil
    }
}

internal func mUnite0() -> Optional<Void> {
    pure(empty())
}

internal func mUnite1<T>(_ mt: Optional<T>) -> Optional<T> {
    identity(mt)
}

internal func mUnite2<T1, T2>(_ mt1: Optional<T1>,
                             _ mt2: Optional<T2>) -> Optional<(T1, T2)> {
    gather(unite(mt1, mt2))
}

internal func mUnite3<T1, T2, T3>(_ mt1: Optional<T1>,
                                  _ mt2: Optional<T2>,
                                  _ mt3: Optional<T3>) -> Optional<((T1, T2), T3)> {
    mUnite2(mUnite2(mt1, mt2), mt3)
}

internal func mUnite4<T1, T2, T3, T4>(_ mt1: Optional<T1>,
                                      _ mt2: Optional<T2>,
                                      _ mt3: Optional<T3>,
                                      _ mt4: Optional<T4>) -> Optional<(((T1, T2), T3), T4)> {
    mUnite2(mUnite3(mt1, mt2, mt3), mt4)
    // == mUnite2(mUnite2(mUnite2(mt1, mt2), mt3), mt4)
}
