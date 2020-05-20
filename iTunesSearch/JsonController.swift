import Foundation

import UIKit

extension URL {
  func withQueries(_ queries: [String: String]) -> URL? {
    var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
    components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
    return components?.url
  }
}

class JsonController {
    
    func fetchItems(matching query: [String: String], completion: @escaping (JsonScheme?) -> Void) {

        let baseURL = URL(string: "https://itunes.apple.com/search?")!

        let url = baseURL.withQueries(query)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(try? JSONDecoder().decode(JsonScheme.self, from: data))
            }
        }

        task.resume()
    }
}



struct JsonScheme: Codable {
    let results: [StoreItem]
    
    struct StoreItem: Codable {
        var trackName: String
        var artistName: String
        var artworkUrl100: URL
      
        enum CodingKeys: String, CodingKey {
            case trackName
            case artistName
            case artworkUrl100
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            trackName = try values.decode(String.self, forKey: CodingKeys.trackName)
            artistName = try values.decode(String.self, forKey: CodingKeys.artistName)
            artworkUrl100 = try values.decode(URL.self, forKey: CodingKeys.artworkUrl100)
        }
    }
}
