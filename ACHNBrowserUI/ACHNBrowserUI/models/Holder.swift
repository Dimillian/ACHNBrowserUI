import Foundation

// MARK: - Items
public struct ItemsHolder: Codable {
    public let total: Int
    public let results: [ResultT]
    
    enum CodingKeys: String, CodingKey {
        case total
        case results
    }
}

// MARK: - Result
public struct ResultT: Codable {
    public let id: Int
    public let name: String
    public let category: Category
    public let content: ResultContent
    public let createdAt: String? // TODO
    public let updatedAt: Date?
    public let variations: [Variation]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case content
        case createdAt
        case updatedAt
        case variations
    }
}

public enum Category: String, CaseIterable, Codable {
    case accessories = "Accessories"
    case bags = "Bags"
    case bottoms = "Bottoms"
    case bugs = "Bugs"
    case construction = "Construction"
    case dresses = "Dresses"
    case fencing = "Fencing"
    case fish = "Fish"
    case floors = "Floors"
    case fossils = "Fossils"
    case headwear = "Headwear"
    case housewares = "Housewares"
    case miscellaneous = "Miscellaneous"
    case music = "Music"
    case nookMiles = "Nook Miles"
    case other = "Other"
    case photos = "Photos"
    case posters = "Posters"
    case recipes = "Recipes"
    case rugs = "Rugs"
    case shoes = "Shoes"
    case socks = "Socks"
    case tools = "Tools"
    case tops = "Tops"
    case umbrellas = "Umbrellas"
    case villagers = "Villagers"
    case wallMounted = "Wall-mounted"
    case wallpapers = "Wallpapers"
}

// MARK: - ResultContent
public struct ResultContent: Codable {
    public let buy: Int?
    public let dIy: Bool?
    public let contentSet: ItemSet?
    public let tag: String?
    public let name: String
    public let sell: Int?
    public let size: Size?
    public let image: String?
    public let colors: [ColoRR]?
    public let themes: [Theme]?
    public let catalog: Bool?
    public let kitCost: KitCost?
    public let reorder: Bool?
    public let version: Version?
    public let category: Category
    public let filename: String?
    public let interact: Bool?
    public let bodyColor: BodyColor?
    public let bodyTitle: String?
    public let customize: Bool?
    public let variantId: VariantId?
//    public let internalId: Int?
    public let sourceNotes: String?
    public let speakerType: SpeakerType?
    public let lightingType: LightingType?
    public let obtainedFrom: String?
    public let patternColor: String?
    public let patternTitle: String?
    public let bodyCustomize: Bool?
    public let patternCustomize: Bool?
    public let style: Style?
    public let color1: String?
    public let color2: String?
//    public let uses: UsesUnion?
    public let primaryShape: PrimaryShape?
    public let secondaryShape: SecondaryShape?
    public let doorDeco: DoorDeco?
    public let gender: Gender?
    public let style1: Style?
    public let style2: Style?
    public let species: String?
    public let birthday: The2?
    public let catchphrase: String?
    public let personality: Personality?
    public let vFx: Bool?
    public let vFxType: VFxType?
    public let paneType: PaneType?
    public let windowType: WindowType?
    public let ceilingType: CeilingType?
    public let curtainType: CurtainType?
    public let windowColor: WindowColor?
    public let curtainColor: String?
    public let the1: Int?
    public let the2: The2?
    public let the3: The2?
    public let the4: The2?
    public let the5: The2?
    public let the6: The2?
    public let materials: [MaterialR]?
    public let empty: Int?
    public let house: String?
    public let rarity: Rarity?
    public let weather: Weather?
    public let activeTimes: [ActiveTime]?
    public let itemFilename: String?
    public let activeMonthsNorth: [Int]?
    public let activeMonthsSouth: [Int]?
    public let critterpediaFilename: String?
    public let itemCategory: ItemCategory?
    public let nookMiles: Int?
    public let shadow: String?
    public let increasedWeatherChance: DoorDeco?
    
    enum CodingKeys: String, CodingKey {
        case buy
        case dIy
        case contentSet
        case tag
        case name
        case sell
        case size
        case image
        case colors
        case themes
        case catalog
        case kitCost
        case reorder
        case version
        case category
        case filename
        case interact
        case bodyColor
        case bodyTitle
        case customize
        case variantId
//        case internalId
        case sourceNotes
        case speakerType
        case lightingType
        case obtainedFrom
        case patternColor
        case patternTitle
        case bodyCustomize
        case patternCustomize
        case style
        case color1
        case color2
//        case uses
        case primaryShape
        case secondaryShape
        case doorDeco
        case gender
        case style1
        case style2
        case species
        case birthday
        case catchphrase
        case personality
        case vFx
        case vFxType
        case paneType
        case windowType
        case ceilingType
        case curtainType
        case windowColor
        case curtainColor
        case the1
        case the2
        case the3
        case the4
        case the5
        case the6
        case materials
        case empty
        case house
        case rarity
        case weather
        case activeTimes
        case itemFilename
        case activeMonthsNorth
        case activeMonthsSouth
        case critterpediaFilename
        case itemCategory
        case nookMiles
        case shadow
        case increasedWeatherChance
    }
}

// MARK: - ActiveTime
public struct ActiveTime: Codable {
    public let endTime: Int
    public let startTime: Int
    
    enum CodingKeys: String, CodingKey {
        case endTime
        case startTime
    }
}

public enum The2: Codable {
    case integer(Int)
    case string(String)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(The2.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for The2"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

public enum BodyColor: Codable {
    case integer(Int)
    case string(String)
    case null
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(BodyColor.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for BodyColor"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

public enum CeilingType: String, Codable {
    case cloth = "Cloth"
    case gold = "Gold"
    case plain = "Plain"
    case stone = "Stone"
    case tile = "Tile"
    case wood = "Wood"
}

public enum ColoRR: String, Codable {
    case beige = "Beige"
    case black = "Black"
    case blue = "Blue"
    case brown = "Brown"
    case colorLightBlue = "Light Blue"
    case colorful = "Colorful"
    case gray = "Gray"
    case green = "Green"
    case lightBlue = "Light blue"
    case lightBue = "Light bue"
    case none = "None"
    case orange = "Orange"
    case pink = "Pink"
    case purple = "Purple"
    case red = "Red"
    case white = "White"
    case yellow = "Yellow"
}

public enum ItemSet: String, Codable {
    case antique = "antique"
    case bamboo = "bamboo"
    case bunnyDay = "Bunny Day"
    case cardboard = "cardboard"
    case cherryBlossoms = "cherry blossoms"
    case colorfulTools = "Colorful Tools"
    case cute = "cute"
    case diner = "diner"
    case festive = "festive"
    case flowers = "flowers"
    case frozen = "frozen"
    case fruits = "fruits"
    case golden = "golden"
    case iron = "iron"
    case ironwood = "ironwood"
    case log = "log"
    case motherly = "motherly"
    case mush = "mush"
    case none = "None"
    case outdoorTools = "Outdoor Tools"
    case rattan = "rattan"
    case shell = "shell"
    case stars = "stars"
    case throwback = "throwback"
    case treeSBountyOrLeaves = "tree's bounty or leaves"
    case wooden = "wooden"
    case woodenBlock = "wooden block"
    case zen = "zen"
}

public enum CurtainType: String, Codable {
    case curtains = "Curtains"
    case empty = ""
    case none = "None"
    case rollerShades = "Roller Shades"
    case slattedBlinds = "Slatted Blinds"
}

public enum DoorDeco: String, Codable {
    case no = "No"
    case yes = "Yes"
}

public enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}

public enum ItemCategory: String, Codable {
    case bridge = "Bridge"
    case door = "Door"
    case incline = "Incline"
    case mailbox = "Mailbox"
    case roofing = "Roofing"
    case siding = "Siding"
}

public enum KitCost: Codable {
    case enumeration(VariantId)
    case integer(Int)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(VariantId.self) {
            self = .enumeration(x)
            return
        }
        throw DecodingError.typeMismatch(KitCost.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for KitCost"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumeration(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        }
    }
}

public enum VariantId: String, Codable {
    case na = "NA"
    case the0_0 = "0_0"
}

public enum LightingType: String, Codable {
    case candle = "Candle"
    case emission = "Emission"
    case fluorescent = "Fluorescent"
    case monitor = "Monitor"
    case spotlight = "Spotlight"
}

// MARK: - Material
public struct MaterialR: Codable {
    public let count: Int
    public let itemName: String
    
    enum CodingKeys: String, CodingKey {
        case count
        case itemName
    }
}

public enum PaneType: String, Codable {
    case empty = ""
    case glass = "Glass"
    case na = "NA"
    case screen = "Screen"
}

public enum Personality: String, Codable {
    case cranky = "Cranky"
    case jock = "Jock"
    case normal = "Normal"
    case peppy = "Peppy"
    case personalityLazy = "Lazy"
    case smug = "Smug"
    case snooty = "Snooty"
    case uchi = "Uchi"
}

public enum PrimaryShape: String, Codable {
    case aLine = "A-line"
    case aLong = "A-long"
    case bLong = "B-long"
    case balloon = "Balloon"
    case box = "Box"
    case dress = "Dress"
    case kimono = "Kimono"
    case overall = "Overall"
    case rib = "Rib"
    case robe = "Robe"
    case salopette = "Salopette"
}

public enum Rarity: String, Codable {
    case common = "Common"
    case rare = "Rare"
    case ultraRare = "Ultra-rare"
    case uncommon = "Uncommon"
}

public enum SecondaryShape: String, Codable {
    case empty = ""
    case h = "H"
    case l = "L"
    case n = "N"
}

// MARK: - Size
public struct Size: Codable {
    public let cols: Double
    public let rows: Double
    
    enum CodingKeys: String, CodingKey {
        case cols
        case rows
    }
}

public enum SpeakerType: String, Codable {
    case cheap = "Cheap"
    case hiFi = "Hi-fi"
    case phono = "Phono"
    case retro = "Retro"
}

public enum Style: String, Codable {
    case active = "Active"
    case cool = "Cool"
    case cute = "Cute"
    case elegant = "Elegant"
    case gorgeous = "Gorgeous"
    case simple = "Simple"
}

public enum Theme: String, Codable {
    case bathroom = "bathroom"
    case childSRoom = "child's room"
    case concert = "concert"
    case den = "den"
    case expensive = "expensive"
    case facility = "facility"
    case fancy = "fancy"
    case fitness = "fitness"
    case folkArt = "folk art"
    case freezingCold = "freezing cold"
    case garage = "garage"
    case garden = "garden"
    case horror = "horror"
    case kitchen = "kitchen"
    case livingRoom = "living room"
    case music = "music"
    case none = "None"
    case ocean = "ocean"
    case office = "office"
    case outdoors = "outdoors"
    case party = "party"
    case school = "school"
    case shop = "shop"
    case space = "space"
    case zenStyle = "zen-style"
}

public enum UsesEnum: String, Codable {
    case the95 = "9.5?"
    case unlimited = "Unlimited"
}

public enum VFxType: String, Codable {
    case lightOff = "LightOff"
    case na = "NA"
    case random = "Random"
    case synchro = "Synchro"
}

public enum Version: String, Codable {
    case the100 = "1.0.0"
    case the110 = "1.1.0"
    case the110A = "1.1.0a"
}

public enum Weather: String, Codable {
    case anyExceptRain = "Any except rain"
    case anyWeather = "Any weather"
    case rainOnly = "Rain only"
}

public enum WindowColor: String, Codable {
    case blackMetal = "Black Metal"
    case darkWood = "Dark Wood"
    case empty = ""
    case greyMetal = "Grey Metal"
    case greyWood = "Grey Wood"
    case lightWood = "Light Wood"
    case na = "NA"
    case naturalWood = "Natural Wood"
    case whiteMetal = "White Metal"
    case whiteWood = "White Wood"
    case wood = "Wood"
}

public enum WindowType: String, Codable {
    case arch = "Arch"
    case circle = "Circle"
    case empty = ""
    case fourPane = "Four Pane"
    case none = "None"
    case singlePane = "Single Pane"
    case slidingPane = "Sliding Pane"
}

// MARK: - Variation
public struct Variation: Codable {
    public let id: Int
    public let position: Int
    public let content: VariationContent
    public let createdAt: String? // TODO
    public let updatedAt: Date?
    public let item: ItemR
    
    enum CodingKeys: String, CodingKey {
        case id
        case position
        case content
        case createdAt
        case updatedAt
        case item
    }
}

// MARK: - VariationContent
public struct VariationContent: Codable {
    public let contentSet: ItemSet?
    public let tag: Tag?
    public let name: String
    public let image: String
    public let colors: [ColoRR]?
    public let themes: [Theme]?
    public let filename: String
    public let bodyColor: BodyColor?
    public let bodyTitle: String?
//    public let internalId: Int
    public let patternColor: String?
    public let patternTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case contentSet
        case tag
        case name
        case image
        case colors
        case themes
        case filename
        case bodyColor
        case bodyTitle
//        case internalId
        case patternColor
        case patternTitle
    }
}

public enum Tag: String, Codable {
    case airConditioning = "Air Conditioning"
    case animal = "Animal"
    case arch = "Arch"
    case audio = "Audio"
    case bathroomThings = "Bathroom Things"
    case bathtub = "Bathtub"
    case beauty = "Beauty"
    case bed = "Bed"
    case chair = "Chair"
    case chest = "Chest"
    case clock = "Clock"
    case compass = "Compass"
    case desk = "Desk"
    case dining = "Dining"
    case dresser = "Dresser"
    case facilityDecor = "Facility Decor"
    case fan = "Fan"
    case fireplace = "Fireplace"
    case folkCraftDecor = "Folk Craft Decor"
    case gameConsole = "Game Console"
    case garden = "Garden"
    case heating = "Heating"
    case homeAppliances = "Home Appliances"
    case hospital = "Hospital"
    case houseDoorDecor = "House Door Decor"
    case japaneseStyle = "Japanese Style"
    case kitchen = "Kitchen"
    case kitchenThings = "Kitchen Things"
    case lamp = "Lamp"
    case musicalInstrument = "Musical Instrument"
    case na = "NA"
    case office = "Office"
    case outdoorsDecor = "Outdoors Decor"
    case plants = "Plants"
    case playground = "Playground"
    case ranch = "Ranch"
    case school = "School"
    case screen = "Screen"
    case seaside = "Seaside"
    case seasonalDecor = "Seasonal Decor"
    case sewingTable = "Sewing Table"
    case shelf = "Shelf"
    case shop = "Shop"
    case sofa = "Sofa"
    case space = "Space"
    case sports = "Sports"
    case study = "Study"
    case supplies = "Supplies"
    case table = "Table"
    case toilet = "Toilet"
    case toy = "Toy"
    case tv = "TV"
    case vehicle = "Vehicle"
    case workBench = "Work Bench"
}

// MARK: - Item
public struct ItemR: Codable {
    public let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}
