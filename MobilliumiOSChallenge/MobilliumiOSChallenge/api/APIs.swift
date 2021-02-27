//
//  APIs.swift
//  MobilliumiOSChallenge
//
//  Created by Hakan UNAL on 27.02.2021.
//

import Foundation

open class ClientAPI {
    public static var basePath = "https://api.themoviedb.org"
    public static var credential: URLCredential?
    public static var customHeaders: [String:String] = [
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMTJlZDU1MDg3OTdlNWU5NTdkMGM2MDY4MjUwMDFjNiIsInN1YiI6IjViNmQ3YzgzMGUwYTI2N2VmNDE0YTkzZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9C_IbGJVAzaI0fNVH-Wg8LyH-VQQzwoVfFikHiozOIs"
    ]
    public static var requestBuilderFactory: RequestBuilderFactory = AlamofireRequestBuilderFactory()
}

open class RequestBuilder<T> {
    var credential: URLCredential?
    var headers: [String:String]
    public let parameters: [String:Any]?
    public let isBody: Bool
    public let method: String
    public let URLString: String

    public var onProgressReady: ((Progress) -> ())?

    required public init(method: String, URLString: String, parameters: [String:Any]?, isBody: Bool, headers: [String:String] = [:]) {
        self.method = method
        self.URLString = URLString
        self.parameters = parameters
        self.isBody = isBody
        self.headers = headers

        addHeaders(ClientAPI.customHeaders)
    }

    open func addHeaders(_ aHeaders:[String:String]) {
        for (header, value) in aHeaders {
            headers[header] = value
        }
    }

    open func execute(_ completion: @escaping (_ response: Response<T>?, _ error: Error?) -> Void) { }

    public func addHeader(name: String, value: String) -> Self {
        if !value.isEmpty {
            headers[name] = value
        }
        return self
    }

    open func addCredential() -> Self {
        self.credential = ClientAPI.credential
        return self
    }
}

public protocol RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type
    func getBuilder<T:Decodable>() -> RequestBuilder<T>.Type
}
