

import Foundation

protocol URLRequestBuilder {
    var baseUrl: String { get }
    var token: String? { get }
    func getUrl(_ model: NetworkRequestModel) -> URL?
    func getUrlRequest(_ model: NetworkRequestModel) -> NetworkResponse<URLRequest>
    func printURLRequest(_ request: URLRequest)
}

extension URLRequestBuilder {
    var baseUrl: String {
        "https://imba-server.up.railway.app"
    }
    
    var token: String? {
        UserDefaults.standard.string(forKey: "authToken")
    }
    
    func getUrl(_ model: NetworkRequestModel) -> URL? {
        var urlComponents = URLComponents(string: baseUrl + model.urlString)
        if let queryParameters = model.query, !queryParameters.isEmpty {
            urlComponents?.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        return urlComponents?.url
    }
    
    func getUrlRequest(_ model: NetworkRequestModel) -> NetworkResponse<URLRequest> {
        guard let url = getUrl(model) else { return .failure(.invalidURL) }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = model.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("text/plain", forHTTPHeaderField: "accept")
        if let accessToken = token {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        if let body = model.body {
            switch body {
            case .encodable(let encodable):
                do {
                    urlRequest.httpBody = try JSONEncoder().encode(encodable)
                }
                catch {
                    return .failure(.encodingError(error))
                }
            case .data(let data):
                urlRequest.httpBody = data
            }
            
        }
        printURLRequest(urlRequest)
        return .success(urlRequest)
    }
    
    func printURLRequest(_ request: URLRequest) {
        print() //Print new line
        
        // Print URL
        if let url = request.url {
            print("URL: \(url.absoluteString)")
        } else {
            print("URL: None")
        }

        // Print HTTP Method
        if let method = request.httpMethod {
            print("Method: \(method)")
        } else {
            print("Method: None")
        }

        // Print Headers
        if let headers = request.allHTTPHeaderFields {
            print("Headers: ")
            for (key, value) in headers {
                print("\t\(key): \(value)")
            }
        } else {
            print("Headers: None")
        }

        // Print Body
        if let body = request.httpBody {
            if let bodyString = String(data: body, encoding: .utf8) {
                print("Body: \(bodyString)")
            } else {
                print("Body: (Binary data - unable to convert to string)")
            }
        } else {
            print("Body: None")
        }
    }
}
