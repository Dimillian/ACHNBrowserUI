import XCTest
@testable import Backend

final class CrittersTests: XCTestCase {
    
    let json = """
            {"total":80,"results":[{
            "id": 25932,
            "name": "Anchovy",
            "category": "Fish",
            "content": {
                "name": "Anchovy",
                "sell": 200,
                "size": {
                    "cols": 1,
                    "rows": 1
                },
                "image": "https://acnhcdn.com/latest/BookFishIcon/FishAntyobiCropped.png",
                "colors": [
                    "Blue",
                    "Red"
                ],
                "shadow": "Small",
                "category": "Fish",
                "critterId": 56,
                "iconImage": "https://acnhcdn.com/latest/MenuIcon/Fish81.png",
                "internalID": 4201,
                "spawnRates": "2–5",
                "activeMonths": {
                    "0": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "1": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "2": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "3": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "4": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "5": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "6": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "7": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "8": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "9": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "10": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    },
                    "11": {
                        "activeTimes": [
                            "4am",
                            "9pm"
                        ]
                    }
                },
                "iconFilename": "Fish81",
                "obtainedFrom": "Sea",
                "uniqueEntryID": "LzuWkSQP55uEpRCP5",
                "furnitureImage": "https://acnhcdn.com/latest/FtrIcon/FtrFishAntyobi.png",
                "catchUnlockCount": 0,
                "furnitureFilename": "FtrFishAntyobi",
                "critterpediaFilename": "FishAntyobi",
                "increasedWeatherChance": false
            },
            "variations": []
            }]}
            """
    
    func testCrittersDecodable() {
        let decoder = JSONDecoder()
        let critters = try! decoder.decode(NewItemResponse.self, from: json.data(using: .utf8)!)
        XCTAssertTrue(critters.total == 80, "ItemResponse not decoded properly")
        XCTAssertTrue(critters.results.count == 1, "Items array not decoded properly")
        XCTAssertTrue(critters.results.first?.name == "Anchovy", "Item object not decoded properly")
    }
    
    func testCritterObject() {
        let decoder = JSONDecoder()
        let critters = try! decoder.decode(NewItemResponse.self, from: json.data(using: .utf8)!)
        let fish = critters.results.first!.content
        
        XCTAssertTrue(fish.isCritter, "This item should be a critter")
        XCTAssertTrue(fish.isActiveThisMonth(currentDate: Date()), "This fish should be active all year")
        XCTAssertTrue(fish.activeMonthsCalendar?.count == 12, "This fish should be active all year")
        XCTAssertTrue(fish.appCategory == .fish, "This item should be a fish")
        XCTAssertTrue(fish.formattedTimes() == "4AM - 9PM", "This fish should display all day")
        XCTAssertTrue(fish.activeMonths?.values.first?.activeTimes.first == "4am", "Raw data should be 4 am")
    }
    
}
