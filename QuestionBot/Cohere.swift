//
//  MaxBot.swift
//  QuestionBot
//
//  Created by Max Siebengartner on 7/11/2023.
//  Copyright © 2023 Apple Inc. All rights reserved.
//
//  Hello this is a cohere thing. Implements most features of the cohere api in swift. It probably works in most use cases. Refer here for info: https://docs.cohere.com/reference/about
//  once i get everything working ill make a package for it

import Foundation


/// `text` is the input
/// `label` is the expected classification
///  important : each classification needs at least 1 text example. also the more examples you provide, the more accurate the classification is
public struct Example {
    let text : String
    let label : Any
    
    init(text: String, label: Any) {
        self.text = text
        self.label = label
    }
    func dict() -> [String : Any] {
        return ["text" : self.text, "label" : self.label]
    }
}

class Cohere {
    
    static let headers = [
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": "Bearer XQ0UUAWgS9ZDFt6aaDlGyUJcX4RJEgyqWXPG7drq"
    ]
    static func classify(inputs: [String], examples : [Example], call : @escaping (Structs.Classification?)->Void) {
        var _examples : [[String : Any]] = []
        for i in examples {
            _examples.append(
                i.dict()
            )
        }
        let parameters = [
            "truncate": "END",
            "inputs": inputs,
            "examples": _examples
        ] as [String : Any]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.cohere.ai/v1/classify")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        URLRequest(request: request, jsonDecoder: Structs.Classification.self) { response in
            call(response)
        }
    }
    public enum CohereModel : String {
        case command = "command"
        case commandNightly = "command-nightly"
        case commandLight = "command-light"
        case commandLightNightly = "command-light-nightly"
    }
    static func generate(prompt : String, model : CohereModel = .command, num_generations : Int = 1, stream : Bool = false, call : @escaping (Structs.Generation?)->Void) {
        let parameters = [
            "truncate": "END",
            "return_likelihoods": "NONE",
            "prompt": prompt,
            "num_generations": num_generations,
            "stream": stream,
            "model": model.rawValue
        ] as [String : Any]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.cohere.ai/v1/generate")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        URLRequest(request: request, jsonDecoder: Structs.Generation.self) { response in
            call(response)
        }
    }
    static func embed(
        texts : [String],
        call : @escaping (Structs.Embedding)->Void) {
            
            let parameters = [
                "texts": texts,
                "truncate": "END"
            ] as [String : Any]
            
            guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.cohere.ai/v1/embed")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            URLRequest(request: request, jsonDecoder: Structs.Embedding.self) { response in
                call(response)
            }
        }
    public enum Length : String {
        case short = "short"
        case medium = "medium"
        case long = "long"
    }
    public enum Format : String {
        case paragraph = "paragraph"
        case bullets = "bullets"
        case auto = "auto"
    }
    public enum Extractiveness : String {
        case low = "low"
        case medium = "medium"
        case high = "high"
        case auto = "auto"
    }
    static func summarize(text: String, length : Length = .medium, format : Format = .auto, temperature: Double = 0.3, extractiveness : Extractiveness = .auto, model : CohereModel = .command, call: @escaping (Structs.Summarize)->Void) {
        let parameters = [
            "length": length.rawValue,
            "format": format.rawValue,
            "extractiveness": extractiveness.rawValue,
          "temperature": temperature,
          "text": text
        ] as [String : Any]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.cohere.ai/v1/summarize")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        URLRequest(request: request, jsonDecoder: Structs.Summarize.self) { response in
            call(response)
        }
    }
    public enum RerankModel : String {
        case multilingual = "rerank-multilingual-v2.0"
        case english = "rerank-english-v2.0"
    }
    ///yo dont change the last 3 params unless you for sure know what ur doing :)
    static func rerank(query : String, documents : [String], model : RerankModel = .english, topN : Int, maxChunks : Int = 10, returnDocuments : Bool = true, call : @escaping (Structs.Rerank?)->Void) {
        let parameters = [
          "return_documents": false,
          "max_chunks_per_doc": maxChunks,
          "model": model.rawValue,
          "query": query,
          "documents": documents,
          "top_n": topN,
        ] as [String : Any]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.cohere.ai/v1/rerank")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        URLRequest(request: request, jsonDecoder: Structs.Rerank.self) { response in
            call(response)
        }
    }
    static func URLRequest<T : Codable>(request : NSMutableURLRequest, jsonDecoder : T.Type, callback : @escaping (T)->Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(response!)")
                    return
                }
                if let data = data {
                    if let result = ParseResult(data: data, jsonDecoder: T.self) {
                        callback(result)
                    }
                }
            }
        })
        dataTask.resume()
    }
}
public func ParseResult<T : Codable>(data: Data, jsonDecoder: T.Type) -> T? {
    do {
        let newData = try JSONDecoder().decode(T.self, from: data)
        return newData
    } catch {
        print(error)
    }
    return nil
}
