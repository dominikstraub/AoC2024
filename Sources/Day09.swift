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
        for (index, block) in fileMap.enumerated() where block != nil {
            result += index * block!
        }
        return result
    }

    func sparsifyByFile(fileMap: [Int?]) -> [Int?] {
        var result = fileMap
        for fileId in (result[0]! + 1 ... result[result.count - 1]!).reversed() {
            if let newValue = sparsifyByFileStep(fileMap: result, fileId: fileId) {
                result = newValue
                // printFileMap(fileMap: result)
            }
        }
        return result
    }

    func sparsifyByFileStep(fileMap: [Int?], fileId: Int) -> [Int?]? {
        var result = fileMap
        var fileSize = 0
        var fileStart = -1
        for (index, block) in result.enumerated().reversed() where block == fileId {
            fileSize += 1
            fileStart = index
        }
        var space = 0
        var start = 0
        for (index, block) in result.enumerated() {
            if block == nil {
                space += 1
                if space >= fileSize, index < fileStart {
                    for fileIndex in 0 ..< fileSize {
                        result[start + fileIndex] = fileId
                    }
                    for deleteIndex in 0 ..< fileSize {
                        result[deleteIndex + fileStart] = nil
                    }
                    return result
                }
            } else {
                space = 0
                start = index + 1
            }
        }
        return nil
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

    func part2() -> Int {
        // print(diskMap)
        let fileMap = getFileMap(diskMap: diskMap)
        // printFileMap(fileMap: fileMap)
        let sparseFileMap = sparsifyByFile(fileMap: fileMap)
        // printFileMap(fileMap: sparseFileMap)
        let checksum = checksum(fileMap: sparseFileMap)
        // print(checksum)
        return checksum
    }
}
