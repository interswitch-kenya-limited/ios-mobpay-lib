//
//  3dsfunctions.swift
//  mobpay-ios
//
//  Created by Allan Mageto on 25/06/2019.
//  Copyright © 2019 Allan Mageto. All rights reserved.
//

import Foundation
import CardinalMobile



public class ThreeDsFunctions{
    
    var session : CardinalSession!
    
    func setupCardinalSession(){
        session = CardinalSession()
        let config = CardinalSessionConfig()
        config.deploymentEnvironment = .production
        config.timeout = 8000
        config.uiType = .both
        
        let yourCustomUi = UiCustomization()
        //Set various customizations here. See "iOS UI Customization" documentation for detail.
        config.uiCustomization = yourCustomUi
        
        config.renderType = [CardinalSessionRenderTypeOTP, CardinalSessionRenderTypeHTML]
        config.enableQuickAuth = true
        session.configure(config)
    }
}
