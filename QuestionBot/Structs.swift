import Foundation

// This file was generated from JSON Schema using codebeautify, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome3 = try Welcome3(json)

import Foundation

// MARK: - WeatherData
public class Structs{
    
    // MARK: - WeatherData
    public struct WeatherData: Codable {
        let coord: Coord?
        let weather: [Weather]?
        let base: String?
        let main: Main?
        let visibility: Int?
        let wind: Wind?
        let clouds: Clouds?
        let dt: Int?
        let sys: Sys?
        let timezone, id: Int?
        let name: String?
        let cod: Int?
    }
    
    // MARK: - Clouds
    struct Clouds: Codable {
        let all: Int
    }
    
    // MARK: - Coord
    struct Coord: Codable {
        let lon, lat: Double
    }
    
    // MARK: - Main
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity, seaLevel, grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    // MARK: - Sys
    struct Sys: Codable {
        let country: String?
        let sunrise, sunset: Int
    }
    
    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }
    
    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    public struct Results: Codable{
        var total: Int
        var results: [Result]
    }
    public struct Result: Codable{
        var id: String
        var description: String?
        var ulrs: URLs?
        
    }
    struct URLs: Codable{
        var small: String
    }
    public struct City : Codable {
        let city: String
        let country: String
        let lat: Double
        let long: Double
        let region : String
        
        init(raw: [String]) {
            self.city = raw[1]
            self.country = raw[4]
            self.region = raw[7]
            self.lat = Double(raw[2].normalString()) ?? 0
            self.long = Double(raw[3].normalString()) ?? 0
        }
    }
    // MARK: - CohereClassification
    struct Classification: Codable {
        let id: String?
        let classifications: [ClassificationElement]?
        let meta: Meta?
    }

    // MARK: - ClassificationElement
    struct ClassificationElement: Codable {
        let classificationType: String?
        let confidence: Double?
        let confidences: [Double]?
        let id, input: String?
        let labels: Labels?
        let prediction: String?
        let predictions: [String]?

        enum CodingKeys: String, CodingKey {
            case classificationType = "classification_type"
            case confidence, confidences, id, input, labels, prediction, predictions
        }
    }

    // MARK: - Labels
    struct Labels: Codable {
        let cancellingCoverage, changeAccountSettings, filingAClaimAndViewingStatus, findingPolicyDetails: CancellingCoverage?

        enum CodingKeys: String, CodingKey {
            case cancellingCoverage = "Cancelling coverage"
            case changeAccountSettings = "Change account settings"
            case filingAClaimAndViewingStatus = "Filing a claim and viewing status"
            case findingPolicyDetails = "Finding policy details"
        }
    }

    // MARK: - CancellingCoverage
    struct CancellingCoverage: Codable {
        let confidence: Double?
    }

    enum CodingKeys: String, CodingKey {
        case cancellingCoverage = "Cancelling coverage"
        case changeAccountSettings = "Change account settings"
        case filingAClaimAndViewingStatus = "Filing a claim and viewing status"
        case findingPolicyDetails = "Finding policy details"
    }
    struct Generation: Codable {
        let id: String?
        let generations: [GenerationElement]?
        let prompt: String?
        let meta: Meta?
    }

    // MARK: - GenerationElement
    struct GenerationElement: Codable {
        let id, text, finishReason: String?

        enum CodingKeys: String, CodingKey {
            case id, text
            case finishReason = "finish_reason"
        }
    }

    // MARK: - Meta
    struct Meta: Codable {
        let apiVersion: APIVersion?

        enum CodingKeys: String, CodingKey {
            case apiVersion = "api_version"
        }
    }

    // MARK: - APIVersion
    struct APIVersion: Codable {
        let version: String?
    }
    struct Embedding: Codable {
        let id: String?
        let texts: [String]?
        let embeddings: [[Double]]?
        let meta: Meta?
    }
    struct Tokenize: Codable {
        let tokens: [Int]?
        let tokenStrings: [String]?
        let meta: Meta?

        enum CodingKeys: String, CodingKey {
            case tokens
            case tokenStrings = "token_strings"
            case meta
        }
    }
    struct Detokenize: Codable {
        let text: String?
        let meta: Meta?
    }
    struct DetectLanguage: Codable {
        let id: String?
        let results: [Result]?
        let meta: Meta?
    }
    struct Summarize: Codable {
        let id, summary: String?
        let meta: Meta?
    }
    struct Rerank: Codable {
        let id: String?
        let results: [Rankings]?
        let meta: Meta?
    }
    // MARK: - Result
    struct Rankings: Codable {
        let index: Int?
        let relevanceScore: Double?

        enum CodingKeys: String, CodingKey {
            case index
            case relevanceScore = "relevance_score"
        }
    }
}

