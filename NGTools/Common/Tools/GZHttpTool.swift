//
//  GZNetWorkManager.swift
//

import UIKit
//import Alamofire
//import Reachability


//设置manager属性 (重要)
//var manager:SessionManager? = nil

//上传的图片的类型
enum UploadImgType {
    case HeadImg        //头像
    case IDNumber       //身份证
}


class GZHttpTool: NSObject {
    
//    var reachability = Reachability()!
//
//    /// 创建单例
//    static let shared:GZHttpTool = {
//
//        let instance = GZHttpTool()
//
//        //配置 , 通常默认即可
//        let config:URLSessionConfiguration = URLSessionConfiguration.default
//
//        //设置超时时间为60S
//        config.timeoutIntervalForRequest = 60
//        config.requestCachePolicy = .reloadIgnoringCacheData
//        //根据config创建manager
//        manager = SessionManager(configuration: config)
//        manager?.delegate.sessionDidReceiveChallenge = { session, challenge in
//            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//            var credential: URLCredential?
//
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                disposition = URLSession.AuthChallengeDisposition.useCredential
//                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//            } else {
//                if challenge.previousFailureCount > 0 {
//                    disposition = .cancelAuthenticationChallenge
//                } else {
//                    credential = manager?.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
//
//                    if credential != nil {
//                        disposition = .useCredential
//                    }
//                }
//            }
//            return (disposition, credential)
//        }
//
//        return instance
//    }()
//
//}
//
//
//// MARK: - 网络请求
//extension GZHttpTool{
//
//    func requestImage(method:Alamofire.HTTPMethod, URLString:String, parameters:[String:Any]?,completion:@escaping (_ value:Any)->()) {
//        //请求头
//        let requestHeader:HTTPHeaders = ["Content-Type": "application/json"];
//
//        manager?.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default,headers: requestHeader).responseData(completionHandler:{ (response) in
//
//           completion(response.result.value!)
//
//        })
//
//    }
//
//
//
//    func request(method:Alamofire.HTTPMethod, URLString:String, parameters:[String:Any]?,completion:@escaping (_ value:AnyObject)->()) {
//
//        //请求头
//        let requestHeader:HTTPHeaders = ["Content-Type": "application/json"];
//
//        manager?.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default,headers: requestHeader).responseJSON(completionHandler:{ (response) in
////            printLog(URLString)
////            printLog(parameters)
////            printLog(response)
//            debugPrint(response)
//            switch response.result.isSuccess{
//            case true:
//                let value = response.result.value as? [String:Any]
//                if value?["result"] as? Int == 100 {
//
//                    self.refreshToken(success: {
//
//                        completion("刷新token成功" as AnyObject)
//
//                    }, failure: {
//
//                        debugPrint("刷新token失败，重新登录")
//
//                        appDelegate.window?.rootViewController = NGOpaqueNavigationController(rootViewController: GZOauthViewController())
//
//                    })
//
//                }else {
//
//                    completion(response.result.value as AnyObject)
//
//                }
//            case false:
//                print(response.result.error ?? "false")
//            }
//
//        })
//    }
//
//
//
//
//    ///上传图片
//    func upload(data:Data?=nil,url:String,num:String?=nil,type:UploadImgType,closure:@escaping (_ progress:Progress)->(),completion:@escaping (_ isSuccess:Bool)->())  {
//
//        manager?.upload(multipartFormData: { (multipartFormData) in
//
//            switch type {
//            case .HeadImg:
//                if data != nil{
//                    multipartFormData.append(data!, withName: "file", fileName: "image.jpg", mimeType: "image/jpg")
//                }
//            case .IDNumber:
//                if data != nil{
//                    multipartFormData.append(data!, withName: "files", fileName: "image.jpg", mimeType: "image/jpg")
//                }
//            }
//
//            if num != nil {
//                multipartFormData.append(num!.data(using: String.Encoding.utf8)!, withName: "number")
//            }
//
//        }, to: url) { (encodingResult) in
//
//            print(encodingResult)
//
//            switch encodingResult {
//
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//
//                    closure(progress)
//
//                }).responseJSON(completionHandler: { (response) in
//
//
//
//                    guard let value = response.result.value as? [String:Any] else {
//                        completion(false)
//                        return
//                    }
//
//                    if value["result"] as? Int == 0 {
//                        completion(true)
//                    }else{
//                        completion(false)
//                    }
//
//                })
//
//            case .failure(let error):
//                debugPrint(error)
//                completion(false)
//            }
//        }
//
//    }
//
//
//    /// 刷新Token
//    func refreshToken(success:(()->())? = nil,failure:(()->())? = nil) {
//
//        let urlStr = baseURL + refreshTokenURL
//
//        var parameters = [String:Any]()
//
//        parameters["token"] = userDefault.object(forKey: appToken)
//
//        parameters["deviceId"] = idfv
//
//        parameters["version"] = currentVersion
//
//        parameters["os"] = "ios\(systemVersion)"
//
//        parameters["channel"] = channelName
//
//
//        request(method: .post, URLString: urlStr, parameters: parameters) { (response) in
//
//            if response["result"] as? Int == 1000 {
//
//                failure?()
//
//            }else if response["result"] as? Int == 0 {
//
//                guard let message = response["message"] as? [String:Any] else {
//                    return
//                }
//
//                let token = message["token"]
//
//                userDefault.set(token, forKey: appToken)
//
//                userDefault.synchronize()
//
//                success?()
//
//            }
//
//        }
//    }
//
//
//    //签约或取消签约
//    func signingRequest(parameters: [String:Any],completion:@escaping (_ response:AnyObject)->()) {
//        let urlStr = baseURL + signingURL
//
//        GZHttpTool.shared.request(method: .post, URLString: urlStr, parameters: parameters, completion: { (response) in
//            completion(response)
//        })
//
//    }
//
//
//    //消息中心获取消息
//    func messageCenter(completion:@escaping (_ message:[[String:Any]])->()) {
//
//        guard let messageTime = userDefault.object(forKey: appMessageCenter) as? String else {
//            return
//        }
//
//        let urlStr = baseURL + queryMessageURL + messageTime
//
//        request(method: .get,URLString: urlStr, parameters: nil) { (response) in
//
//            if response["result"] as? Int == 0 {
//
//                guard let messageArr = response["message"] as? [[String:Any]] else {
//                    return
//                }
//
//                completion(messageArr)
//            }
//
//        }
//
//    }
//
//    //已读或删除消息
//    func readOrDeleteMessage(messageId:Int,type:Int,completion:@escaping ()->()) {
//        let urlStr = baseURL + disposeMessageURL
//
//        let parameters = ["messageId":messageId,"type":type]
//
//        request(method: .post, URLString: urlStr, parameters: parameters) { (response) in
//            if response["result"] as? Int == 0 {
//                completion()
//            }
//        }
//    }
//
//    //退出登录
//    func loginOut() {
//        let urlStr = baseURL + logoutURL
//        request(method: .get, URLString: urlStr, parameters: nil) { (response) in
//            debugPrint(response)
//        }
//
//    }
//
//    //还款信息
//    func refundAccount(completion:@escaping (_ response:AnyObject)->()) {
//
//        let urlStr = baseURL + refundAccountURL
//
//        request(method: .get, URLString: urlStr, parameters: nil) { (response) in
//            completion(response)
//        }
//
//
//    }
//
//
//    //上报锁定
//    func reportLock(completion:@escaping (_ lockTime:String)->()) {
//
//        let urlStr = baseURL + reportLockURL
//
//        request(method: .post, URLString: urlStr, parameters: nil) { (response) in
//            guard let result = response["result"] as? Int else {
//                return
//            }
//            if result == 10011 {
//
//                let lockTime = Date(timeIntervalSinceNow: 24*60*60)
//
//                let df = DateFormatter()
//
//                df.dateFormat = "yyyy-MM-dd HH:00:00"
//
//                let lockTimeStr = df.string(from: lockTime)
//
//                completion(lockTimeStr)
//
//            }
//
//        }
//
//
//    }
//
//
//}
//
//
//// MARK: - 监测网络状态
//extension GZHttpTool{
//
//    ///判断网络是否可用
//    func isNetworkReachable() -> Bool {
//
//        if reachability.isReachable {
//            return true
//        } else {
//            return false
//        }
//    }
//
//
//    /// 开始监听网络
//    func startMonitoring(available:@escaping ()->(),disabled:@escaping ()->()) {
//
//        //网络可用
//        reachability.whenReachable = { reachability in
//            DispatchQueue.main.async {
//
//                available()
//
//            }
//        }
//        //网络不可用
//        reachability.whenUnreachable = { reachability in
//
//            DispatchQueue.main.async{
//                disabled()
//            }
//        }
//
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//    }
//
//
//    func stopMonitoring() {
//
//        reachability.stopNotifier()
//    }
    
    
}






