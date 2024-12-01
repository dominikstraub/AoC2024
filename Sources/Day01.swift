import Algorithms

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: "   ").compactMap { Int($0) }
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Int {
        let firstList = (entities.compactMap { $0.first }).sorted(by: <)
        let secondList = (entities.compactMap { $0[1] }).sorted(by: <)
        var distance = 0
        for i in 0 ..< firstList.count {
            distance += abs(firstList[i] - secondList[i])
        }
        return distance
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Int {
        let firstList = (entities.compactMap { $0.first })
        let secondList = (entities.compactMap { $0[1] })
        return firstList.reduce(0) { currentFirst, number in
            let count = secondList.reduce(0) { current, otherNumber in number == otherNumber ? current + 1 : current }
            return currentFirst + number * count
        }
    }
}
