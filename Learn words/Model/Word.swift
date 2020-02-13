import Foundation

struct Words: Decodable {
    let id: Int
    let word: String
    let translate: [Translate]
}

struct Translate: Decodable{
    let id: Int
    let word_id: Int
    let translate: String
}

struct AddWord: Encodable {
    let id: Int
    let word: String
    let translate: String
    let token: String
}
