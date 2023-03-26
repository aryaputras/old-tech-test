//
//  SearchViewModel.swift
//  Cermati-Unsplash
//
//  Created by Abigail Aryaputra Sudarman on 02/08/21.
//

import Foundation
import SwiftUI



class SearchController: ObservableObject{
    static let shared = SearchController()
    init(){
        
    }
    
    @Published var results = [Result]()
    @State var searchString: String = "office"
    var token = "fhEA0d2OraRtBqLpL7TczMlxclLrrH0UOIHeGXjyG_U"
    
    func search(query: String){
        print("search")
        let url = URL(string: "https://api.unsplash.com/search/photos?page=1&query=\(query)")
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            
            do{
                let res = try JSONDecoder().decode(Results.self, from: data)
                self.results.append(contentsOf: res.results)
                print(data)
                print(self.results)
            }
            catch
            { print(error.localizedDescription)
                print("error")
                
            }
        }
        task.resume()
        
        
    }
}
