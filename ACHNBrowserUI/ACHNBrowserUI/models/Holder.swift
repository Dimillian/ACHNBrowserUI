import Foundation

// MARK: - ItemElement
struct ItemElement: Decodable {
    let id: Int
    let name: String
    let details: String?
    let source: Source
    let diy: Bool
    let buy: Int?
    let sell: Int
    let colors: [Colors]
    let hhaConcepts: [String]
    let variants: [[Variant]]
    let recipe: Recipe?
    let size: String?
    let tag: String
}

enum Colors: String, Decodable {
    case beige = "Beige"
    case black = "Black"
    case blue = "Blue"
    case brown = "Brown"
    case colorLightBlue
    case colorful = "Colorful"
    case gray = "Gray"
    case green = "Green"
    case lightblue = "Light blue" // fix this typo in data
    case lightBlue = "Light Blue"
    case lightBue = "Light bue" // fix this typo in the data
    case none = "None"
    case orange = "Orange"
    case pink = "Pink"
    case purple = "Purple"
    case red = "Red"
    case white = "White"
    case yellow = "Yellow"
}

// MARK: - Recipe
struct Recipe: Decodable {
    let name: String
    let source: String
    let category: Category
    let materials: [MaterialHolder]
}

enum Category: String, Decodable {
    case floors = "Floors"
    case housewares = "Housewares"
    case miscellaneous = "Miscellaneous"
    case rugs = "Rugs"
    case wallMounted = "Wall-Mounted"
    case wallpaper = "Wallpaper"
}

// MARK: - Material
struct MaterialHolder: Decodable {
    let name: String
    let count: Int
}

enum Source: String, Decodable {
    case birthday = "Birthday"
    case bugOff = "Bug-Off"
    case bunnyDay = "Bunny Day"
    case cj = "C.J."
    case crafting = "Crafting"
    case dodoAirlines = "Dodo Airlines"
    case fishingTourney = "Fishing Tourney"
    case flick = "Flick"
    case gulliver = "Gulliver"
    case hha = "HHA"
    case mom = "Mom"
    case nintendo = "Nintendo"
    case nintendoNookShopping = "Nintendo\nNook Shopping"
    case nookMilesShop = "Nook Miles Shop"
    case nooksCranny = "Nook's Cranny"
    case nookShoppingPromotion = "Nook Shopping Promotion"
    case saharah = "Saharah"
    case snowman = "Snowman"
    case startingItems = "Starting items"
}

// MARK: - Variant
struct Variant: Decodable {
    let id: Int
    let image: String
    let colors: [Colors]
    let name: String?
}
