//
//  ViewModel.swift
//  Albertsons
//
//  Created by Gopi Krishna Yenuganti on 10/17/21.
//

import Foundation

class ResponseViewModel {
  
    var data: Welcome?
  
  func getResponse(value: String, onSuccess success:@escaping () -> Void, onFailure failure:@escaping () -> Void) {
    let urlString = "http://www.nactem.ac.uk/software/acromine/dictionary.py"
    guard var urlComponents = URLComponents(string: urlString) else { return }
    let queryItems = [URLQueryItem(name: "sf", value: value), URLQueryItem(name: "if", value: value)]
    urlComponents.queryItems = queryItems
    let request = URLRequest(url: urlComponents.url!)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data,
            let response = response as? HTTPURLResponse,
            error == nil else {
              print("error", error ?? "Unknown error")
              return
            }
      
      guard (200 ... 299) ~= response.statusCode else {
        print("statusCode should be 2xx, but is \(response.statusCode)")
        print("response = \(response)")
        return
      }
      
      do {
        let jsonDecoder = JSONDecoder()
        let responseData = try jsonDecoder.decode(Welcome.self, from: data)
        self.data = responseData
        success()
      } catch {
        failure()
      }
    }
    
    task.resume()
  }
  
  func cellsToDisplay() -> Int {
    return self.data?[0].lfs[0].vars?.count ?? 0
  }
  
  func modelForCell(index: Int) -> LF? {
    return self.data?[0].lfs[0].vars?[index]
  }
}

struct WelcomeElement: Codable {
    let sf: String
    let lfs: [LF]
}

// MARK: - LF
struct LF: Codable {
    let lf: String
    let freq, since: Int
    let vars: [LF]?
}

typealias Welcome = [WelcomeElement]
