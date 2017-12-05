//
//  LocationTracker.h
//  WWL
//
//  Created by Kristoffer Yap on 6/27/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationSharedModel.h"

typedef enum : NSUInteger {
    LocationSubmitTypeEmergency,
    LocationSubmitTypeStreaming,
    LocationSubmitTypeNormal,
} LocationSubmitType;

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) LocationSharedModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer:(LocationSubmitType) type;


@end

