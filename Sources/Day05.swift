import Algorithms
import Foundation

struct Day05: AdventDay {
    var data: String

    var parts: [String] {
        data.split(separator: "\n\n").compactMap { String($0) }
    }

    var rules: [[Int]] {
        parts[0].split(separator: "\n").compactMap { $0.split(separator: "|").compactMap { Int($0) } }
    }

    var ruleTree: [Int: [Int]] {
        var tree: [Int: [Int]] = [:]
        for rule in rules {
            if tree[rule[1]] == nil {
                tree[rule[1]] = []
            }
            tree[rule[1]]!.append(rule[0])
        }
        return tree
    }

    var updates: [[Int]] {
        parts[1].split(separator: "\n").compactMap { $0.split(separator: ",").compactMap { Int($0) } }
    }

    func part1() -> Int {
        var sum = 0
        for update in updates where checkUpdate(update: update) {
            sum += getMiddlePage(update: update)
        }
        return sum
    }

    func checkUpdate(update: [Int]) -> Bool {
        var blocked: [Int] = []
        for page in update {
            if blocked.contains(page) {
                return false
            } else {
                let newBlocked = ruleTree[page]
                if let newBlocked {
                    blocked.append(contentsOf: newBlocked)
                }
            }
        }
        return true
    }

    func getMiddlePage(update: [Int]) -> Int {
        return update[update.count / 2]
    }

    func part2() -> Int {
        var sum = 0
        for update in updates where !checkUpdate(update: update) {
            let sortedUpdate = update.sorted(by: { lhs, rhs in
                if let blocked = ruleTree[lhs], blocked.contains(rhs) {
                    return true
                }
                return false
            })
            sum += getMiddlePage(update: sortedUpdate)
        }
        return sum
    }
}
