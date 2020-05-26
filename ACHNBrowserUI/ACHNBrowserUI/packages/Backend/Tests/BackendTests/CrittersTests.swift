import XCTest
@testable import Backend

final class CrittersTests: XCTestCase {
    
    let json = """
            {"total":80,"results":[{"name":"Anchovy","image":"https://i.imgur.com/zEICzZj.png","house":"https://storage.googleapis.com/acdb/fish/FtrFishAntyobi.png","sell":200,"shadow":"Small","rarity":"Common","size":{"rows":1.0,"cols":1.0},"lightingType":null,"critterpediaFilename":"","itemFilename":"FtrFishAntyobi","internalID":4201,"category":"Fish - North","colors":["Blue","Red"],"obtainedFrom":"Sea","increasedWeatherChance":"No","activeMonthsNorth":[1,2,3,4,5,6,7,8,9,10,11],"activeTimes":[{"startTime":4.0,"endTime":21.0}],"activeMonthsSouth":[1,2,3,4,5,6,7,8,9,10,11]}]}
            """
    
    func testCrittersDecodable() {
        let decoder = JSONDecoder()
        let critters = try! decoder.decode(ItemResponse.self, from: json.data(using: .utf8)!)
        XCTAssertTrue(critters.total == 80, "ItemResponse not decoded properly")
        XCTAssertTrue(critters.results.count == 1, "Items array not decoded properly")
        XCTAssertTrue(critters.results.first?.name == "Anchovy", "Item object not decoded properly")
    }
    
    func testCritterObject() {
        let decoder = JSONDecoder()
        let critters = try! decoder.decode(ItemResponse.self, from: json.data(using: .utf8)!)
        let fish = critters.results.first!
        
        XCTAssertTrue(fish.isCritter, "This item should be a critter")
        XCTAssertTrue(fish.isActive(), "This fish should be active all year")
        XCTAssertTrue(fish.appCategory == .fish, "This item should be a fish")
        XCTAssertTrue(fish.formattedTimes() == "4AM - 9PM", "This fish should display all day")
    }
    
}
