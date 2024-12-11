import Algorithms
import Foundation

@MainActor var stoneCache: [Point: Int] = [:]

struct Day11: AdventDay {
    init(data: String) {
        self.data = data
    }

    var data: String

    var stones: [Int] {
        data.components(separatedBy: .whitespacesAndNewlines).compactMap { Int($0) }
    }

    func blink(_ stones: [Int]) -> [Int] {
        // If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
        // If the stone is engraved with a number that has an even number of digits, it is replaced by two stones. The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
        // If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone.
        var result = stones
        for (index, stone) in stones.enumerated().reversed() {
            if stone == 0 {
                result[index] = 1
                continue
            }
            let stoneString = "\(stone)"
            if stoneString.count % 2 == 0 {
                result[index] = Int(stoneString[0 ..< stoneString.count / 2])!
                result.insert(Int(stoneString[(stoneString.count / 2)...])!, at: index + 1)
                continue
            }
            result[index] = stone * 2024
        }
        return result
    }

    func blinkSingle(_ stone: Int) -> [Int] {
        if stone == 0 {
            return [1]
        }
        let stoneString = "\(stone)"
        if stoneString.count % 2 == 0 {
            return [Int(stoneString[0 ..< stoneString.count / 2])!,
                    Int(stoneString[(stoneString.count / 2)...])!]
        }
        return [stone * 2024]
    }

    func part1() -> Int {
        print(stones)

        var result = stones
        for _ in 0 ..< 25 {
            result = blink(result)
        }

        return result.count
    }

    func getNumberOfStones(_ stones: [Int], _ blinksLeft: Int) -> Int {
        var sum = 0
        if blinksLeft == 0 {
            return stones.count
        }
        for stone in stones {
            sum += getNumberOfStones(blinkSingle(stone), blinksLeft - 1)
        }
        return sum
    }

    @MainActor func getNumberOfStonesWithCache(_ stones: [Int], _ blinksLeft: Int) -> Int {
        var sum = 0
        if blinksLeft == 0 {
            return stones.count
        }
        for stone in stones {
            if let result = stoneCache[Point(stone, blinksLeft)] {
                sum += result
            } else {
                let result = getNumberOfStonesWithCache(blinkSingle(stone), blinksLeft - 1)
                stoneCache[Point(stone, blinksLeft)] = result
                sum += result
            }
        }
        return sum
    }

    func getNumberOfStonesMultiThreaded(_ stones: [Int], _ blinksLeft: Int) async -> Int {
        var sum = 0
        if blinksLeft == 0 {
            return stones.count
        }

        await withTaskGroup(of: Int.self) { group in
            for stone in stones {
                group.addTask {
                    await getNumberOfStonesMultiThreaded(blinkSingle(stone), blinksLeft - 1)
                }
            }

            for await result in group {
                sum += result
            }
        }

        return sum
    }

    func part2() async -> Int {
        return await getNumberOfStonesWithCache(stones, 75)
    }
}
