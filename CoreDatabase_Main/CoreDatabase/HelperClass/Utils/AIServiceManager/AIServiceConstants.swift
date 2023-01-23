//
//  AIServiceConstants.swift
//

import Foundation


let api_Key = "5bda10a9cad0485a85626c76545c4cdc"

func getFinalApi(search: String) -> String {
    
    let apiName = "https://newsapi.org/v2/everything?q=\(search)&from=2021-0601&sortBy=publishedAt&apiKey=\(api_Key)"

    return apiName
}

func getDomainApi() -> String{
    let apiName = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=\(api_Key)"
    return apiName
}

