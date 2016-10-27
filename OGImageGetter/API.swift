//
//  API.swift
//  OGImageGetter
//
//  Created by hirokazu on 10/27/16.
//  Copyright © 2016 hirokazu. All rights reserved.
//

import Foundation

import Alamofire
import Kanna
import RxSwift

final class API {
    class func Get(url: String) -> Observable<String?> {
        return API.GetHtml(url: url).flatMapLatest { html in
            return API.GetOGImageURL(html: html)
        }
    }

    class func GetHtml(url: String) -> Observable<String> {
        return Observable<String>.create { observer in
            Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:])
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }

    class func GetOGImageURL(html: String) -> Observable<String?> {
        return Observable<String?>.create { observer in
            if let document = HTML(html: html, encoding: .utf8) {
                if let head = document.head {
                    if let meta = head.css("meta[property=og:image]").first {
                        observer.onNext(meta["content"])
                    } else {
                        observer.onNext(nil)
                    }
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
