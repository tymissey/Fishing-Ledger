//
//  CustomCalloutAnnotation.m
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 8/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CustomCalloutAnnotation.h"

@implementation CustomCalloutAnnotation
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

-(id)initWithCustomPin:(CustomPin *)annotation{
    self = [super init];
    
    if (self != nil)
    {
        _coordinate = annotation.coordinate;
        _title = annotation.title;
        _subtitle = annotation.subtitle;
        _mID = annotation.mID;
        _identifyer = annotation.identifyer;
        _myDate = annotation.myDate;
        _myWeather = annotation.myWeather;
        _myTemp = annotation.myTemp;
        _myPressure = annotation.myPressure;
        _myMoon = annotation.myMoon;
        _myWind = annotation.myWind;
    }
    
    return self;
}

@end
