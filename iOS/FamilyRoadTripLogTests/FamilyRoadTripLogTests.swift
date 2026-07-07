import XCTest
@testable import FamilyRoadTripLog

@MainActor
final class FamilyRoadTripLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testAddItem() {
        let item = Stop(placeName: "Test", note: "Note")
        store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddInsertsAtFront() {
        store.add(Stop(placeName: "First", note: ""))
        store.add(Stop(placeName: "Second", note: ""))
        XCTAssertEqual(store.items.first?.placeName, "Second")
    }

    func testDeleteItem() {
        let item = Stop(placeName: "ToDelete", note: "")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testDeleteAtOffsets() {
        store.add(Stop(placeName: "A", note: ""))
        store.add(Stop(placeName: "B", note: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitAllowsAdding() {
        for i in 0..<Store.freeLimit {
            store.add(Stop(placeName: "Item \(i)", note: ""))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.add(Stop(placeName: "One", note: ""))
        XCTAssertTrue(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Stop(placeName: "Item \(i)", note: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateItem() {
        var item = Stop(placeName: "Original", note: "")
        store.add(item)
        item.placeName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.placeName, "Updated")
    }
}
