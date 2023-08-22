//
//  main.swift
//  FunctionalProgramming
//
//  Created by Choiwansik on 2023/08/22.
//

import Foundation

main()

func main() {
    testStack()

    testOptionalLift()
    testArrayLift()
    testResultLift()

    testOptionalLift2d()
    testArrayLift2d()
    testResultLift2d()
}

private func testStack() {
    var intStack = Stack<Int>()
    intStack.push(1)
    intStack.push(2)
    intStack.push(3)

    print(intStack.count)
}

private func testOptionalLift() {
    func f(_ x: Int) -> Int {
        return x + 1
    }

    func g(_ x: Int) -> Int {
        return x * 2
    }

    func h(_ x: Int) -> Int {
        return g(f(x))
    }

    let optional = Optional.some(10)
    let result1 = lift({ h($0) })(optional) // Optional.some(22)
    let result2 = lift({ g($0) })(lift({ f($0) })(optional)) // Optional.some(22)
    print(result1)
    print(result2)
}

private func testArrayLift() {
    func f(_ x: Int) -> Int {
        return x + 1
    }

    func g(_ x: Int) -> Int {
        return x * 2
    }

    func h(_ x: Int) -> Int {
        return g(f(x))
    }

    let array = [3, 4, 5, 6]
    let result1 = lift({ h($0) })(array) // [8, 10, 12, 14]
    let result2 = lift({ g($0) })(lift({ f($0) })(array)) // [8, 10, 12, 14]
    print(result1)
    print(result2)
}

private func testResultLift() {
    func f(_ x: Int) -> Int {
        return x + 1
    }

    func g(_ x: Int) -> Int {
        return x * 2
    }

    func h(_ x: Int) -> Int {
        return g(f(x))
    }

    let result: Result<Int, Error> = .success(10)
    let result1 = lift({ h($0) })(result) // success(22)
    let result2 = lift({ g($0) })(lift({ f($0) })(result)) // success(22)
    print(result1)
    print(result2)
}

private func testOptionalLift2d() {
    let x = Optional(3)
    let y = Optional(4)

    let result = lift2d { x, y in
        x+y
    }(x, y)

    print(result) // Optional(Optional(7)
}

private func testArrayLift2d() {
    let x = [3, 4, 5, 6]
    let y = [10, 20, 30]

    let result = lift2d { x, y in
        x+y
    }(x, y)

    print(result) // [[13, 23, 33], [14, 24, 34], [15, 25, 35], [16, 26, 36]]
}

private func testResultLift2d() {
    let x: Result<Int, Error> = .success(10)
    let y: Result<Int, Error> = .success(3)

    let result = lift2d { x, y in
        x+y
    }(x, y)

    print(result) // success(Swift.Result<Swift.Int, Swift.Error>.success(13))
}
