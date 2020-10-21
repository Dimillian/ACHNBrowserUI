import XCTest
import Combine
@testable import Backend

final class ItemsTests: XCTestCase {
    let json = """
                {"total":173,"results":[{"name":"Aqua tile flooring","image":"https://storage.googleapis.com/acdb/floors/RoomTexFloorTile01.png","vFX":false,"dIY":false,"buy":3000,"sell":225,"sourceNotes":"","version":"1.0.0","tag":"Tile Floors","catalog":true,"filename":"RoomTexFloorTile01","internalID":5036,"category":"Floors","themes":["bathroom","facility"],"colors":["Light blue","Light blue"],"set":"None","obtainedFrom":"Nook's Cranny","reorder":true},{"name":"Arabesque flooring","image":"https://storage.googleapis.com/acdb/floors/RoomTexFloorArabesque00.png","vFX":false,"dIY":false,"buy":2120,"sell":530,"sourceNotes":"","version":"1.0.0","tag":"Cloth Floors","catalog":true,"filename":"RoomTexFloorArabesque00","internalID":4953,"category":"Floors","themes":["expensive","living room"],"colors":["Black","Gray"],"set":"None","obtainedFrom":"Nook's Cranny","reorder":true}]}
                """
    
    func testItemsDecodable() {
        let decoder = JSONDecoder()
        let items = try! decoder.decode(ItemResponse.self, from: json.data(using: .utf8)!)
        XCTAssertTrue(items.total == 173, "ItemResponse not decoded properly")
        XCTAssertTrue(items.results.count == 2, "Items array not decoded properly")
        XCTAssertTrue(items.results.first?.name == "Aqua tile flooring", "Item object not decoded properly")
    }
}

