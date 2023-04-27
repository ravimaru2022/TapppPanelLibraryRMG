<<<<<<<< HEAD:ios-swift-tappp-panel-library/TapppPanelLibrary/Constants.swift
//
//  TapppContext.swift
//  TapppPanelLibrary
//
//  Created by MA-15 on 03/02/23.
//

========
>>>>>>>> 1955ef0e94706609b27517f27450800589b25c2c:ios-swift-tappp-panel-library/TapppPanelLibrary/TapppContext.swift
import Foundation
import UIKit

public class TapppContext {
    
    public static let CURRENT_DEVICE                             =      UIDevice.current.name
    public static let CURRENTDEVICE_SIZE                         =      UIScreen.main.bounds.size
    public static let CURRENT_OS_VERSION                         =      UIDevice.current.systemVersion
    public static let USERDEFAULTS                               =      UserDefaults.standard
    public static let GLOBAL_LANG                                =      "en"
    public static let GLOBAL_POSITION                            =      "topRight"
    
    public init() {}
    
    public struct  request {
        public static let GAME_INFO = "gameInfo"
        public static let WIDTH = "width"
        public static let VALUE = "value"
        public static let BOOK_ID = "bookId"
        public static let GAME_ID = "gameId"
        public static let BROADCASTER_NAME = "broadcasterName"
        public static let LANGUAGE = "lang"

        public static let CONTEST_ID = "contest_id"
        public static let OFFER_ID = "offer_id"
        public static let OUTCOME_ID = "outcome_id"
        public static let USER_ID = "user_id"

        public static let POSITION = "position"
        public static let UNIT = "unit"
        public static let PANELMULTIPLIER = "panelSizeMultiplier"
<<<<<<<< HEAD:ios-swift-tappp-panel-library/TapppPanelLibrary/Constants.swift
========
        public static let TRN = "TRN"
        public static let NFL = "NFL"
>>>>>>>> 1955ef0e94706609b27517f27450800589b25c2c:ios-swift-tappp-panel-library/TapppPanelLibrary/TapppContext.swift
    }
    
    public struct errorMessage {
        public static let GAMESETTING_OBJECT_NOT_FOUND = "Panel Settings not found"
        public static let PANEL_INFO_OBJECT_NOT_FOUND = "Panel Data not found"
        public static let GAMEINFO_OBJECT_NOT_FOUND = "GameInfo object not found"
        public static let GAMEID_NOT_FOUND = "GameId not found"
        public static let GAMEID_NULL_EMPTY = "GameId null or empty"
        public static let BOOKID_NOT_FOUND = "BookId not found"
        public static let BOOKID_NULL_EMPTY = "BookId null or empty"
        public static let WIDTH_OBJECT_NOT_FOUND = "Width object not found"
        public static let WIDTH_IS_ZERO = "Width value is zero(0)"
    }
    
    
}


