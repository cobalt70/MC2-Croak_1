//
//  fetchJSONData.swift
//  Croak
//
//  Created by jeong hyein on 5/13/24.
//

import Foundation

struct TimeResponse: Codable {
    let datetime: String
    let date: String
    let time: String
    
    // 다른 필요한 속성들이 있다면 여기에 추가
    
    // 날짜와 시간을 추출하여 date와 time 속성에 저장하는 초기화 메서드
    init(datetime: String) {
        self.datetime = datetime
        
        let components = datetime.components(separatedBy: "T")
        if components.count == 2 {
            self.date = components[0]
            
            let timeAndZone = components[1].components(separatedBy: ".")
            if timeAndZone.count == 2 {
                self.time = timeAndZone[0]
            } else {
                self.time = components[1]
            }
        } else {
            self.date = ""
            self.time = ""
        }
    }
    
    // 날짜와 시간을 조합하여 String으로 반환하는 메서드
    func formattedDateTime() -> String {
        return "\(date) \(time)"
    }
}


// API에서 JSON 데이터 가져오고 datetime 값을 추출하는 함수
func fetchJSONData(from urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                return
            }
            
            do {
                let timeResponse = try JSONDecoder().decode(TimeResponse.self, from: responseData)
                completion(.success(timeResponse.formattedDateTime()))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
