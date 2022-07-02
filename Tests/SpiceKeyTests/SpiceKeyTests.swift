import XCTest
@testable import SpiceKey

final class SpiceKeyTests: XCTestCase {
    func testKeyCombination() {
        let spiceKey = SpiceKey(KeyCombination(.a, .cmd))
        XCTAssertNotNil(spiceKey.keyCombination)
        XCTAssertNil(spiceKey.modifierFlags)
    }

    func testBothSide() {
        let spiceKey = SpiceKey(ModifierFlag.control)
        XCTAssertNil(spiceKey.keyCombination)
        XCTAssertNotNil(spiceKey.modifierFlags)
    }

    func testLongPress() throws {
        let spiceKey = try XCTUnwrap(SpiceKey(ModifierFlags.ctrlOptCmd, 0.5))
        XCTAssertNil(spiceKey.keyCombination)
        XCTAssertNotNil(spiceKey.modifierFlags)
    }

    func testLoadImageResource() {
        let arrowImg = Bundle.module.image(forResource: "arrow")
        XCTAssertNotNil(arrowImg)

        let deleteImg = Bundle.module.image(forResource: "delete")
        XCTAssertNotNil(deleteImg)

        let deleteAltImg = Bundle.module.image(forResource: "delete_alt")
        XCTAssertNotNil(deleteAltImg)
    }
}
