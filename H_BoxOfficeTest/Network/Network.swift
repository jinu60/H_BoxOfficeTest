//
//  Network.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case parseError
    case invalidResponse
    case noData
    case networkError(Error)
}

public class Network {
    static func requestData(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.noData))
            }
        }.resume()
    }
    
    static func getBoxOffice(targetDt: String, weekGb: String, completeHandler: @escaping (_ result: Result<BoxOffice, NetworkError>) -> Void) {
        let urlString = NetworkConstant.baseUrl + NetworkConstant.boxofficeUrl + "key=" + NetworkConstant.key + "&targetDt=" + targetDt + "&weekGb=" + weekGb
        
        requestData(with: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let resultData = try JSONDecoder().decode(BoxOffice.self, from: data)
                    completeHandler(.success(resultData))
                } catch {
                    completeHandler(.failure(.parseError))
                }
            case .failure(let error):
                completeHandler(.failure(error))
            }
        }
    }
    
    static func getMoive(movieCd: String, completeHandler: @escaping (_ result: Result<Movie, NetworkError>) -> Void) {
        let urlString = NetworkConstant.baseUrl + NetworkConstant.movieUrl + "key=" + NetworkConstant.key + "&movieCd=" + movieCd
        
        requestData(with: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let resultData = try JSONDecoder().decode(Movie.self, from: data)
                    completeHandler(.success(resultData))
                } catch {
                    completeHandler(.failure(.parseError))
                }
            case .failure(let error):
                completeHandler(.failure(error))
            }
        }
    }
}
