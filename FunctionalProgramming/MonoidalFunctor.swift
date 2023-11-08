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

internal func uniteArg3<T1, T2, T3, U>(_ f: @escaping ((T1, T2, T3) -> U)) -> (((T1, T2), T3)) -> U {
    { t12_3  in
        f(e1(e1(t12_3)), e2(e1(t12_3)), e2(t12_3))
    }
}

internal func pure<T>(_ value: T) -> Optional<T> {
    Optional(value)
}

internal func pureFromLift<T>(_ value: T) -> Optional<T> {
    lift0 { () -> T in
        value
    }()
}

internal func gather<T, U>(_ tuple: (Optional<T>, Optional<U>)) -> Optional<(T, U)> {
    switch tuple {
    case (.some(let t), .some(let u)):
        return Optional((t, u))
    default:
        return nil
    }
}

internal func gatherFromLift<T, U>(_ tuple: (Optional<T>, Optional<U>)) -> Optional<(T, U)> {
    mUnite2(e1(tuple), e2(tuple))
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

internal func lift3<T1, T2, T3, U>(_ f: @escaping ((T1, T2, T3) -> U)) -> (T1?, T2?, T3?) -> U? {
    { mt1, mt2, mt3 in
        lift(uniteArg3(f))(mUnite3(mt1, mt2, mt3))
    }
}

internal func mUnite3FromLift<T1, T2, T3>(_ mt1: Optional<T1>,
                                          _ mt2: Optional<T2>,
                                          _ mt3: Optional<T3>) -> Optional<((T1, T2), T3)> {
    lift3(unite3)(mt1, mt2, mt3)
}

enum Summary {

}

extension Summary {

    // 아래 4개의 함수가 동작하는 언어여야 Monoidal Functor는 정의된다.

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

}

extension Summary {

    // Monoidal Functor가 되기 위한 조건
    // 아래의 두 함수만 정의되면 된다.

    internal func pure<T>(_ t: T) -> T? {
        Optional(t)
    }

    internal func gather<T, U>(_ tuple: (T?, U?)) -> (T, U)? {
        switch tuple {
        case (.some(let t), .some(let u)):
            return Optional((t, u))
        default:
            return nil
        }
    }

}

extension Summary {

    // 이상황에서 우리가 하고 싶은게 뭘까?
    // 우리가 하고 싶은 건 다인수 함수의 lift를 잘 정의하는 것이다.
    // ((T1, T2, T3) -> U)) -> (T1?, T2?, T3?) -> U? 이런 형태.

    // 먼저 unite_n을 정의하자. n개에 대해서는 안되니 3개까지만 해보자.

    internal func unite0() -> Void {
        empty()
    }

    internal func unite1<T>(_ t: T) -> T {
        identity(t)
    }

    internal func unite2<T1, T2>(_ t1: T1, _ t2: T2) -> (T1, T2) {
        (t1, t2)
    }

    internal func unite3<T1, T2, T3>(_ t1: T1, _ t2: T2, _ t3: T3) -> ((T1, T2), T3) {
        unite(unite(t1, t2), t3)
    }

}

extension Summary {

    // 다음으로 m_unite_n을 정의하자.

    internal func mUnite0() -> Void? {
        pure(empty())
    }

    internal func mUnite1<T>(_ mt: T?) -> T? {
        identity(mt)
    }

    internal func mUnite2<T1, T2>(_ mt1: T1?,
                                  _ mt2: T2?) -> (T1, T2)? {
        gather(unite(mt1, mt2))
    }

    internal func mUnite3<T1, T2, T3>(_ mt1: T1?,
                                      _ mt2: T2?,
                                      _ mt3: T3?) -> ((T1, T2), T3)? {
        mUnite2(mUnite2(mt1, mt2), mt3)
    }

}

extension Summary {

    // 마지막 하나의 함수만 더 정의하자. uniteArg3.

    internal func uniteArg3<T1, T2, T3, U>(_ f: @escaping ((T1, T2, T3) -> U)) -> (((T1, T2), T3)) -> U {
        { t12_3  in
            f(e1(e1(t12_3)), e2(e1(t12_3)), e2(t12_3))
        }
    }

}

extension Summary {

    // 이제 lift 함수를 만들어보자.

    internal func lift2<T1, T2, U>(_ f: @escaping ((T1, T2) -> U)) -> (T1?, T2?) -> U? {
        { mt1, mt2 in
            lift(f)(mUnite2(mt1, mt2))
        }
    }

    internal func lift3<T1, T2, T3, U>(_ f: @escaping ((T1, T2, T3) -> U)) -> (T1?, T2?, T3?) -> U? {
        { mt1, mt2, mt3 in
            lift(uniteArg3(f))(mUnite3(mt1, mt2, mt3))
        }
    }

}

extension Summary {

    // 그런데 lift3로 mUnite3을 표현할 수 있다.

    internal func mUnite2FromLift<T1, T2>(_ mt1: T1?,
                                          _ mt2: T2?) -> (T1, T2)? {
        lift2(unite2)(mt1, mt2)
    }

    internal func mUnite3FromLift<T1, T2, T3>(_ mt1: T1?,
                                              _ mt2: T2?,
                                              _ mt3: T3?) -> ((T1, T2), T3)? {
        lift3(unite3)(mt1, mt2, mt3)
    }

    // 뭔가 이상하다. lift를 찾아온 여정인데, 그결과로 자신을 정의할 수 있다니.
    // 즉 동치인 구조를 발견한 것이다.

}

enum Veritication {

}

extension Veritication {

    // 필요 함수

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

    internal func lift2<T1, T2, U>(_ f: @escaping ((T1, T2) -> U)) -> (T1?, T2?) -> U? {
        { mt1, mt2 in
            lift(f)(mUnite2(mt1, mt2))
        }
    }

    internal func unite2<T1, T2>(_ t1: T1, _ t2: T2) -> (T1, T2) {
        (t1, t2)
    }

    // 증명 시작

    internal func pure<T>(_ t: T) -> T? {
        Optional(t)
    }

    internal func pureFromLift<T>(_ value: T) -> Optional<T> {
        lift0 { () -> T in
            value
        }()
    }

    internal func gather<T, U>(_ tuple: (T?, U?)) -> (T, U)? {
        switch tuple {
        case (.some(let t), .some(let u)):
            return Optional((t, u))
        default:
            return nil
        }
    }

    internal func gatherFromLift<T, U>(_ tuple: (Optional<T>, Optional<U>)) -> Optional<(T, U)> {
        //        mUnite2(e1(tuple), e2(tuple))
        mUnite2FromLift(e1(tuple), e2(tuple))
    }

    internal func mUnite2<T1, T2>(_ mt1: T1?,
                                  _ mt2: T2?) -> (T1, T2)? {
        gather(unite(mt1, mt2))
    }

    internal func mUnite2FromLift<T1, T2>(_ mt1: T1?,
                                          _ mt2: T2?) -> (T1, T2)? {
        lift2(unite2)(mt1, mt2)
    }

}
