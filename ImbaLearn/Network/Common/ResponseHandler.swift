
import Foundation

typealias NetworkResponse<T> = Result<T, NetworkError>

protocol ResponseHandler: AnyObject {
    func handle<T: Decodable>(
        data: Data?,
        httpResponse: HTTPURLResponse?,
        completion: @escaping (NetworkResponse<T>) -> Void)
}

extension ResponseHandler {
    func handle<T: Decodable>(data: Data?, httpResponse: HTTPURLResponse?, completion: @escaping (NetworkResponse<T>) -> Void) {
        
        let completion: (NetworkResponse<T>) -> Void = {
            response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
        
        guard let httpResponse else {
            completion(.failure(.unknown))
            return
        }
        
        if let headers = httpResponse.allHeaderFields as? [String: String],
           let url = httpResponse.url {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
            // Find token cookie
            if let tokenCookie = cookies.first(where: { $0.name == "token" }) {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(tokenCookie.value, forKey: "authToken")
                    print("✅ Extracted token from cookies: \(tokenCookie.value.prefix(20))...")
                }
            }
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            // Success
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            print("\nData:", String(data: data, encoding: .utf8) as Any, "\n")
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
            
        case 401:
            // Unauthorized - clear token
            UserDefaults.standard.set(nil, forKey: "authToken")
            DispatchQueue.main.async {
                // Send notification that session expired
                NotificationCenter.default.post(name: .sessionExpired, object: nil)
                completion(.failure(.unauthorized))
            }
            
        case 403:
            completion(.failure(.forbidden))
            
        case 404:
            completion(.failure(.notFound))
            
        case 429:
            completion(.failure(.rateLimited))
            
        case 400...499, 500...599:
            // Client or server error
            if let data = data {
                let errorMessage = parseErrorMessage(from: data)
                completion(.failure(.serverError(errorMessage)))
            } else {
                completion(.failure(.serverError("Server error: \(httpResponse.statusCode)")))
            }
            
        default:
            completion(.failure(.unknown))
        }
    }
    
    func parseErrorMessage(from data: Data) -> String {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            if let message = errorResponse.message {
                return message
            } else if let errors = errorResponse.errors {
                // Combine all error messages
                let allErrors = errors.values.flatMap { $0 }
                return allErrors.joined(separator: "\n")
            }
        } catch {
            // If we can't decode, try to get raw string
            if let string = String(data: data, encoding: .utf8) {
                return string
            }
        }
        return "Unknown error occurred"
    }
}
