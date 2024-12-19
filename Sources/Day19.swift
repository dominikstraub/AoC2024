import Algorithms
import Foundation

@MainActor private var possibleDesignParts: Set<String> = []
@MainActor private var possibleDesignPartsCount: [String: Int] = [:]
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
        // if design.count > 1 {
        //     for length in (1 ..< design.count - 1).reversed() {
        //         let designPart = String(design[0 ... length])
        //         if possibleDesignParts.contains(designPart) {
        //             if checkDesign(String(design[(length + 1)...]), towels: towels) {
        //                 possibleDesignParts.insert(design)
        //                 return true
        //             }
        //         }
        //     }
        // }
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

    func countDesign(_ design: String, towels: [String]) -> Int {
        // print(design)
        // print(towels)
        if let count = possibleDesignPartsCount[design] {
            // print("found part: \(design)")
            return count
        }
        if notPossibleDesignParts.contains(design) {
            return 0
        }
        // if design.count > 1 {
        //     for length in (1 ..< design.count - 1).reversed() {
        //         let designPart = String(design[0 ... length])
        //         if let _ = possibleDesignPartsCount[designPart] {
        //             let count = countDesign(String(design[(length + 1)...]), towels: towels)
        //             if count > 0 {
        //                 possibleDesignPartsCount[design] = count
        //                 return count
        //             }
        //         }
        //     }
        // }
        var result = 0
        for towel in towels where design[0 ..< towel.count] == towel {
            // print("first part matching: \(towel)")
            if design.count == towel.count {
                // print("found part: \(design)")
                result += 1
            } else {
                let count = countDesign(String(design[towel.count...]), towels: towels)
                if count > 0 {
                    // print("found part: \(design)")
                    result += count
                }
            }
        }
        // print("NOPE: \(design)")
        if result == 0 {
            notPossibleDesignParts.insert(design)
        } else {
            possibleDesignPartsCount[design] = result
        }
        return result
    }

    func part1() -> Int {
        let values = getValues()
        // print(values)
        var result = 0
        for design in values.designs {
            print(design)
            if checkDesign(design, towels: values.towels) {
                print("possible")
                result += 1
            } else {
                print("NOT possible")
            }
        }
        return result
    }

    func part2() -> Int {
        let values = getValues()
        // print(values)
        var result = 0
        for design in values.designs {
            let count = countDesign(design, towels: values.towels)
            print(count)
            result += count
        }
        return result
    }
}
