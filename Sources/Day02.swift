import Algorithms

struct Day02: AdventDay {
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: " ").compactMap { Int($0) }
        }
    }

    func part1() -> Int {
        return entities.compactMap { validateReport($0) }.count { $0 == true }
    }

    func part2() -> Int {
        return entities.compactMap { validateReport($0, 1) }.count { $0 == true }
    }

    func validateReport(_ report: [Int], _ levelsToTolerate: Int = 0) -> Bool {
        var decreased = false
        var increased = false
        for index in 1 ..< report.count {
            if report[index - 1] < report[index] {
                if decreased {
                    return validateReportVariations(report, index, levelsToTolerate)
                } else {
                    increased = true
                }
            } else if report[index - 1] > report[index] {
                if increased {
                    return validateReportVariations(report, index, levelsToTolerate)
                } else {
                    decreased = true
                }
            }
            let diff = abs(report[index - 1] - report[index])
            if diff < 1 || diff > 3 {
                return validateReportVariations(report, index, levelsToTolerate)
            }
        }

        return true
    }

    func validateReportVariations(_ report: [Int], _ index: Int, _ levelsToTolerate: Int = 0) -> Bool {
        if levelsToTolerate <= 0 {
            return false
        } else {
            return validateReport(Array(report.prefix(index - 1) +
                    report.suffix(from: index)), levelsToTolerate - 1) ||
                validateReport(Array(report.prefix(index) +
                        report.suffix(from: index + 1)), levelsToTolerate - 1) ||
                (index > 1 &&
                    validateReport(Array(report.prefix(index - 2) +
                            report.suffix(from: index - 1)), levelsToTolerate - 1))
        }
    }
}
