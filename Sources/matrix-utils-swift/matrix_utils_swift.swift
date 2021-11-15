public typealias MatrixIndex = (Int, Int)
public typealias MatrixSize = (Int, Int)
public typealias EnumeratedMatrix = [(MatrixIndex, Double)]
public typealias Matrix = [[Double]]

public extension Matrix {
    var isSquare: Bool {
        return self.allSatisfy { $0.count == self.count }
    }
    
    var isZero: Bool {
        return self.allSatisfy { row in row.allSatisfy { $0 == 0.0 } }
    }
    
    var isColumn: Bool {
        return self.allSatisfy { $0.count == 1 }
    }
    
    var isRow: Bool {
        return self.count == 1
    }
    
    var isIdentity: Bool {
        return self == Matrix.makeIdentity(ofSize: self.count)
    }
    
    var isUpperTriangular: Bool {
        return self.isSquare && self.enumerated().allSatisfy { indexValuePair in
            let rowIndex = indexValuePair.0.0
            let columnIndex = indexValuePair.0.1
            let value = indexValuePair.1
            
            return rowIndex <= columnIndex || value == 0.0
        }
    }
    
    var isLowerTriangular: Bool {
        return self.isSquare && self.enumerated().allSatisfy { indexValuePair in
            let rowIndex = indexValuePair.0.0
            let columnIndex = indexValuePair.0.1
            let value = indexValuePair.1
            
            return rowIndex >= columnIndex || value == 0.0
        }
    }
    
    var isTriangular: Bool {
        return self.isUpperTriangular || self.isLowerTriangular
    }
    
    var isDiagonal: Bool {
        return self.isUpperTriangular && self.isLowerTriangular
    }
    
    var isSymmetric: Bool {
        return self.isSquare && self.enumerated().allSatisfy { indexValuePair in
            let rowIndex = indexValuePair.0.0
            let columnIndex = indexValuePair.0.1
            let value = indexValuePair.1
            
            return rowIndex != columnIndex || value == self[columnIndex][rowIndex]
        }
    }
    
    func enumerated() -> [(MatrixIndex, Double)] {
        guard let columnCount = self.first?.count else {
            return []
        }
        return [Int](0..<self.count).map { rowIndex in
            [Int](0..<columnCount).map { columnIndex in
                ((rowIndex, columnIndex), self[rowIndex][columnIndex])
            }
        }.reduce([], +)
    }
    
   func transposed() -> Matrix {
       let size = (self.count, self.first!.count)
       return [Int](0..<size.1).map { columnIndex in
           [Int](0..<size.0).map { rowIndex in
               self[rowIndex][columnIndex]
           }
       }
    }
    
    private static func seek(_ element: MatrixIndex, at enumeratedMatrix: EnumeratedMatrix) -> Double {
        return enumeratedMatrix.filter { $0.0 == element }.map { $1 }.first!
    }
    
    private static func getMatrixSize(of enumeratedMatrix: EnumeratedMatrix) -> MatrixSize {
        let maxIndices = enumeratedMatrix.reduce((0, 0)) { previous, current in
            let maxRowIndex = current.0.0 > previous.0 ? current.0.0 : previous.0
            let maxColumnIndex = current.0.1 > previous.1 ? current.0.1 : previous.1
            return (maxRowIndex, maxColumnIndex)
        }
        return (maxIndices.0 + 1, maxIndices.1 + 1)
    }
    
    private static func applyElementToElement(_ operation: ((Double, Double) -> Double), from m1: Matrix, to m2: Matrix) -> Matrix {
        let enumeratedResult = m1.enumerated().map { index, element in
            (index, operation(element, m2[index.0][index.1]))
        }
        return buildMatrix(from: enumeratedResult)
    }
    
    static func buildMatrix(from enumeratedMatrix: EnumeratedMatrix) -> Matrix {
        let matrixSize = getMatrixSize(of: enumeratedMatrix)
        return [Int](0..<matrixSize.0).map { rowIndex in
            [Int](0..<matrixSize.1).map { columnIndex in
                seek((rowIndex, columnIndex), at: enumeratedMatrix)
            }
        }
    }
    
    static func ==(_ m1: Matrix, _ m2: Matrix) -> Bool {
        let enumeratedM1 = m1.enumerated()
        let enumeratedM2 = m2.enumerated()
        return enumeratedM1.allSatisfy {
            seek($0.0, at: enumeratedM2) == $0.1
        }
    }
    
    static func !=(_ m1: Matrix, _ m2: Matrix) -> Bool {
        return !(m1 == m2)
    }
    
    static func +(_ m1: Matrix, _ m2: Matrix) -> Matrix {
        return applyElementToElement(+, from: m1, to: m2)
    }
    
    static func -(_ m1: Matrix, _ m2: Matrix) -> Matrix {
        return applyElementToElement(-, from: m1, to: m2)
    }
    
    static func *(_ n: Double, _ matrix: Matrix) -> Matrix {
        return matrix.map { row in row.map { n * $0 } }
    }
    
    static func *(_ m1: Matrix, _ m2: Matrix) -> Matrix {
        let m1Size = (m1.count, m1.first!.count)
        let m2Size = (m2.count, m2.first!.count)
        return [Int](0..<m1Size.0).map { rowIndex in
            [Int](0..<m2Size.1).map { columnIndex in
                [Int](0..<m2Size.0).reduce(0) { previousValue, increment in
                    previousValue + m1[rowIndex][increment] * m2[increment][columnIndex]
                }
            }
        }
    }
    
    static func makeIdentity(ofSize size: Int) -> Matrix {
        return [Int](0..<size).map { rowIndex in
            [Int](0..<size).map { columnIndex in
                rowIndex == columnIndex ? 1 : 0
            }
        }
    }
}
