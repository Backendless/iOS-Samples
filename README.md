iOS-Samples
===========

Contains sample projects demonstrating the usage of various Backendless API and functionality

======= ADDITIONAL SWIFT PROJECT SETTINGS: =======

    Set target's Build Settings -> "Swift Compiller - Code Generation" -> "Objective-C Bridging Header" option in:
    $(PROJECT_DIR)/../lib/backendless/include/Backendless-Bridging-Header.h

======= SWIFT DEMO CODE: =========================

    class Weather : BackendlessEntity {
    
        var temperature = 24.7
        var condition = "Very Nice"
    
        // description func
        func description() -> NSString {
            return "<Weather> " + condition + ":" + temperature.description
        }
    
    }
        
    // create Backendless instance
    var backendless = Backendless.sharedInstance();

    // - sync method with class instance/fault as return
    var result : AnyObject = backendless.persistenceService.save(Weather())
    if (result is Weather) {
        var obj : AnyObject = backendless.persistenceService.findById("Weather", sid:(result as Weather).objectId)
    }
    if (result is Fault) {
        var fault : Fault = result as Fault
        NSLog("FAULT")
    }

    // - sync method with fault as reference
    var fault : Fault?
    var weather : Weather = backendless.persistenceService.save(Weather(), error: &fault) as Weather
    if (fault == nil) {
        var obj : AnyObject = backendless.persistenceService.findById("Weather", sid: weather.objectId)
    }
    else {
        NSLog("FAULT")
    }

    // - async method with block-based callbacks
    backendless.persistenceService.save(
        Weather(),
        response: { (var result : AnyObject!) -> () in
            var obj : AnyObject = self.backendless.persistenceService.findById("Weather", sid: (result as Weather).objectId)
        },
        error: { (var fault : Fault!) -> () in
            NSLog("FAULT")
        }
    )

    // - save object as dictionary of properties
    var os = ["iOS":"Apple", "android":"Google"]
    var fault : Fault?
    var result = backendless.persistenceService.save("MobileOS", entity:os, error: &fault)

