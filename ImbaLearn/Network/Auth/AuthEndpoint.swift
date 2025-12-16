

enum AuthEndpoint: String {
    case register = "/register"
    case login = "/login"
    case logout = "/logout"
    
    var basePath: String {
        "/auth"
    }
    
    var path: String {
        basePath + rawValue
    }
}
