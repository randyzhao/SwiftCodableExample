//: Playground - noun: a place where people can play

import Foundation

let json = """
{
  "username": "Test user",
  "country": {
    "name": "United States",
    "code": "US"
  },
  "type": 2
}
""".data(using: .utf8)!

struct Country: Codable {
  let countryName: String
  let countryCode: String

  private enum CodingKeys: String, CodingKey {
    case countryName = "name"
    case countryCode = "code"
  }
}

enum UserType: Int, Codable {
  case normal = 1
  case admin = 2
}

struct User: Codable {
  let username: String
  let type: UserType
  let country: Country
}

let decoder = JSONDecoder()
let user = try! decoder.decode(User.self, from: json)

let encoder = JSONEncoder()
let jsonData = try! encoder.encode(user)
print(jsonData)

