import Foundation

//func isNewVersion(new: String?, old: String?) -> Bool {
//    guard let newVersionString = new,
//        let oldVersionString = old
//        else {
//            return false
//    }
//    let newVersionNumberArray = newVersionString.components(separatedBy: ".").map { Int($0) ?? 0 }
//    let oldVersionNumberArray = oldVersionString.components(separatedBy: ".").map { Int($0) ?? 0 }
//
//    let count = newVersionNumberArray.count > oldVersionNumberArray.count ? oldVersionNumberArray.count : newVersionNumberArray.count
//
//    for index in 0..<count {
//        let newNumber = newVersionNumberArray[index]
//        let oldNumber = oldVersionNumberArray[index]
//
//        if newNumber > oldNumber {
//            return true
//        } else if newNumber < oldNumber {
//            return false
//        } else {
//            continue
//        }
//    }
//
//    if newVersionNumberArray.count > oldVersionNumberArray.count {
//        return true
//    } else {
//        return false
//    }
//}
//
//let isNew = isNewVersion(new: "1.2", old: "1.1.10")

//class Person: NSObject {
//    let name: String
//    let age: Int
//
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
//}
//
//let person = Person(name: "abc", age: 12)
//var count: UInt32 = 0
//let ivarList = class_copyIvarList(person.classForCoder, &count)
//let ivarNameLast = (0..<count).compactMap { (ids) -> String? in
//    return ivarList.flatMap { (ivar) -> String? in
//        return ivar_getName(ivar.advanced(by: Int(ids)).pointee).map { String(cString: $0) }
//    }
//}
//print(ivarNameLast)

//for item in stride(from: 0, to: 21, by: 2) {
//    print(item)
//}

//for item in stride(from: 0, through: 20, by: 2) {
//    print(item)
//}

//let temp = (0, 9)
//switch temp {
//case (let x, let y) where x == y:
//    print("x: \(x)")
////    fallthrough
//default:
//    print("break")
//}

//let imageNames = ["like", "smile", "swing", "tick"]
//for _ in 0..<20 {
////    let index = Int.random(in: 0...3)
//    print(imageNames.randomElement() ?? "")
//}

//var numbers = [Int]()
//for _ in 0...10000 {
//    autoreleasepool {
//        numbers.append(Int.random(in: 0...10000))
//    }
//}
//import QuartzCore
//
//print(CACurrentMediaTime())
//numbers.sort(by: <)
//print(CACurrentMediaTime())

//struct Heap<T> {
//    var nodes = [T]()
//
//    public var isEmpty: Bool {
//        return nodes.isEmpty
//    }
//
//    public var count: Int {
//        return nodes.count
//    }
//
//    private var orderCriteria: (T, T) -> Bool
//
//    init(sort: @escaping (T, T) -> Bool) {
//        self.orderCriteria = sort
//    }
//
//    init(array: [T], sort: @escaping (T, T) -> Bool) {
//        self.orderCriteria = sort
//        configureHeap(from: array)
//    }
//
//    private mutating func configureHeap(from array: [T]) {
//        nodes = array
//        for i in stride(from: nodes.count / 2 - 1, to: 0, by: -1) {
//            shiftDown(i)
//        }
//    }
//
//    @inline(__always) internal func parentIndex(ofIndex i: Int) -> Int {
//        return (i - 1) / 2
//    }
//
//    @inline(__always) internal func leftChildIndex(ofIndex i: Int) -> Int {
//        return 2 * i + 1
//    }
//
//    @inline(__always) internal func rightChildIndex(ofIndex i: Int) -> Int {
//        return 2 * i + 2
//    }
//
//    func peek() -> T? {
//        return nodes.first
//    }
//
//    mutating func insert(_ value: T) {
//        nodes.append(value)
//        shiftUp(nodes.count - 1)
//    }
//
//    mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
//        sequence.forEach { insert($0) }
//    }
//
//    mutating func replace(index i: Int, value: T) {
//        guard i < nodes.count else {
//            return
//        }
//        insert(value)
//    }
//
//    @discardableResult
//    mutating func remove() -> T? {
//        guard !nodes.isEmpty else {
//            return nil
//        }
//
//        if nodes.count == 1 {
//            return nodes.removeLast()
//        } else {
//            let value = nodes[0]
//            nodes[0] = nodes.removeLast()
//            shiftDown(0)
//            return value
//        }
//    }
//
//    @discardableResult
//    mutating func remove(at index: Int) -> T? {
//        guard index < nodes.count else {
//            return nil
//        }
//
//        let size = nodes.count - 1
//        if index != size {
//            nodes.swapAt(index, size)
//            shiftDown(from: index, until: size)
//            shiftUp(index)
//        }
//        return nodes.removeLast()
//    }
//
//    internal mutating func shiftUp(_ index: Int) {
//        var childIndex = index
//        let child = nodes[childIndex]
//        var parentIndex = self.parentIndex(ofIndex: childIndex)
//
//        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
//            nodes[childIndex] = nodes[parentIndex]
//            childIndex = parentIndex
//            parentIndex = self.parentIndex(ofIndex: childIndex)
//        }
//
//        nodes[childIndex] = child
//    }
//
//    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
//        let leftChildIndex = self.leftChildIndex(ofIndex: index)
//        let rightChildIndex = leftChildIndex + 1
//
//        var first = index
//        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
//            first = leftChildIndex
//        }
//        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
//            first = rightChildIndex
//        }
//
//        if first == index {
//            return
//        }
//
//        nodes.swapAt(first, index)
//        shiftDown(from: first, until: endIndex)
//    }
//
//    internal mutating func shiftDown(_ index: Int) {
//        shiftDown(from: index, until: nodes.count)
//    }
//}
//
//extension Heap where T: Equatable {
//    func index(of node: T) -> Int? {
//        return nodes.firstIndex(where: { $0 == node })
//    }
//
//    @discardableResult
//    mutating func remove(node: T) -> T? {
//        if let index = index(of: node) {
//            return remove(at: index)
//        } else {
//            return nil
//        }
//    }
//}
//
//extension Heap {
//    mutating func sort() -> [T] {
//        for i in stride(from: nodes.count - 1, to: 1, by: -1) {
//            nodes.swapAt(0, i)
//            shiftDown(from: 0, until: i)
//        }
//        return nodes
//    }
//}
//
//func heapSort<T>(_ array: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
//    let reverseOrder = { sort($0, $1) }
//    var h = Heap(array: array, sort: reverseOrder)
//    return h.sort()
//}
//
//import QuartzCore
//
//var numbers = [Int]()
//for i in 0...10000 {
//    autoreleasepool {
//        numbers.append(i)
//    }
//}
//
//print(CACurrentMediaTime())
//print(heapSort(numbers, <))
//print(CACurrentMediaTime())

//let attr = """
//Hello
//"""

//var number = UInt8.max
//number &+ 1

//let number1 = Int8(clamping: 200)
//let number2 = Int8(clamping: -200)

//let u: UInt8 = 0b11110000
//Int8(truncatingIfNeeded: u)

//let lhs: Double = 0.1
//let rhs: Double = 0.2
//lhs + rhs
//lhs + rhs == 0.3

//Int8(exactly: 123)

//let formatter = NumberFormatter()
//formatter.numberStyle = .ordinal
//formatter.locale = Locale(identifier: "hi")
//formatter.string(for: 1)

//let price: Decimal = 300.00
//
//let formatter = NumberFormatter()
//formatter.numberStyle = .currency
//
//formatter.locale = Locale(identifier: "en-US")
//formatter.currencySymbol = "$"
//formatter.string(for: price)
//
//formatter.locale = Locale(identifier: "ja-JP")
//formatter.currencySymbol = "¥"
//formatter.string(for: price)

let formatter = NumberFormatter()
formatter.numberStyle = .decimal
formatter.positiveFormat = "#,###0.5"
formatter.locale = Locale(identifier: "en-US")
formatter.string(for: 5324241231234.567) // 1,234.5
formatter.locale = Locale(identifier: "fr-FR")
formatter.string(for: 5324241231234.567)
