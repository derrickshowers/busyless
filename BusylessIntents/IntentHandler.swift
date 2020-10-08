//
//  IntentHandler.swift
//  BusylessIntents
//
//  Created by Derrick Showers on 10/7/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Intents

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        return AddNewActivityIntentHandler()
    }

}
