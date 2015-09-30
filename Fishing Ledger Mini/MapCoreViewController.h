//
//  MapCoreViewController.h
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/11/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>

#import "CustomPin.h"
#import "CustomAnnotationView.h"
#import "CustomCalloutAnnotation.h"

@protocol MapCoreViewSubclass
@required
-(void)addToolBar;
-(void)drawPins;
@end 

@interface MapCoreViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate,UIGestureRecognizerDelegate,ADBannerViewDelegate>{
    MKMapView *mapView;
    double m_zoom;                                      //zoom level for focusing
    ADBannerView *bannerView_;
    UIImageView *bannerViewAlt_;
    UIButton *adButton;
}
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fishIcons;
@property (nonatomic, readwrite) CGRect screenBounds;
@property (nonatomic, readwrite) CGSize screenSize;
@property (nonatomic, readwrite) CGFloat screenHeight;
@property (nonatomic, readwrite) CGFloat screenWidth;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIToolbar *tools;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *compassBtn;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapSelect;


-(void)focus;
-(void)cancelAndReturn;
-(void)saveData;

- (IBAction)selectMap:(id)sender;
- (IBAction)refocus:(id)sender;
-(void)cancelAction;
-(void)addButtons;

-(void)setImages;
-(void)runAds;


@end
