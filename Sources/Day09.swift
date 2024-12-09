import Algorithms
import Foundation

struct Day09: AdventDay {
    var data: String

    var diskMap: [Int] {
        data.compactMap { Int($0) }
    }

    func getFileMap(diskMap: [Int]) -> [Int?] {
        var result: [Int?] = []
        var isFile = true
        for (index, length) in diskMap.enumerated() {
            for _ in 0 ..< length {
                result.append(isFile ? index / 2 : nil)
            }
            isFile = !isFile
        }
        return result
    }

    func printFileMap(fileMap: [Int?]) {
        for block in fileMap {
            if let block {
                print(block, terminator: "")
            } else {
                print(".", terminator: "")
            }
        }
        print("")
    }

    func sparsify(fileMap: [Int?]) -> [Int?] {
        var result = fileMap
        while true {
            if let newValue = sparsifyStep(fileMap: result) {
                result = newValue
                // printFileMap(fileMap: result)
            } else {
                break
            }
        }
        return result
    }

    func sparsifyStep(fileMap: [Int?]) -> [Int?]? {
        var result = fileMap
        for (index, block) in result.enumerated() where block == nil {
            result[index] = result[result.count - 1]
            result.removeLast()
            return result
        }
        return nil
    }

    func checksum(fileMap: [Int?]) -> Int {
        var result = 0
        for (index, block) in fileMap.enumerated() {
            result += index * block!
        }
        return result
    }

    func part1() -> Int {
        // print(diskMap)
        let fileMap = getFileMap(diskMap: diskMap)
        // printFileMap(fileMap: fileMap)
        let sparseFileMap = sparsify(fileMap: fileMap)
        // printFileMap(fileMap: sparseFileMap)
        let checksum = checksum(fileMap: sparseFileMap)
        // print(checksum)
        return checksum
    }

    func part2() -> Any {
        return -1
    }
}
