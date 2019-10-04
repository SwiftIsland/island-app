import XCTest
@testable import SwiftIsland

class UIViewExtensionsTests: XCTestCase {
  
  func testGetIsCircle_returnsTrue_onActualCircle() {
    let cornerRadius: CGFloat = 5
    let sut = UIView(frame: CGRect(x: 0, y: 0, width: cornerRadius * 2, height: cornerRadius * 2))
    sut.layer.cornerRadius = cornerRadius
    
    XCTAssertTrue(sut.isCircle)
  }
  
  func testGetIsCircle_returnsTrue_onRoundedRectangle() {
    let dimension: CGFloat = 10
    let cornerRadius: CGFloat = 2
    let sut = UIView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
    sut.layer.cornerRadius = cornerRadius
    
    XCTAssertFalse(sut.isCircle)
  }
  
  func testSetIsCircle_toTrue_setsCornerRadius_toHalfWidth() {
    let cornerRadius: CGFloat = 5
    let sut = UIView(frame: CGRect(x: 0, y: 0, width: cornerRadius * 2, height: cornerRadius * 2))
    sut.isCircle = true
    
    XCTAssertEqual(sut.layer.cornerRadius, cornerRadius)
  }

  func testSetIsCircle_toFalse_doesNothingToCornerRadius() {
    let cornerRadius: CGFloat = 2
    let sut = UIView(frame: CGRect(x: 0, y: 0, width: cornerRadius * 2, height: cornerRadius * 2))
    sut.layer.cornerRadius = cornerRadius
    sut.isCircle = false
    
    XCTAssertEqual(sut.layer.cornerRadius, cornerRadius)
  }
}
