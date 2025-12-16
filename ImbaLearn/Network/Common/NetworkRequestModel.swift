import Foundation

enum NetworkRequestBody {
    case encodable(Encodable)
    case data(Data)
}

struct NetworkRequestModel {
    let urlString: String
    let method: HTTPMethod
    let query: [String: String]?
    let body: NetworkRequestBody?
    
    init(urlString: String, method: HTTPMethod, query: [String : String]? = nil) {
        self.urlString = urlString
        self.method = method
        self.query = query
        self.body = nil
    }
    
    init(urlString: String, method: HTTPMethod, query: [String : String]? = nil, body: NetworkRequestBody?) {
        self.urlString = urlString
        self.method = method
        self.query = query
        self.body = body
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
