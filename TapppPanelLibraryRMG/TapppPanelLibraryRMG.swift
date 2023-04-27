import Foundation
import WebKit
//import Sentry

public protocol alertDelegate: class {
    func myVCDidFinish( text: String)
}
public protocol hidePanelView{
    func hidePanelfromLibrary()
}

public enum ValidationState {
    case valid
    case invalid(String)
}

@objc(WebkitClass)
public class WebkitClass: BaseClass {
    
    public lazy var webView = WKWebView()
    public var delegate: alertDelegate?
    public var delegateHide: hidePanelView?

    private var sportsbook = ""
    private var subscriberArr = [String]()
    var view = UIView()
    
    var jsonString = String()
    public var isPanelAvailable = false

    
    override public init() {}
    @objc
    public func initPanel(tapppContext: [String: Any], currView: UIView) {
        
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if checkNilInputParam(panelData: tapppContext, currView: currView) {
            switch checkPanelDataParam(panelData: tapppContext, currView: currView){
            case .valid:
                let contentController = self.webView.configuration.userContentController
                contentController.add(self, name: "toggleMessageHandler")
                contentController.add(self, name: "showPanelData")
                view = currView

                guard let dict = objectPanelData[TapppContext.Sports.Context] as? [String:Any] else {
                    return
                }
                
                
                guard let broadcasterName = dict[TapppContext.Sports.BROADCASTER_NAME] as? String  else {
                    return
                }
                
                guard let environment = dict[TapppContext.Environment.ENVIRONMENT] as? String  else {
                    return
                }

                let inputURL: String = String(format: "https://registry.tappp.com/appInfo?broadcasterName=%@&device=web&environment=%@&appVersion=1.1", broadcasterName, environment)
                self.geRegistryServiceDetail(inputURL: inputURL) { responseURL in
                    self.appURL = responseURL!
                }
            case .invalid(let err):
                self.exceptionHandleHTML(errMsg: err)
                
                let error = NSError(domain: "MethodName: init : \(err) \(tapppContext.description)" , code: 0, userInfo: nil)
            }
        } else {
            let error = NSError(domain: "Nil Input parameter in init." , code: 0, userInfo: nil)
        }
        
        btnInfo = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 30, width: 50, height: 50))
        btnInfo.clipsToBounds = true
        btnInfo.contentMode = .scaleAspectFill
        btnInfo.isHidden = true
        btnInfo.addTarget(self,
                         action: #selector(buttonAction),
                         for: .touchUpInside)
        btnInfo.translatesAutoresizingMaskIntoConstraints = true
        btnInfo.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        self.view.addSubview(btnInfo)

        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
    
    @objc func orientationChanged(notification : NSNotification) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let device = notification.object as! UIDevice
            let deviceOrientation = device.orientation
            switch deviceOrientation {
            case .landscapeLeft, .landscapeRight:
                UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
                self.btnInfo.isHidden = true
                self.webView.isHidden = false
            case .portrait, .portraitUpsideDown:
                self.btnInfo.isHidden = false
                self.webView.isHidden = true
            case .faceUp, .faceDown:
                print("faceup facedown state")
            case .unknown:         //handle unknown
                print("Unknown state")
            @unknown default: break      //handle unknown default
            }
        }
    }


    @objc
    func buttonAction() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "For best experience switch to landscape mode.", style: .default) { action -> Void in
            print("First Action pressed")
        }
        //let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel) { action -> Void in }
        actionSheetController.addAction(firstAction)
        actionSheetController.view.layer.masksToBounds = true
        actionSheetController.view.layer.cornerRadius = 30
        let subview = actionSheetController.view.subviews.first! as UIView
        //let alertContentView = subview.subviews.first! as UIView
        if let firstSubview = actionSheetController.view.subviews.first, let alertContentView = firstSubview.subviews.first {
            for view in alertContentView.subviews {
                view.backgroundColor = UIColor(red: 42/255, green: 74/255, blue: 217/255, alpha: 1.0)
            }
        }
        
        actionSheetController.view.tintColor = .white
        actionSheetController.popoverPresentationController?.sourceView = webView // works for both iPhone & iPad
        UIApplication.shared.delegate?.window??.rootViewController?.present(actionSheetController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
            UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc
    public func startPanel(){
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.appURL.count > 0 {
                timer.invalidate()
                self.view.addSubview(self.webView)
                NSLayoutConstraint.activate([
                    self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    self.webView.topAnchor.constraint(equalTo: self.view.topAnchor)
                ])
                
                self.webView.navigationDelegate = self
                
                self.webView.backgroundColor = UIColor.clear
                self.webView.isOpaque = false
                
                let customBundle = Bundle(for: WebkitClass.self)
                guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("dist.bundle") else { return }
                guard let resourceBundle = Bundle(url: resourceURL) else { return }
                guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
                
                self.webView.loadFileURL(jsFileURL, allowingReadAccessTo: jsFileURL.deletingLastPathComponent())

                self.isPanelAvailable = true
                self.webView.configuration.preferences.javaScriptEnabled = true
            }
        }
    }
        
    public func loadDataJS (objPanelData : [String: Any]){
        guard let dict = objPanelData[TapppContext.Sports.Context] as? [String:Any] else {
            return
        }
        
        guard let widthDict = dict[TapppContext.Request.WIDTH] as? [String:Any] else {
            return
        }
        guard let broadcasterName = dict[TapppContext.Sports.BROADCASTER_NAME] as? String  else {
            return
        }
        let widthVal = widthDict[TapppContext.Request.VALUE] as! String
        let gameId = dict[TapppContext.Sports.GAME_ID] as! String
        let bookId = dict[TapppContext.Sports.BOOK_ID] as! String
        let userId = dict[TapppContext.User.USER_ID] as! String
        self.webView.evaluateJavaScript("handleMessage('\(gameId)', '\(bookId)', '\(widthVal)', '\(broadcasterName)', '\(userId)', '\(frameUnit)', '\(appURL)', '\(TapppContext.CURRENT_DEVICE)');", completionHandler: { result, error in
            if let val = result as? String {
                //                print(val)
            }
            else {
                //                print("result is NIL")
            }
        });
    }
    
    public func subscribe(event: String, completion: (String)->()){
        subscriberArr.append(event)
        completion("subscriber configured")
    }
    public func unSubscribe(event: String, completion: (String)->()){
        
        if let index = subscriberArr.firstIndex(of: event)
        {
            subscriberArr.remove(at: index)
        }
        completion("unSubscriber configured")
    }
    
    
    public func stopPanel(){
        if #available(iOS 14.0, *) {
            webView.configuration.userContentController.removeAllScriptMessageHandlers()
        } else {
            // Fallback on earlier versions
        }
        webView.removeFromSuperview()
    }
    // conditional code based on API.
    public func showPanel(){
        self.startPanel()
    }
    public func hidePanel(){
        if isPanelAvailable {
            isPanelAvailable = false
            delegateHide?.hidePanelfromLibrary()
        } else {
            let error = NSError(domain: "Error in hide panel. Trying to hide invisible panel." , code: 0, userInfo: nil)
            //SentrySDK.capture(error: error)
        }
    }
}

extension WebkitClass: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }
        
        if message.name == "toggleMessageHandler", let dict = message.body as? NSDictionary {
            let userName = dict["message"] as! String
            if subscriberArr.contains(where: {$0 == "toastDisplay"}){
                delegate?.myVCDidFinish(text: userName)
            }
        } else if message.name == "showPanelData"{
            
        }
    }
}

extension WebkitClass: WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadDataJS(objPanelData: self.objectPanelData)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let error = NSError(domain: "Webview failed loading \(error.localizedDescription)" , code: 0, userInfo: nil)
        //SentrySDK.capture(error: error)
    }
}
