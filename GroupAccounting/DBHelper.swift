//
//  DBHelper.swift
//  GroupAccounting
//
//  Created by Vijayaraghavan Sundararaman on 16/09/2022.
//

import Foundation


func postUserInfo(userInfo:UserInfo) async throws {
    let encoder = JSONEncoder()
    guard let uploadData  = try? encoder.encode(userInfo) else {
        print("Could not convert to JSON")
        return
    }
    let urlRequest = getURLRequest(httpMethod: "POST", endURL: "/namespaces/\(ASTRA_DB_KEYSPACE)/collections/userInfo")
    let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: uploadData)
    guard let response = response as? HTTPURLResponse,
          response.statusCode == 201 else {
        print("Response \(response)")
        return
    }
    if response.mimeType == "application/json" {
        let stringData = String(data: data, encoding: .utf8)
        print("Got data \(stringData)")
        return
    }
    print("Data could not be converted to a string")
}


func getURLRequest(httpMethod:String, endURL:String) -> URLRequest {
    let str = "https://" + ASTRA_DB_ID + "-" + ASTRA_DB_REGION + ".apps.astra.datastax.com/api/rest/v2" + endURL
    let encodedStr = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL.init(string: encodedStr)!
    let ASTRA_DB_APPLICATION_TOKEN = Bundle.main.infoDictionary?["ASTRA_DB_APPLICATION_TOKEN"] as? String
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = httpMethod
     
    if(httpMethod == "POST"){
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    print("Token \(ASTRA_DB_APPLICATION_TOKEN)")
    urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
    urlRequest.setValue(ASTRA_DB_APPLICATION_TOKEN, forHTTPHeaderField: "X-Cassandra-Token")

    return urlRequest
}
