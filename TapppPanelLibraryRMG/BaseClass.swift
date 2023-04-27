import Foundation
import UIKit

public class BaseClass: NSObject {
    var frameUnit = ""
    var objectPanelData = [String: Any]()
    public var appURL = ""
    var btnInfo = UIButton()
}

// MARK - Data Validations
extension BaseClass {
    public func checkNilInputParam(panelData: [String: Any]?, currView: UIView?) -> Bool {
        if currView == nil {
            return false
        }
        if panelData == nil {
            return false
        }
        return true
    }
    
    public func checkPanelDataParam(panelData: [String: Any]?, currView: UIView?)-> ValidationState {
        var internalPaneldata = [String : Any]()
        
        if let pData = panelData?[TapppContext.Sports.Context] as? [String: Any] {
            internalPaneldata = pData
        } else {
            return .invalid(TapppContext.errorMessage.GAMEINFO_OBJECT_NOT_FOUND)
        }
        
        if let gId = internalPaneldata[TapppContext.Sports.GAME_ID] as? String{
            if gId.count > 0 {
            } else {
                return .invalid(TapppContext.errorMessage.GAMEID_NULL_EMPTY)
            }
        } else {
            return .invalid(TapppContext.errorMessage.GAMEID_NOT_FOUND)
        }
        if let bId = internalPaneldata[TapppContext.Sports.BOOK_ID] as? String{
            if bId.count > 0 {
            } else {
                self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NULL_EMPTY)
                internalPaneldata[TapppContext.Sports.BOOK_ID] = "1000009"
            }
        } else {
            self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NOT_FOUND)
            internalPaneldata[TapppContext.Sports.BOOK_ID] = "1000009"
        }
        if let env = internalPaneldata[TapppContext.Environment.ENVIRONMENT] as? String{
            if env.count == 0 {
                internalPaneldata[TapppContext.Environment.ENVIRONMENT] = TapppContext.Environment.DEV
            }
        } else {
            internalPaneldata[TapppContext.Environment.ENVIRONMENT] = TapppContext.Environment.DEV
        }
        //objPanelData[TapppContext.Environment.ENVIRONMENT] = TapppContext.Environment.DEV
        if let widthInfo = internalPaneldata[TapppContext.Request.WIDTH] as? [String: Any]{
            if let unit = widthInfo[TapppContext.Request.UNIT] as? String, unit.count > 0{
                frameUnit = unit
            } else {
                frameUnit = TapppContext.Request.UNIT_VAL
            }
            if let val = widthInfo[TapppContext.Request.VALUE] as? String, val.count > 0 {
                print("From reference app val", val)
            } else {
                var widthInfoUD = [String : Any]()
                widthInfoUD[TapppContext.Request.UNIT] = "px"
                widthInfoUD[TapppContext.Request.VALUE] = "\(currView?.frame.width ?? 0)"
                internalPaneldata[TapppContext.Request.WIDTH] = widthInfoUD
            }
        } else {
            var widthInfoUD = [String : Any]()
            widthInfoUD[TapppContext.Request.UNIT] = "px"
            widthInfoUD[TapppContext.Request.VALUE] = "\(currView?.frame.width ?? 0)"
            internalPaneldata[TapppContext.Request.WIDTH] = widthInfoUD
        }
        
        objectPanelData[TapppContext.Sports.Context] = internalPaneldata
        return .valid
    }
    
    public func exceptionHandleHTML(errMsg: String){
        //FIXME: need to setup for duplicate width key.
    }
}


// MARK - GraphQL APIs.
extension BaseClass {
    public func getGameAwards(inputURL: String){
        let url = URL(string:inputURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let status = json?["code"] as? Int, status == 200 {
                        if let urlDict = json?["data"] as? [[String: Any]], let urlAddr = urlDict.first{
                            print(urlAddr)
                            //self.playVideo()
                        }
                    }
                } catch {
                    print(error)
                }
                //let image = UIImage(data: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
    public func geRegistryServiceDetail(inputURL: String, completion: @escaping (String?)->Void) {
        let url = URL(string:inputURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let status = json?["code"] as? Int, status == 200 {
                        if let urlDict = json?["data"] as? [[String: Any]], let urlAddr = urlDict.first{
                            let appDict = urlAddr["appInfo"] as? [String: Any]
                            let microAppList = appDict?["microAppList"]as? [[String:Any]]
                            

                            let iconURL = appDict?["iconMinimize"] as? String
                            if !iconURL!.isEmpty{
                                self.setImageFromStringrURL(stringUrl: iconURL!)
                            }

                            if let chanelList = microAppList?.first?["chanelList"] as? [[String:Any]]
                            {
                                print(chanelList)
                                for obj in chanelList{
                                    if obj["chanelName"] as! String == "smartApp"{ // webApp , smartApp
                                        print(obj["appURL"])
                                        completion(obj["appURL"] as! String)
                                    }
                                    
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
                //let image = UIImage(data: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
        
    }
    
    func setImageFromStringrURL(stringUrl: String) {
        if let url = URL(string: stringUrl) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          // Error handling...
          guard let imageData = data else { return }

          DispatchQueue.main.async {
              self.btnInfo.setImage(UIImage(data: imageData), for: .normal)
          }
        }.resume()
      }
    }

}
