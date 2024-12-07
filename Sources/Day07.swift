import Algorithms
import Foundation

typealias Equation = (Int, [Int])
typealias Operator = (Int, Int) -> Int

struct Day07: AdventDay {
    var data: String

    var equations: [Equation] {
        data.split(separator: "\n").compactMap { line in
            let numbers = String(line).components(separatedBy: CharacterSet(charactersIn: ": ")).compactMap { Int($0) }
            return (numbers[0], Array(numbers[1...]))
        }
    }

    func checkEquation(_ equation: Equation) -> Bool {
        let operatorsVariations = getOperatorsVariation(length: equation.1.count - 1)
        for operators in operatorsVariations
            where checkEquation(equation, withOperators: operators)
        {
            return true
        }
        return false
    }

    func getOperatorsVariation(length: Int) -> [[Operator]] {
        let operators: [Operator] = [(+), (*)]
        return variations(operators, length: length)
    }

    func variations(_ operators: [Operator], length: Int) -> [[Operator]] {
        guard !operators.isEmpty && length > 0 else { return [] }

        if length == 1 {
            return operators.map { [$0] }
        }

        var result = [[Operator]]()
        let subVariations = variations(operators, length: length - 1)
        for operatorVal in operators {
            result += subVariations.map { [operatorVal] + $0 }
        }

        return result
    }

    func checkEquation(_ equation: Equation, withOperators operators: [Operator]) -> Bool {
        var result = equation.1[0]
        for index in 0 ..< operators.count {
            result = operators[index](result, equation.1[index + 1])
        }
        return equation.0 == result
    }

    func part1() -> Int {
        var result = 0
        for equation in equations where checkEquation(equation) {
            result += equation.0
        }
        return result
    }

    func part2() -> Any {
        return 0
    }
}