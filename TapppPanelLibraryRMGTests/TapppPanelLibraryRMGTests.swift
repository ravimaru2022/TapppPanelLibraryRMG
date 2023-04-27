import XCTest
import TapppPanelLibraryRMG
import WebKit

final class TapppPanelLibraryRMGTests: XCTestCase{
    let objPanel = WebkitClass()
    private var subscriberArr = [String]()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialization() {
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        objPanelData[TapppContext.Sports.BOOK_ID] = "234"
        objPanelData[TapppContext.Request.POSITION] = "topRight"
        objPanelData[TapppContext.Environment.ENVIRONMENT] =  TapppContext.Environment.DEV
        objPanelData[TapppContext.Sports.BROADCASTER_NAME] =  TapppContext.Sports.NFL
        
        var frameWidth = [String : Any]()
        frameWidth[TapppContext.Request.UNIT] = "px"
        frameWidth[TapppContext.Request.VALUE] = "300"
        objPanelData[TapppContext.Request.WIDTH] = frameWidth
        gameInfo[TapppContext.Sports.Context] = objPanelData
        
        let objView = UIView()
        objPanel.initPanel(tapppContext: gameInfo, currView: objView)
        
        XCTAssertNotNil(objPanelData)
    }
    
    func testUsercontentController() {
        let contentController = objPanel.webView.configuration.userContentController
        
        let obj = WKScriptMessage()
        var test = [String : AnyObject]()
        test["message"] = "no data found" as AnyObject
        
        objPanel.userContentController(contentController, didReceive: obj)
    }
    
    func testWebKitdidFinish() {
        objPanel.webView(objPanel.webView, didFinish: nil)
    }
    
    func testStartProvisionalNavigation() {
        objPanel.webView(objPanel.webView, didStartProvisionalNavigation: nil)
    }
    
    func testFailProvisionalNavigation() {
        let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid access token"])
        objPanel.webView(objPanel.webView, didFailProvisionalNavigation: nil, withError: error)
    }
    
    func testExceptionHandleHTML() {
        objPanel.exceptionHandleHTML(errMsg: "Error Message to display")
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        objPanelData[TapppContext.Sports.BOOK_ID] = "234"
        objPanelData[TapppContext.Request.POSITION] = "topRight"
        var frameWidth = [String : Any]()
        frameWidth[TapppContext.Request.UNIT] = "px"
        frameWidth[TapppContext.Request.VALUE] = "300"
        objPanelData[TapppContext.Request.WIDTH] = frameWidth
        gameInfo[TapppContext.Sports.Context] = objPanelData
        
        let error_inst = self.validatePanelData(panelData: gameInfo)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
        
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testValidationParameters () throws {
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        objPanelData[TapppContext.Sports.BOOK_ID] = "234"
        objPanelData[TapppContext.Request.POSITION] = "topRight"
        gameInfo[TapppContext.Sports.Context] = objPanelData
        
        let objView = UIView()
        objPanel.checkPanelDataParam(panelData: gameInfo, currView: objView)
    }
    
    func testInvalidParameters() throws{
        var objPanelData = [String: Any]()
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        
        let objView = UIView()
        objPanel.checkPanelDataParam(panelData: objPanelData, currView: objView)
    }
    
    func testInvalidParametersNegative1() throws{
        var objPanelData = [String: Any]()
        let objView = UIView()
        objPanel.checkPanelDataParam(panelData: objPanelData, currView: objView)
    }
    
    func testInvalidParametersNegative2() throws{
        var objPanelData = [String: Any]()
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        objPanelData[TapppContext.Sports.BOOK_ID] = nil

        let objView = UIView()
        objPanel.checkPanelDataParam(panelData: objPanelData, currView: objView)
    }

    func testNilInputParameter1() throws{
        objPanel.checkNilInputParam(panelData: nil, currView: nil)
    }
    func testNilInputParameter2() throws{
        let objView = UIView()
        objPanel.checkNilInputParam(panelData: nil, currView: objView)
    }

    func testStartMethod() throws {
        objPanel.appURL = "https://sandbox-mlr.tappp.com/mobile/bundle.js"
        objPanel.startPanel()
    }
    
    func testStopMethod() throws {
        objPanel.stopPanel()
    }
    
    func testShowPanel() throws {
        objPanel.showPanel()
    }
    
    func testHidePanel() throws {
        objPanel.isPanelAvailable = true
        objPanel.hidePanel()
    }

    func testHidePanelFail() throws {
        objPanel.isPanelAvailable = false
        objPanel.hidePanel()
    }

    func testSubscriberMethod() throws {
        objPanel.subscribe(event: "testEvent") { obj in
            if obj.count > 0 {
                subscriberArr.append("testEvent")
                XCTAssertTrue(true, "Event Subscribed")
            } else {
                XCTAssertTrue(false, "Event not subscribed")
            }
        }
    }
    func testUnsubscribeMethod() throws {
        objPanel.unSubscribe(event: "testEvent") { obj in
            if obj.count > 0 {
                
                if let index = subscriberArr.firstIndex(of: "testEvent")
                {
                    subscriberArr.remove(at: index)
                }
                XCTAssertTrue(true, "Event unsubscribed")
            } else {
                XCTAssertTrue(true, "Event not unsubscribed")
            }
        }
    }
    
    func testLoadJSDataMethod () throws {
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        objPanelData[TapppContext.Sports.BOOK_ID] = "234"
        objPanelData[TapppContext.User.USER_ID] = "USR1234"
        objPanelData[TapppContext.Request.POSITION] = "topRight"
        var frameWidth = [String : Any]()
        frameWidth[TapppContext.Request.UNIT] = "px"
        frameWidth[TapppContext.Request.VALUE] = "300"
        objPanelData[TapppContext.Request.WIDTH] = frameWidth
        objPanelData[TapppContext.Sports.BROADCASTER_NAME] = "NFL"
        objPanelData[TapppContext.Environment.ENVIRONMENT] = TapppContext.Environment.DEV
        gameInfo[TapppContext.Sports.Context] = objPanelData
        
        objPanel.loadDataJS(objPanelData: gameInfo)
    }
    func testConst(){
        TapppContext.init()
    }
    
    func validatePanelData(panelData: [String: Any]) -> String {
        var gameInfo = [String : Any]()
        gameInfo = panelData[TapppContext.Sports.Context] as! [String : Any]
        
        var gameWidth = [String : Any]()
        if gameInfo.keys.contains(TapppContext.Request.WIDTH) {
            gameWidth = gameInfo[TapppContext.Request.WIDTH] as! [String : Any]
        }
        
        if panelData == nil  || panelData.count == 0 {
            return  "empty dictionary"
        } else if !panelData.keys.contains(TapppContext.Sports.Context) {
            return  "nil dictionary"
        } else if !gameInfo.keys.contains(TapppContext.Sports.GAME_ID) {
            return  "nil gameId"
        } else if !gameInfo.keys.contains(TapppContext.Sports.BOOK_ID) {
            return  "nil boookId"
        } else if !gameInfo.keys.contains(TapppContext.Request.POSITION) {
            return  "nil position"
        } else if !gameInfo.keys.contains(TapppContext.Request.WIDTH) {
            return "nil width dictionary"
        } else if !gameWidth.keys.contains(TapppContext.Request.VALUE) {
            return "nil value"
        } else if !gameWidth.keys.contains(TapppContext.Request.UNIT) {
            return "nil unit"
        }
        return ""
    }
    
    func testObjectNull(){
        var objPanelData = [String: Any]()
        if objPanelData == nil{
            XCTAssertTrue(false, "nil panel data")
        }
    }
    
    func testGameInfoNotFound(){
        var gameInfo = [String : Any]()
        gameInfo = ["" : ""]
        if gameInfo.count == 0{
            XCTAssertTrue(false, "Empty Game info")
        } else {
            XCTAssertTrue(true, "valid input")
        }
    }
    
    
    func testGameIdNotFound(){
        //var gameInfo = [String : Any]()
        var objPanelData = [String: Any]()
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        let error_inst = validateGameIdNil(gameId: objPanelData[TapppContext.Sports.GAME_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
        
    }
    func testGameIdEmpty(){
        var objPanelData = [String: Any]()
        objPanelData[TapppContext.Sports.GAME_ID] = "123"
        let error_inst = validateGameIdEmpty(gameId: objPanelData[TapppContext.Sports.GAME_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    func validateGameIdNil(gameId : String) -> String{
        if gameId != nil {
            return ""
        }
        return "failure"
    }
    func validateGameIdEmpty(gameId : String) -> String{
        if gameId.count > 0 {
            return ""
        }
        return "failure"
    }
    
    
    func testBookIdNotFound(){
        //var gameInfo = [String : Any]()
        var objPanelData = [String: Any]()
        objPanelData[TapppContext.Sports.BOOK_ID] = "123"
        let error_inst = validateBookIdNil(bookId: objPanelData[TapppContext.Sports.BOOK_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
        
    }
    func testBookIdEmpty(){
        var objPanelData = [String: Any]()
        objPanelData[TapppContext.Sports.BOOK_ID] = "123"
        let error_inst = validateBookIdEmpty(bookId: objPanelData[TapppContext.Sports.BOOK_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    func validateBookIdNil(bookId : String) -> String{
        if bookId != nil {
            return ""
        }
        return "failure"
    }
    func validateBookIdEmpty(bookId : String) -> String{
        if bookId.count > 0 {
            return ""
        }
        return "failure"
    }
    
    func testWidthNotFound(){
        var objPanelData = [String: Any]()
        var frameWidth = [String : Any]()
        frameWidth[TapppContext.Request.UNIT] = "px"
        frameWidth[TapppContext.Request.VALUE] = "300"
        objPanelData[TapppContext.Request.WIDTH] = frameWidth
        
        let error_inst = ""//validateWidthNil(width: objPanelData[Constants.request.width] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
        
    }
    func testWidthIsEmpty(){
        var objPanelData = [String: Any]()
        var frameWidth = [String : Any]()
        frameWidth[TapppContext.Request.UNIT] = "px"
        frameWidth[TapppContext.Request.VALUE] = "300"
        objPanelData[TapppContext.Request.WIDTH] = frameWidth
        let error_inst = ""//validateWidthEmpty(width: objPanelData[Constants.Request.width] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    
    func testHTMLFileExist (){
        let customBundle = Bundle(for: WebkitClass.self)
        guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("web-build.bundle") else { return }
        guard let resourceBundle = Bundle(url: resourceURL) else { return }
        guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
        
        XCTAssertNotNil(jsFileURL, "Index : html url nil")
    }
    
    func testHandleMessage (){
        let gameId = "123"
        let bookId = "345"
        let widthVal = "300"
        let broadcasterName = "NFL"
        let error_inst = self.validateHandleMessage(gameId: gameId, bookId: bookId, widthVal: widthVal, broadcasterName: broadcasterName)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    
    func validateHandleMessage(gameId: String?, bookId: String?, widthVal: String?,  broadcasterName: String?) -> String {
        
        if gameId == nil  || gameId?.count == 0 {
            return  "empty gameId"
        } else if bookId == nil  || bookId?.count == 0 {
            return  "empty bookId"
        } else if widthVal == nil  || widthVal?.count == 0 {
            return  "empty width"
        } else if broadcasterName == nil  || broadcasterName?.count == 0 {
            return  "empty broadcast"
        }
        return ""
    }
    func testGameAwards(){
        objPanel.getGameAwards(inputURL: "https://dev-betapi.tappp.com/gameplay-engine/awards")
    }
    
    func testRegisteryService(){
        let inputURL: String = String(format: "https://dev-betapi.tappp.com/registry-service/registry?broadcasterName=NFL&device=web&environment=dev&appVersion=1.1")

        objPanel.geRegistryServiceDetail(inputURL: inputURL, completion: { obj in
        })
    }
    
}
