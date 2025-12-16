
import Foundation

class NetworkService: URLRequestBuilder, ResponseHandler {
    static let shared = NetworkService()
    
    private init() {}
    
    @discardableResult
    func request<T: Decodable>(
        requestModel: NetworkRequestModel,
        completion: @escaping (NetworkResponse<T>) -> Void
    ) -> URLSessionDataTask? {
        let request = getUrlRequest(requestModel)
        switch request {
        case .success(let urlRequest):
            let request = URLSession.shared.dataTask(with: urlRequest,
                                                     completionHandler: {
                [weak self] data, response, error in
                guard let self else { return }
                let httpResponse = response as? HTTPURLResponse
                self.handle(
                    data: data,
                    httpResponse: httpResponse,
                    completion: completion)
            })
            request.resume()
            return request
        case .failure(let error):
            completion(.failure(error))
            return nil
        }
    }
    
    func getData(_ urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            DispatchQueue.main.async {
                completion(data)
            }
        }).resume()
    }
}
