//
//  CustomPin.h
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Mapkit/Mapkit.h>
#import "Fish.h"
@interface CustomPin : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) NSInteger *mID;
@property (nonatomic, readonly) NSInteger *identifyer;
@property (nonatomic, copy) NSString *myDate;
@property (nonatomic, copy) NSString *myWeather;
@property (nonatomic, copy) NSString *myTemp;
@property (nonatomic, copy) NSString *myPressure;
@property (nonatomic, copy) NSString *myMoon;
@property (nonatomic, copy) NSString *myWind;


-(id)initWithFish:(Fish *)fish;
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
