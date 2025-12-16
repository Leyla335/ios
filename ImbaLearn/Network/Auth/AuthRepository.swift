

class AuthRepository {
    let apiService: NetworkService
    
    init(apiService: NetworkService) {
        self.apiService = apiService
    }
    
    func register(request: RegisterRequest, completion: @escaping (NetworkResponse<AuthResponse>) -> Void) {
        apiService.request(requestModel: .init(urlString: AuthEndpoint.register.path, method: .post, body: .encodable(request)), completion: completion)
    }
    
    func login(request: LoginRequest, completion: @escaping (NetworkResponse<AuthResponse>) -> Void) {
        apiService.request(requestModel: .init(urlString: AuthEndpoint.login.path, method: .post, body: .encodable(request)), completion: completion)
    }
    
    func logout(completion: @escaping (NetworkResponse<AuthResponse>) -> Void) {
        apiService.request(requestModel: .init(urlString: AuthEndpoint.logout.path, method: .post), completion: completion)
    }
}
