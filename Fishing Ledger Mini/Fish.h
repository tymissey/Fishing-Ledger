//
//  Fish.h
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 8/19/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Mapkit/Mapkit.h>


@interface Fish : NSManagedObject

@property (nonatomic, retain) NSString * fishBait;
@property (nonatomic, retain) NSString * fishDate;
@property (nonatomic, retain) NSNumber * fishID;
@property (nonatomic, retain) NSNumber * fishLat;
@property (nonatomic, retain) NSNumber * fishLon;
@property (nonatomic, retain) NSString * fishType;
@property (nonatomic, retain) NSNumber * fishIdentifyer;
@property (nonatomic, retain) NSString * fishWeather;
@property (nonatomic, retain) NSString * fishTemperature;
@property (nonatomic, retain) NSString * fishMoon;
@property (nonatomic, retain) NSString * fishPressure;
@property (nonatomic, retain) NSString * fishWindDirection;
@property (nonatomic, retain) NSString * fishWindMagnitude;

-(void)setFishWithType:(NSString *)type bait:(NSString *)bait at:(CLLocationCoordinate2D)coord fishId:(NSInteger)fishId saveID:(NSInteger)saveID;

-(void)setFishWeatherAttributes:(NSString *)sum temp:(NSString *)temp moon:(NSString *)moon pressure:(NSString *)pressure windMagnitude:(NSString *)wm windDirection:(NSString *)wd;

@end
