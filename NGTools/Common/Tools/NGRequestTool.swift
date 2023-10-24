//
//  NGRequestTool.swift
//

import UIKit
//import Alamofire
//import SVProgressHUD


let AppLoanProductId = "22"

class NGRequestTool {
    
//    fileprivate var manager:SessionManager?
//    static let shared = NGRequestTool()
//
//    private init() {
//
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 60
//        config.requestCachePolicy = .reloadIgnoringLocalCacheData
//
//        let mgr = SessionManager(configuration: config)
//        manager = mgr
//
//        //        mgr.delegate.sessionDidReceiveChallenge = { session, challenge in
//        //            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//        //            var credential: URLCredential?
//        //
//        //            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//        //                disposition = URLSession.AuthChallengeDisposition.useCredential
//        //                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//        //            } else {
//        //                if challenge.previousFailureCount > 0 {
//        //                    disposition = .cancelAuthenticationChallenge
//        //                } else {
//        //                    credential = mgr.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
//        //
//        //                    if credential != nil {
//        //                        disposition = .useCredential
//        //                    }
//        //                }
//        //            }
//        //            return (disposition, credential)
//        //        }
//
//    }
//
//}
//
//
//extension NGRequestTool{
//
//    func someFunctionWithNonescapingClosure(closure: () -> Void) {
//        closure()
//    }
//
//    func request(method:Alamofire.HTTPMethod, suffixUrl:String, parameters:[String:Any]?,succeed:@escaping (_ value: AnyObject)->(), failed:((_ value:String)->())?) {
//
//        let urlString = PreUrl + suffixUrl
//        //请求头
//        let requestHeader:HTTPHeaders = ["Content-Type": "application/json"];
//
//        manager?.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default,headers: requestHeader).responseJSON(completionHandler:{ (response) in
//            //            printLog(URLString)
//            printLog(parameters)
//            //            printLog(response)
//            debugPrint(response)
//            switch response.result.isSuccess{
//            case true:
//                let value = response.result.value as? [String:Any]
//                if value?["result"] as? Int == 100 {
//                    self.refreshToken()
//                }else {
//                    guard let result = value?["result"] as? Int else{
//                        return
//                    }
//                    if result == 0 {
//                        if let responeResult = response.result.value as? [String: AnyObject],
//                            let callResult = responeResult["message"]
//                        {
//                            succeed(callResult)
//                        }
//                    }else {
//                        if let message = value?["message"] as? String{
//                            guard let fail = failed else {
//                                SVProgressHUD.show(nil, status: message)
//                                return
//                            }
//                            fail(message)
//                        }
//                    }
//                }
//            case false:
//                if let message =  response.result.error?.localizedDescription{
//                    guard let fail = failed else {
//                        printLog(message)
//                        SVProgressHUD.show(nil, status: message)
//                        return
//                    }
//                    fail(message)
//                }
//            }
//
//        })
//    }
//
//
//    func request(method:Alamofire.HTTPMethod, url:String, timeOutInterval:TimeInterval, parameters:[String:Any]?,succeed:@escaping (_ value: AnyObject)->(), failed:((_ value:String)->())?)->SessionManager {
//
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = timeOutInterval
//        config.requestCachePolicy = .reloadIgnoringLocalCacheData
//
//        let mgr = SessionManager(configuration: config)
//
//        //请求头
//        let requestHeader:HTTPHeaders = ["Content-Type": "application/json"];
//
//        mgr.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default,headers: requestHeader).responseJSON(completionHandler:{ (response) in
//            //            printLog(URLString)
//            printLog(parameters)
//            //            printLog(response)
//            debugPrint(response)
//            switch response.result.isSuccess{
//            case true:
//                let value = response.result.value as? [String:Any]
//                if value?["result"] as? Int == 100 {
//                    self.refreshToken()
//                }else {
//                    if value?["result"] as? Int == 0
//                    {
//                        if let responeResult = response.result.value as? [String: AnyObject],
//                            let callResult = responeResult["message"]{
//                            succeed(callResult)
//                        }else {
//                            succeed(NSNumber(value: 1))
//                        }
//                    }else {
//                        if let message = value?["message"] as? String{
//                            guard let fail = failed else {
//                                SVProgressHUD.show(nil, status: message)
//                                return
//                            }
//                            fail(message)
//                        }
//                    }
//                }
//            case false:
//                if let message =  response.result.error?.localizedDescription{
//                    guard let fail = failed else {
//                        printLog(message)
//                        SVProgressHUD.show(nil, status: message)
//                        return
//                    }
//                    fail(message)
//                }
//            }
//
//        })
//
//        return mgr
//    }
//
//
//
//    /// 刷新Token
//    func refreshToken() {
//        let urlStr = PreUrl + "user/refreshToken"
//        var parameters = [String:Any]()
//        parameters["token"] = userDefault.object(forKey: appToken)
//        parameters["deviceId"] = idfv
//        parameters["version"] = currentVersion
//        parameters["os"] = "ios\(systemVersion)"
//        parameters["channel"] = channelName
//
//
//        //请求头
//        let requestHeader:HTTPHeaders = ["Content-Type": "application/json"];
//
//        manager?.request(urlStr, method: .put, parameters: parameters, encoding: JSONEncoding.default,headers: requestHeader).responseJSON(completionHandler:{ (response) in
//            debugPrint(response)
//            switch response.result.isSuccess{
//            case true:
//                let value = response.result.value as? [String:Any]
//                if value?["result"] as? Int == 1000 {
//                    appDelegate.window?.rootViewController = NGOpaqueNavigationController(rootViewController: GZOauthViewController())
//
//                }else if value?["result"] as? Int == 0{
//                    guard let message = value?["message"] as? [String:Any] else {
//                        return
//                    }
//                    let token = message["token"]
//                    userDefault.set(token, forKey: appToken)
//                    userDefault.synchronize()
//                }
//            case false:
//                printLog(response.result.error?.localizedDescription)
//            }
//
//        })
//    }
//}
//
//
//extension NGRequestTool{
//    func upLoadImage(_ imageData:Data, call:@escaping (_ uploadUrl:String)->()){
//        let urlStr = PreUrl + "user/dataUploadOne3"
//
//        SVProgressHUD.show(withStatus: "图片上传中...")
//        manager?.upload(multipartFormData: { (mdata) in
//            mdata.append(imageData, withName: "files", fileName: "image.jpg", mimeType: "image/jpg")
//            mdata.append("1".data(using: String.Encoding.utf8)!, withName: "number")
//        }, to: urlStr, encodingCompletion: { (result) in
//            printLog(result)
//
//            switch result {
//            case .success(let upload, _, _):
//                upload.uploadProgress(closure: { (_) in
//                }).responseJSON(completionHandler: { (response) in
//
//                    SVProgressHUD.dismiss()
//                    printLog(response)
//
//                    guard let value = response.result.value as? [String:Any] else {
//                        return
//                    }
//
//                    if value["result"] as? Int == 0{
//                        if let message = value["message"] as? [String:Any],
//                            let url = message["url"] as? String{
//                            call(url)
//                        }
//                    }
//                    else{
//                        SVProgressHUD.show(nil, status: value["message"] as? String ?? "Failed")
//                    }
//
//                })
//
//            case .failure(let error):
//                SVProgressHUD.dismiss()
//                SVProgressHUD.show(nil, status: error.localizedDescription)
//            }
//        })
//    }
}
