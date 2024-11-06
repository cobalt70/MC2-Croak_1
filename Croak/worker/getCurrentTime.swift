//
//  getCurrentTime.swift
//  Croak
//
//  Created by jeong hyein on 5/15/24.
//

import Foundation

func getCurrentTime(completion: @escaping (String?) -> Void) {
    let urlString = "http://worldtimeapi.org/api/timezone/Asia/Seoul"
    
    // HTTP 요청 생성
    var request = URLRequest(url: URL(string: urlString)!)
    request.httpMethod = "GET"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           guard let data = data, error == nil else {
               print("Error: \(error?.localizedDescription ?? "Unknown error")")
               completion(nil)
               return
           }
           
           do {
               // JSON 데이터를 디코딩합니다.
               if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let currentDate = json["datetime"] as? String {
                   print("current: \(currentDate)")
                   completion(currentDate)
               } else {
                   print("Error parsing response data.")
                   completion(nil)
               }
           } catch {
               print("JSON Decoding Error: \(error.localizedDescription)")
               completion(nil)
           }
       }
       
       task.resume()
   }
