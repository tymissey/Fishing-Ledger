//
//  Fish.m
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 8/19/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Fish.h"


@implementation Fish

@dynamic fishBait;
@dynamic fishDate;
@dynamic fishID;
@dynamic fishLat;
@dynamic fishLon;
@dynamic fishType;
@dynamic fishIdentifyer;
@dynamic fishWeather;
@dynamic fishTemperature;
@dynamic fishMoon;
@dynamic fishPressure;
@dynamic fishWindDirection;
@dynamic fishWindMagnitude;

-(void)setFishWithType:(NSString *)type bait:(NSString *)bait at:(CLLocationCoordinate2D)coord fishId:(NSInteger)fishId saveID:(NSInteger)saveID{
    self.fishType = type;
    self.fishBait = bait;
    self.fishLat = [NSNumber numberWithDouble:coord.latitude];
    self.fishLon = [NSNumber numberWithDouble:coord.longitude];
    self.fishID = [NSNumber numberWithInteger:fishId];
    self.fishIdentifyer = [NSNumber numberWithInteger:saveID];
    
    NSString *datenow;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    datenow = [dateFormat stringFromDate:[NSDate date]];
    self.fishDate = datenow;
}

-(void)setFishWeatherAttributes:(NSString *)sum temp:(NSString *)temp moon:(NSString *)moon pressure:(NSString *)pressure windMagnitude:(NSString *)wm windDirection:(NSString *)wd{
    
    self.fishWeather = sum;
    self.fishTemperature = temp;
    self.fishMoon = moon;
    self.fishPressure = pressure;
    self.fishWindMagnitude = wm;
    self.fishWindDirection = wd;
}
@end
