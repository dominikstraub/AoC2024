import Algorithms
import Foundation

@MainActor private var possibleDesignParts: Set<String> = []
@MainActor private var notPossibleDesignParts: Set<String> = []

@MainActor struct Day19: AdventDay {
    nonisolated init(data: String) {
        self.data = data
    }

    var data: String

    func getValues() -> (towels: [String], designs: [String]) {
        let parts = data.split(separator: "\n\n")
        let towels = parts[0].split(separator: ", ").compactMap { String($0) }
        let designs = parts[1].split(separator: "\n").compactMap { String($0) }
        return (towels: towels, designs: designs)
    }

    func checkDesign(_ design: String, towels: [String]) -> Bool {
        // print(design)
        // print(towels)
        if possibleDesignParts.contains(design) {
            // print("found part: \(design)")
            return true
        }
        if notPossibleDesignParts.contains(design) {
            return false
        }
        if design.count > 1 {
            for length in (1 ..< design.count - 1).reversed() {
                let designPart = String(design[0 ... length])
                if possibleDesignParts.contains(designPart) {
                    if checkDesign(String(design[(length + 1)...]), towels: towels) {
                        possibleDesignParts.insert(design)
                        return true
                    }
                }
            }
        }
        for towel in towels where design[0 ..< towel.count] == towel {
            // print("first part matching: \(towel)")
            if design.count == towel.count {
                possibleDesignParts.insert(design)
                // print("found part: \(design)")
                return true
            } else if checkDesign(String(design[towel.count...]), towels: towels) {
                possibleDesignParts.insert(design)
                // print("found part: \(design)")
                return true
            }
        }
        // print("NOPE: \(design)")
        notPossibleDesignParts.insert(design)
        return false
    }

    func part1() -> Int {
        let values = getValues()
        // print(values)
        var count = 0
        for design in values.designs {
            print(design)
            if checkDesign(design, towels: values.towels) {
                print("possible")
                count += 1
            } else {
                print("NOT possible")
            }
        }
        return count
    }

    func part2() -> Int {
        return -1
    }
}
