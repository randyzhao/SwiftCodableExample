//: Playground - noun: a place where people can play

import Foundation

let json = """
{
  "username": "Test user",
  "additional_info": [
    {
      "registration_time": "01/01/2017",
      "registration_device": "iPhone 6",
      "registration_ip": "1.2.3.4"
    },
    {
      "some_random_info": "XXXX"
    },
    {
      "preferred_language": "English",
      "preferred_currency": "USD"
    }
  ]
}
""".data(using: .utf8)!

struct RegistrationInfo: Codable {
  let time: String
  let device: String
  let ip: String

  private enum CodingKeys: String, CodingKey {
    case time = "registration_time"
    case device = "registration_device"
    case ip = "registration_ip"
  }
}

struct PreferenceInfo: Codable {
  let language: String
  let currency: String

  private enum CodingKeys: String, CodingKey {
    case language = "preferred_language"
    case currency = "preferred_currency"
  }
}

struct DummyInfo: Codable { }

struct User: Codable {
  let username: String
  var registrationInfo: RegistrationInfo?
  var preference: PreferenceInfo?

  private enum CodingKeys: String, CodingKey {
    case username
    case additionalInfo = "additional_info"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    username = try values.decode(String.self, forKey: .username)

    var additionalInfo = try values.nestedUnkeyedContainer(forKey: .additionalInfo)
    while !additionalInfo.isAtEnd {
      if let registrationInfo = try? additionalInfo.decode(RegistrationInfo.self) {
        self.registrationInfo = registrationInfo
      } else if let preference = try? additionalInfo.decode(PreferenceInfo.self) {
        self.preference = preference
      } else {
        let _ = try additionalInfo.decode(DummyInfo.self)
      }
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(username, forKey: .username)

    var additionalInfo = container.nestedUnkeyedContainer(forKey: .additionalInfo)
    try additionalInfo.encode(registrationInfo)
    try additionalInfo.encode(preference)
  }
}

let decoder = JSONDecoder()
let user = try! decoder.decode(User.self, from: json)

let encoder = JSONEncoder()
let jsonData = try! encoder.encode(user)
print(String(data: jsonData, encoding: .utf8)!)
