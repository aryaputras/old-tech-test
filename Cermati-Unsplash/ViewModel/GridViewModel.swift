//
//  NewsFeedModels.swift
//  NewsApp
//
//  Created by SchwiftyUI on 12/11/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import Foundation
import SwiftUI

class GridViewModel: ObservableObject, RandomAccessCollection {
    typealias Element = Result
    
    
    var startIndex: Int { results.startIndex }
    var endIndex: Int { results.endIndex }
    
    
//MARK:- Config
    //Configure API
    @Published var results = [Result]()
    @Published var errorCode:Int = 0
    var defaultQuery = "coffee"
    var loadStatus = LoadStatus.ready(nextPage: 1)
    var token = "fhEA0d2OraRtBqLpL7TczMlxclLrrH0UOIHeGXjyG_U"
    var urlBase = "https://api.unsplash.com/search/photos?page="
    
    
    subscript(position: Int) -> Result {
        return results[position]
    }
    
//MARK:-Func
    func loadMoreResults(currentItem: Result? = nil, query: String?) {
        
        
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        guard case let .ready(page) = loadStatus else {
            return
        }
        loadStatus = .loading(page: page)
        
        //API Configuration
        let urlString = "\(urlBase)\(page)&query=\(query!)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: parseArticlesFromResponse(data:response:error:))
        task.resume()
        
    }
    
    //Check if should load more data
    func shouldLoadMoreData(currentItem: Result? = nil) -> Bool {
        guard let currentItem = currentItem else {
            return true
        }
        
        for n in (results.count - 4)...(results.count-1) {
            if n >= 0 && currentItem.id == results[n].id {
                return true
            }
        }
        return false
    }
    
    
    func parseArticlesFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        if ((error?.localizedDescription.contains("1001")) != nil)
        {
            print("REQUEST TIMED OUT")
            errorCode = 1001
        }
        guard error == nil else {
            print("Error: \(error!)")
            loadStatus = .parseError
            return
        }
        guard let data = data else {
            print("No data found")
            loadStatus = .parseError
            return
        }
        
        //Appending new result to results variable
        let newResults = parseArticlesFromData(data: data)
        DispatchQueue.main.async {
            self.results.append(contentsOf: newResults)
            
            if newResults.count == 0 {
                self.loadStatus = .done
            } else {
                guard case let .loading(page) = self.loadStatus else {
                    fatalError("loadSatus is in a bad state")
                }
                self.loadStatus = .ready(nextPage: page + 1)
            }
        }
    }
    
    
    //Decode JSON
    func parseArticlesFromData(data: Data) -> [Result] {
        var response: Results
        do {
            response = try JSONDecoder().decode(Results.self, from: data)
        } catch {
            print("Error parsing the JSON: \(error)")
            return []
        }
        
        
        
        return response.results ?? []
    }
    //Load state
    enum LoadStatus {
        case ready (nextPage: Int)
        case loading (page: Int)
        case parseError
        case done
    }
}
