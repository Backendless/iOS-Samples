//
//  ViewController.swift
//  PersistanceService
/*
* *********************************************************************************************************************
*
*  BACKENDLESS.COM CONFIDENTIAL
*
*  ********************************************************************************************************************
*
*  Copyright 2014 BACKENDLESS.COM. All Rights Reserved.
*
*  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
*  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
*  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
*  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
*  unless prior written permission is obtained from Backendless.com.
*
*  ********************************************************************************************************************
*/

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = ""
    let SECRET_KEY = ""
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //DebLog.setIsActive(true)
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        //backendless.messaging.notificationTypes = .Alert.rawValue | .Sound.rawValue
        
        /*
        let deliveryOptions = DeliveryOptions()
        deliveryOptions.pushBroadcast(FOR_ANDROID.rawValue|FOR_IOS.rawValue)
        print("deliveryOptions (1) -> \(deliveryOptions)")
        deliveryOptions.pushBroadcast(FOR_ALL.rawValue)
        print("deliveryOptions (2) -> \(deliveryOptions)")
        print("deliveryOptions props -> \(Types.propertyDictionary(deliveryOptions))")
        
        let subscriptionOptions = SubscriptionOptions()
        subscriptionOptions.deliveryMethod(DELIVERY_POLL)
        print("subscriptionOptions = \(subscriptionOptions)")
        */
        
        // -------------- PersistenceService -------------------------------
        //testPersistenceService()
        
        // --------------- UserService -------------------------------------
        //userLoginSync()
        //validUserTokenSync()
        //validUserTokenAsync()
        
        // ------------ Data & Geo -----------------------------------------
        //linkingDataObjectWithGeoPoints()
        //linkingGeoPointWithDataObject()
        //linkingGeoPointWithSeveralDataObjects()
        
        // ------------ Geo -----------------------------------------
        //clusteringSearchInCategory()
        //clusteringSearchInRadius()
        //clusteringSearchInRectangularArea()
        
        //loadingGeoPointMetadata()
        //loadingGeoClusterMetadata()
        
        //searchingDataObjectByDistance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userLoginSync() {
        
        // - sync methods with fault as exception (full "try/catch/finally" version)
        Types.tryblock({ () -> Void in
            
            // - user login
            let user = self.backendless.userService.login("bob@foo.com", password:"bob")
            NSLog("LOGINED USER: %@", user.description)
            
            /*
            // - user update
            var counter: AnyObject! = user.getProperty("counter")
            user.setProperty("counter", object: counter)
            user = self.backendless.userService.update(user)
            NSLog("UPDATED USER: %@", user.description)
            */
            
            },
            
            catchblock: { (exception) -> Void in
                NSLog("FAULT: %@", exception as! Fault)
            },
            
            finally: { () -> Void in
                NSLog("USER OPERATIONS ARE FINISHED")
            }
        )
    }
    
    func validUserTokenSync() {
        
        Types.tryblock({ () -> Void in
            
            let result = self.backendless.userService.isValidUserToken() //as NSNumber
            print("isValidUserToken (SYNC): \(result.boolValue)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func validUserTokenAsync() {
        
        backendless.userService.isValidUserToken(
            { ( result : AnyObject!) -> () in
                print("isValidUserToken (ASYNC): \(result.boolValue)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
    func testPersistenceService() {
        
        // - sync methods with fault as exception (short "try/catch" version)
        Types.tryblock({ () -> Void in
            
            let obj = PersistentObjectQB()
            let result : AnyObject? = self.backendless.persistenceService.save(obj)
            NSLog("PersistentObjectQB: %@", (result as! PersistentObjectQB).description)
            
            },
            
            catchblock: { (exception) -> Void in
                NSLog("FAULT: %@", exception as! Fault)
            }
        )
        
        
        // - shut off the fault as exception
        backendless.setThrowException(false)
        
        var result : AnyObject
        var fault : Fault?
        
        // - sync method with fault as reference (fault as exception should be shutted off !)
        let item : AnyObject? = backendless.persistenceService.save(OrderItem(), error: &fault)
        if (fault == nil) {
            let obj : AnyObject = backendless.persistenceService.findById("OrderItem", sid: (item as! OrderItem).objectId)
            if (obj is OrderItem) {
                print("OrderItem: \((obj as! OrderItem).itemName) <\((obj as! OrderItem).objectId)>")
            }
            else {
                print("\nFAULT (0): \(fault!.description)")
            }
        }
        else {
            print("\nFAULT (0): \(fault!.description)")
        }
        
        /* - sorting for the selected columns (ascending and descending)
        
        NSLog(" ------------------ TEST: sorting for the selected columns ---------------------------------")
        
        var query1 : QueryOptions = QueryOptions()
        query1.sortBy = ["name", "objectId"]
        var dataQuery1 : BackendlessDataQuery = BackendlessDataQuery()
        dataQuery1.queryOptions = query1
        
        result = backendless.persistenceService.find(Order().ofClass(), dataQuery:dataQuery1)
        if (result is BackendlessCollection) {
        var bc1 : BackendlessCollection = result as BackendlessCollection
        for order : Order in bc1.data as [Order] {
        println("OrderItem: \(order.name) <\(order.objectId)>")
        }
        }
        if (result is Fault) {
        println("\nFAULT (0): \(fault!.description)")
        }
        
        */
        
        // - sync method with class instance/fault as return (fault as exception should be shutted off !)
        result = backendless.persistenceService.save(Weather())
        if (result is Weather) {
            let obj : AnyObject = backendless.persistenceService.findById("Weather", sid:(result as! Weather).objectId)
            if (obj is Weather) {
                let obj1 = obj as! Weather
                print("\nWeather (1): \(obj1.description)")
            }
        }
        if (result is Fault) {
            print("\nFAULT (1): \(fault!.description)")
        }
        
        // - sync method with fault as reference (fault as exception should be shutted off !)
        let weather : AnyObject? = backendless.persistenceService.save(Weather(), error: &fault)
        if (fault == nil) {
            let obj : AnyObject = backendless.persistenceService.findById("Weather", sid: (weather as! Weather).objectId)
            if (obj is Weather) {
                print("\nWeather (2): \((obj as! Weather).description)")
            }
        }
        else {
            print("\nFAULT (2): \(fault!.description)")
        }
        
        // - async method with block-based callbacks
        backendless.persistenceService.save(
            Weather(),
            response: { ( result : AnyObject!) -> () in
                let obj : AnyObject = self.backendless.persistenceService.findById("Weather", sid: (result as! Weather).objectId)
                if (obj is Weather) {
                    print("\nWeather (3): \((obj as! Weather).description)")
                }
            },
            error: { ( fault : Fault!) -> () in
                print("\nFAULT (3): \(fault!.description)")
            }
        )
        
        // - object as dictionary of properties
        let os = ["iOS":"Apple", "android":"Google"]
        let mobileOs : AnyObject? = backendless.persistenceService.save("MobileOS", entity:os, error: &fault)
        if (fault != nil) {
            print("\nFAULT (4): \(fault!.description)")
        }
        
        let q = BackendlessDataQuery.query() as! BackendlessDataQuery;
        print("\nResult: \(mobileOs), \(q)")
        
    }
    
    // samples: Linking a data object with a geo point and vice versa - http://bugs.backendless.com/browse/BKNDLSS-7826
    
    func linkingDataObjectWithGeoPoints() {
        
        Types.tryblock({ () -> Void in
            
            var taxi = TaxiCab()
            taxi.carMake = "Toyota"
            taxi.carModel = "Prius"
            
            // one-to-one relation between a data object and a geo point
            taxi.location = GeoPoint.geoPoint(
                GEO_POINT(latitude: 40.7148, longitude: -74.0059),
                categories: ["taxi"],
                metadata: ["service-area":"NYC"]
                ) as? GeoPoint
            
            // one-to-many relation between a data object and geo points
            let droppOff1 = GeoPoint.geoPoint(
                GEO_POINT(latitude: 40.757977, longitude: -73.98557),
                categories: ["DropOffs"],
                metadata: ["name":"Times Square"]
                ) as! GeoPoint
            
            let droppOff2 = GeoPoint.geoPoint(
                GEO_POINT(latitude: 40.748379, longitude: -73.985565),
                categories: ["DropOffs"],
                metadata: ["name":"Empire State Building"]
                ) as! GeoPoint
            
            taxi.previousDropOffs = [droppOff1, droppOff2]
            
            taxi = self.backendless.persistenceService.save(taxi) as! TaxiCab
            print("linkingDataObjectWithGeoPoints: \(taxi)")
            },
            
            catchblock: { (exception) -> Void in
                print("linkingDataObjectWithGeoPoints (FAULT): \(exception as! Fault)")
            }
        )
    }
    
    func linkingGeoPointWithDataObject() {
        
        Types.tryblock({ () -> Void in
            
            let cab = TaxiCab()
            cab.carMake = "Toyota"
            cab.carModel = "Prius"
            
            var pickupLocation = GeoPoint.geoPoint(
                GEO_POINT(latitude: 40.750549, longitude: -73.994232),
                categories: ["Pickups"],
                metadata: ["TaxiCab":cab]
                ) as! GeoPoint
            
            pickupLocation = self.backendless.geoService.savePoint(pickupLocation)
            print("linkingGeoPointWithDataObject: \(pickupLocation)")
            },
            
            catchblock: { (exception) -> Void in
                print("linkingGeoPointWithDataObject (FAULT): \(exception as! Fault)")
            }
        )
    }
    
    func linkingGeoPointWithSeveralDataObjects() {
        
        Types.tryblock({ () -> Void in
            
            let cab1 = TaxiCab()
            cab1.carMake = "Ford"
            cab1.carModel = "Crown Victoria"
            
            let cab2 = TaxiCab()
            cab2.carMake = "Toyota"
            cab2.carModel = "Prius"
            
            var pickupLocation = GeoPoint.geoPoint(
                GEO_POINT(latitude: 40.750549, longitude: -73.994232),
                categories: ["Pickups"],
                metadata: ["AvailableCabs":[cab1, cab2]]
                ) as! GeoPoint
            
            pickupLocation = self.backendless.geoService.savePoint(pickupLocation)
            print("linkingGeoPointWithSeveralDataObjects: \(pickupLocation)")
            },
            
            catchblock: { (exception) -> Void in
                print("linkingGeoPointWithSeveralDataObjects (FAULT): \(exception as! Fault)")
            }
        )
    }
    
    
    // samples : geo clustering - http://bugs.backendless.com/browse/BKNDLSS-7866
    
    func clusteringSearchInCategory() {
        
        Types.tryblock({ () -> Void in
            
            let query = BackendlessGeoQuery.queryWithCategories(["City"]) as! BackendlessGeoQuery
            query.setClusteringParams(-157.9 , eastLongitude: -157.8, mapWidth: 480)
            let points = self.backendless.geoService.getPoints(query)
            print("Loaded geo points and clusters: \(points)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func clusteringSearchInRadius() {
        
        Types.tryblock({ () -> Void in
            
            let query = BackendlessGeoQuery.queryWithPoint(
                GEO_POINT(latitude: 21.306944, longitude: -157.858333), radius: 50.0, units: KILOMETERS, categories: ["City"]) as! BackendlessGeoQuery
            query.setClusteringParams(157.9 , eastLongitude: 157.8, mapWidth: 480)
            let points = self.backendless.geoService.getPoints(query)
            print("Loaded geo points and clusters: \(points)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }

    func clusteringSearchInRectangularArea() {
        
        Types.tryblock({ () -> Void in
            
            let rect = self.backendless.geoService.geoRectangle(GEO_POINT(latitude: 21.306944, longitude: -157.858333), length: 0.5, widht: 0.5)
            let query = BackendlessGeoQuery.queryWithRect(rect.nordWest, southEast: rect.southEast, categories: ["City"]) as! BackendlessGeoQuery
            query.setClusteringParams(157.9 , eastLongitude: 157.8, mapWidth: 480)
            let points = self.backendless.geoService.getPoints(query)
            print("Loaded geo points and clusters: \(points)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    // sample: load geo point metadata - http://bugs.backendless.com/browse/BKNDLSS-8098
    
    func loadingGeoPointMetadata() {
        
        Types.tryblock({ () -> Void in
            
            let query = BackendlessGeoQuery.queryWithCategories(["City"]) as! BackendlessGeoQuery
            let points = self.backendless.geoService.getPoints(query)
            print("Loaded geo points with metadata:")
            
            for point in points.data {
                let geoPoint = self.backendless.geoService.loadMetadata(point as! GeoPoint)
                print("\(geoPoint)")
            }
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func loadingGeoClusterMetadata() {
        
        Types.tryblock({ () -> Void in
            
            let query = BackendlessGeoQuery.queryWithCategories(["City"]) as! BackendlessGeoQuery
            query.setClusteringParams(-157.9 , eastLongitude: -157.8, mapWidth: 480)
            let points = self.backendless.geoService.getPoints(query)
            print("Loaded geo points and clusters with metadata:")
            
            for point in points.data {
                let geoPoint = self.backendless.geoService.loadMetadata(point as! GeoPoint)
                print("\(geoPoint)")
            }
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    // sample: searching for data objects by distance - http://bugs.backendless.com/browse/BKNDLSS-8020
    
    func searchingDataObjectByDistance() {
        
        Types.tryblock({ () -> Void in
            
            // create the friends
            
            let bob = Friend()
            bob.name = "Bob"
            bob.phoneNumber = "512-555-1212";
            bob.coordinates = GeoPoint.geoPoint(
            GEO_POINT(latitude: 30.26715, longitude: -97.74306),
            categories: ["Home"],
            metadata: ["description":"Bob's home"]
            ) as? GeoPoint
            self.backendless.persistenceService.save(bob)
            
            let jane = Friend()
            jane.name = "Jane"
            jane.phoneNumber = "512-555-1212";
            jane.coordinates = GeoPoint.geoPoint(
            GEO_POINT(latitude: 30.26715, longitude: -97.74306),
            categories: ["Home"],
            metadata: ["description":"Jane's home"]
            ) as? GeoPoint
            self.backendless.persistenceService.save(jane)
            
            let fred = Friend()
            fred.name = "Fred"
            fred.phoneNumber = "512-555-1212";
            fred.coordinates = GeoPoint.geoPoint(
            GEO_POINT(latitude: 30.26715, longitude: -97.74306),
            categories: ["Home"],
            metadata: ["description":"Fred's home"]
            ) as? GeoPoint
            self.backendless.persistenceService.save(fred)
            
            // search the friends by distance
            
            let queryOptions = QueryOptions()
            queryOptions.relationsDepth = 1;
            
            let dataQuery = BackendlessDataQuery()
            dataQuery.queryOptions = queryOptions;
            dataQuery.whereClause = "distance( 30.26715, -97.74306, Coordinates.latitude, Coordinates.longitude ) < mi(200)"
            
            let friends = self.backendless.persistenceService.find(Friend.ofClass(), dataQuery:dataQuery) as BackendlessCollection
            for friend in friends.data as! [Friend] {
                let info = friend.coordinates!.metadata["description"] as! String
                print("\(friend.name) lives at \(friend.coordinates!.latitude), \(friend.coordinates!.longitude) tagged as '\(info)'")
            }
            },
            
            catchblock: { (exception) -> Void in
                print("searchingDataObjectByDistance (FAULT): \(exception as! Fault)")
            }
        )
    }

}

