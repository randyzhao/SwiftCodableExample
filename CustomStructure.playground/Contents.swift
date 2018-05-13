//: Playground - noun: a place where people can play

import Foundation

let json = """
{
  "latitude": 12.0,
  "longitude": 13.0,
  "additionalInfo": {
    "elevation": 456,
    "has_google_map": false
  }
}
""".data(using: .utf8)!

struct Coordinate: Codable {
  let latitude: Double
  let longitude: Double
  let elevation: Double
  let hasGoogleMap: Bool

  private enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
    case additionalInfo
  }

  private enum AdditionalInfoKeys: String, CodingKey {
    case elevation
    case hasGoogleMap = "has_google_map"
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    latitude = try values.decode(Double.self, forKey: .latitude)
    longitude = try values.decode(Double.self, forKey: .longitude)

    let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
    elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
    hasGoogleMap = try additionalInfo.decode(Bool.self, forKey: .hasGoogleMap)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)

    var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
    try additionalInfo.encode(elevation, forKey: .elevation)
    try additionalInfo.encode(hasGoogleMap, forKey: .hasGoogleMap)
  }
}

let decoder = JSONDecoder()
let coordinate = try! decoder.decode(Coordinate.self, from: json)

let encoder = JSONEncoder()
let jsonData = try! encoder.encode(coordinate)
print(jsonData)

