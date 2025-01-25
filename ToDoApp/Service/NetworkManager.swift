//
// NetworkManager.swift
// ToDoApp


import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func getTodosFromURL(completion: @escaping (Result<[TodoModel], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        fetchTodos(from: url) { data in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(TodoResponseModel.self, from: data)
                    completion(.success(response.todos))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
            }
        }
    }
    
    private func fetchTodos(from url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else {
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
            
        }.resume()
        
    }
}
