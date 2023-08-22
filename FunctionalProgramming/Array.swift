//
//  Array.swift
//  FunctionalProgramming
//
//  Created by Choiwansik on 2023/08/22.
//

import Foundation

enum ArrayScope {

}

internal func lift<T, U>(_ transform: @escaping (T) -> U) -> ([T]) -> [U] {
    return { (input: [T]) -> [U] in
        var result: [U] = []
        for index in input.indices {
            result.append(transform(input[index]))
        }
        return result
    }
}

internal func lift1<T, U, V>(_ transform: @escaping (T, U) -> V) -> ([T], U) -> [V] {
    { (ft: [T], u: U) in
        let f_u = { (t: T) -> V in
            transform(t, u)
        }
        return lift(f_u)(ft)
    }
}

internal func lift2<T, U, V>(_ transform: @escaping (T, U) -> V) -> (T, [U]) -> [V] {
    { (t: T, fu: [U]) in
        let f_v = { (u: U) -> V in
            transform(t, u)
        }
        return lift(f_v)(fu)
    }
}

internal func lift2dEasy<T, U, V>(_ transform: @escaping (T, U) -> V) -> ([T], [U]) -> [[V]] {
    lift2(lift1(transform))
}

internal func lift2d<T, U, V>(_ transform: @escaping (T, U) -> V) -> ([T], [U]) -> [[V]] {
    { ft, fu in
        lift { (t: T) -> [V] in
            lift { (u: U) -> V in
                transform(t, u)
            }(fu)
        }(ft)
    }
}

internal func flat<T>(_ value: [[T]]) -> [T] {
    var result: [T] = []
    for i in value {
        for j in i {
            result.append(j)
        }
    }
    return result
}

internal func flatLift<T, U>(_ transform: @escaping (T) -> [U]) -> (([T]) -> [U]) {
    { input in
        flat(lift(transform)(input))
    }
}

internal func flatLift2d<T1, T2, U>(_ transform: @escaping (T1, T2) -> [U]) -> ([T1], [T2]) -> [U] {
    { mt1, mt2 in
        flatLift { t1 in
            flatLift { t2 in
                transform(t1, t2)
            }(mt2)
        }(mt1)
    }
}

internal func flatLift3d<T1, T2, T3, U>(_ transform: @escaping (T1, T2, T3) -> [U]) -> ([T1], [T2], [T3]) -> [U] {
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
