import Algorithms

struct Day01: AdventDay {
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: "   ").compactMap { Int($0) }
        }
    }

    func part1() -> Int {
        let firstList = (entities.compactMap { $0.first }).sorted(by: <)
        let secondList = (entities.compactMap { $0[1] }).sorted(by: <)
        var distance = 0
        for index in 0 ..< firstList.count {
            distance += abs(firstList[index] - secondList[index])
        }
        return distance
    }

    func part2() -> Int {
        let firstList = (entities.compactMap { $0.first })
        let secondList = (entities.compactMap { $0[1] })
        return firstList.reduce(0) { currentFirst, number in
            let count = secondList.reduce(0) { current, otherNumber in number == otherNumber ? current + 1 : current }
            return currentFirst + number * count
        }
    }
}
