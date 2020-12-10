import XCTest
@testable import SpiceKey

final class SpiceKeyTests: XCTestCase {
    func testExample() {
        let spiceKey = SpiceKey(KeyCombination(.a, .cmd))
        XCTAssertNotNil(spiceKey.keyCombination)
    }

    func testLoadImageResource() {
        let arrowImg = Bundle.module.image(forResource: "arrow")
        XCTAssertNotNil(arrowImg)

        let deleteImg = Bundle.module.image(forResource: "delete")
        XCTAssertNotNil(deleteImg)

        let deleteAltImg = Bundle.module.image(forResource: "delete_alt")
        XCTAssertNotNil(deleteAltImg)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
