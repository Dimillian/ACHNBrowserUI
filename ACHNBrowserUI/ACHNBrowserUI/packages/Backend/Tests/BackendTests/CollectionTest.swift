import XCTest
@testable import Backend

final class CollectionTests: XCTestCase {
    let collection = UserCollection(iCloudDisabled: true)
    
    func testUserCollectionToggleItem() {
        _ = collection.toggleItem(item: static_item)
        XCTAssert(collection.items.count == 1, "items should have one item")
        
        _ = collection.toggleItem(item: static_item)
        XCTAssert(collection.items.isEmpty, "items should be empty")
    }
    
    func testUserCollectionToggleCritters() {
        _ = collection.toggleCritters(critter: static_item)
        XCTAssert(collection.critters.count == 1, "critters should have one item")
        
        _ = collection.toggleCritters(critter: static_item)
        XCTAssert(collection.critters.isEmpty, "critters should be empty")
    }
    
    func testUserCollectionToggleVillager() {
        _ = collection.toggleVillager(villager: static_villager)
        XCTAssert(collection.villagers.count == 1, "villagers should have one item")
        
        _ = collection.toggleVillager(villager: static_villager)
        XCTAssert(collection.villagers.isEmpty, "villagers should be empty")
    }
}
