import Algorithms

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: " ").compactMap { Int($0) }
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Int {
        return entities.compactMap { validateReport($0, true) }.count { $0 == true }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Int {
        return entities.compactMap { validateReport($0) }.count { $0 == true }
    }

    func validateReport(_ report: [Int], _ levelRemoved: Bool = false) -> Bool {
        var decreased = false
        var increased = false
        for index in 1 ..< report.count {
            if report[index - 1] < report[index] {
                if decreased {
                    if levelRemoved {
                        return false
                    } else {
                        return validateReport(Array(report.prefix(index - 1) + report.suffix(from: index)), true) ||
                            validateReport(Array(report.prefix(index) + report.suffix(from: index + 1)), true) ||
                            (index > 1 &&
                                validateReport(Array(report.prefix(index - 2) + report.suffix(from: index - 1)), true))
                    }
                } else {
                    increased = true
                }
            } else if report[index - 1] > report[index] {
                if increased {
                    if levelRemoved {
                        return false
                    } else {
                        return validateReport(Array(report.prefix(index - 1) + report.suffix(from: index)), true) ||
                            validateReport(Array(report.prefix(index) + report.suffix(from: index + 1)), true) ||
                            (index > 1 &&
                                validateReport(Array(report.prefix(index - 2) + report.suffix(from: index - 1)), true))
                    }
                } else {
                    decreased = true
                }
            }
            let diff = abs(report[index - 1] - report[index])
            if diff < 1 || diff > 3 {
                if levelRemoved {
                    return false
                } else {
                    return validateReport(Array(report.prefix(index - 1) + report.suffix(from: index)), true) ||
                        validateReport(Array(report.prefix(index) + report.suffix(from: index + 1)), true) ||
                        (index > 1 &&
                            validateReport(Array(report.prefix(index - 2) + report.suffix(from: index - 1)), true))
                }
            }
        }

        return true
    }
}
