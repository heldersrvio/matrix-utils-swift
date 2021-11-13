typealias MatrixIndex = (Int, Int)
typealias MatrixSize = (Int, Int)
typealias EnumeratedMatrix = [(MatrixIndex, Double)]
typealias Matrix = [[Double]]

extension Matrix {
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
    
    private static func buildMatrix(from enumeratedMatrix: EnumeratedMatrix) -> Matrix {
        let matrixSize = getMatrixSize(of: enumeratedMatrix)
        return [Int](0..<matrixSize.0).map { rowIndex in
            [Int](0..<matrixSize.1).map { columnIndex in
                seek((rowIndex, columnIndex), at: enumeratedMatrix)
            }
        }
    }
    
    private static func applyElementToElement(_ operation: ((Double, Double) -> Double), from m1: Matrix, to m2: Matrix) -> Matrix {
        let enumeratedResult = m1.enumerated().map { index, element in
            (index, operation(element, m2[index.0][index.1]))
        }
        return buildMatrix(from: enumeratedResult)
    }
    
    static func +(_ m1: Matrix, _ m2: Matrix) -> Matrix {
        return applyElementToElement(+, from: m1, to: m2)
    }
    
    static func -(_ m1: Matrix, _ m2: Matrix) -> Matrix {
        return applyElementToElement(-, from: m1, to: m2)
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
