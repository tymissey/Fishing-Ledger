//
//  CustomPin.m
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CustomPin.h"

@implementation CustomPin
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize mID = _mID;
@synthesize identifyer = _identifyer;
@synthesize myDate = _myDate;
@synthesize myWeather = _myWeather;
@synthesize myTemp = _myTemp;
@synthesize myPressure = _myPressure;
@synthesize myMoon = _myMoon;
@synthesize myWind = _myWind;

- (id)initWithFish:(Fish *)fish{
    self = [super init];
    
    if (self != nil)
    {
        _coordinate = CLLocationCoordinate2DMake([fish.fishLat doubleValue], [fish.fishLon doubleValue]);
        _title = fish.fishType;
        _subtitle = fish.fishBait;
        _mID = (NSInteger *)[fish.fishID integerValue];
        _identifyer = (NSInteger *)[fish.fishIdentifyer integerValue];
        _myDate = fish.fishDate;
        _myWeather = fish.fishWeather;
        _myTemp = [NSString stringWithFormat:@"%@\u00B0F", fish.fishTemperature];
        _myPressure = fish.fishPressure;
        _myMoon = fish.fishMoon;
        _myWind = [NSString stringWithFormat:@"%@mph %@",fish.fishWindMagnitude, fish.fishWindDirection];
    }
    
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate = newCoordinate;
}

@end
