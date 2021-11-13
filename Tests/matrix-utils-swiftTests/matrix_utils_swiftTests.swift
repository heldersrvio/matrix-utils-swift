import XCTest
@testable import matrix_utils_swift

final class matrix_utils_swiftTests: XCTestCase {
    func testEnumerated() throws {
        let m1: Matrix = [
            [8.0, 5.0],
            [4.0, 8.0],
        ]
        let enumeratedM1: EnumeratedMatrix = [
            ((0, 0), 8.0),
            ((0, 1), 5.0),
            ((1, 0), 4.0),
            ((1, 1), 8.0),
        ]
        XCTAssertEqual(m1.enumerated().map { $0.0.0 }, enumeratedM1.map { $0.0.0 })
        XCTAssertEqual(m1.enumerated().map { $0.0.1 }, enumeratedM1.map { $0.0.1 })
    }
    
    func testTransposed() throws {
        let m1: Matrix = [
            [1.0, 2.0, 3.0],
            [0.0, -6.0, 7.0],
        ]
        let transposedM1: Matrix = [
            [1.0, 0.0],
            [2.0, -6.0],
            [3.0, 7.0],
        ]
        XCTAssertEqual(m1.transposed(), transposedM1)
    }
    
    func testBasicOperations() throws {
        let m1: Matrix = [
            [2.0, 3.0, 4.0],
            [1.0, 0.0, 0.0],
        ]
        let m2: Matrix = [
            [0.0, 0.0, 5.0],
            [7.0, 5.0, 0.0],
        ]
        let m3: Matrix = [
            [0.0, 1000.0],
            [1.0, 100.0],
            [0.0, 10.0],
        ]
        let sumOfM1AndM2 = [
            [2.0, 3.0, 9.0],
            [8.0, 5.0, 0.0],
        ]
        let subtractionOfM1ByM2 = [
            [2.0, 3.0, -1.0],
            [-6.0, -5.0, 0.0],
        ]
        let productOfM1AndM3 = [
            [3.0, 2340.0],
            [0.0, 1000.0],
        ]
        XCTAssertEqual(m1 + m2, sumOfM1AndM2)
        XCTAssertEqual(m1 - m2, subtractionOfM1ByM2)
        XCTAssertEqual(m1 * m3, productOfM1AndM3)
    }
    
    func testIdentity() throws {
        let identity2x2 = [
            [1.0, 0.0],
            [0.0, 1.0],
        ]
        let identity3x3 = [
            [1.0, 0.0, 0.0],
            [0.0, 1.0, 0.0],
            [0.0, 0.0, 1.0],
        ]
        let identity4x4 = [
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [0.0, 0.0, 0.0, 1.0],
        ]
        XCTAssertEqual(Matrix.makeIdentity(ofSize: 2), identity2x2)
        XCTAssertEqual(Matrix.makeIdentity(ofSize: 3), identity3x3)
        XCTAssertEqual(Matrix.makeIdentity(ofSize: 4), identity4x4)
    }
}
