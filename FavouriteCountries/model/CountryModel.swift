

import Foundation
import FirebaseFirestoreSwift

struct Name: Codable {
    let common: String
    let official: String
}

struct Flags: Codable {
    let png: String
    let svg: String
    let alt: String?
}

struct Country: Codable {
    let name: Name
    let capital: [String]?
    let population: Int?
    let flags: Flags
    let region: String
}


struct FavCountry: Codable, Hashable {
    @DocumentID var id : String? = UUID().uuidString
    
    let name: String
    let capital: String?
    let population: Int
    let flag: String?
    let region: String
}
