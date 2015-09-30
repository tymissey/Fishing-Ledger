//
//  MapCoreViewController.m
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/11/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MapCoreViewController.h"


@implementation MapCoreViewController
@synthesize mapSelect;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize  fishIcons;

@synthesize mapView, doneBtn, cancelBtn,tools,compassBtn ,screenHeight, screenWidth, screenSize, screenBounds, locationManager;



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    screenBounds = [[UIScreen mainScreen]bounds];
    screenSize = screenBounds.size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;

    #ifdef FREE
    
      //  [self runAds];
    #endif
    
    //Additional Setup
    [self setImages];
    [compassBtn setImage:[UIImage imageNamed:@"compassselected"]];
    CALayer *cancelBtnLayer = [cancelBtn layer];
    [cancelBtnLayer setMasksToBounds:YES];
    [cancelBtnLayer setCornerRadius:5.0f];
    CALayer *doneBtnLayer = [doneBtn layer];
    [doneBtnLayer setMasksToBounds:YES];
    [doneBtnLayer setCornerRadius:5.0f];
    self->m_zoom = 250.0;
    [self focus];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [pan setDelegate:self];
    [self.mapView addGestureRecognizer:pan];

}

-(void)viewWillAppear:(BOOL)animated{
    [bannerView_ setDelegate:self];
    [bannerView_ setAlpha:0];
}


- (void)viewDidUnload
{
    [self setMapSelect:nil];
    [super viewDidUnload];
    self.mapView = nil;
    [self setCancelBtn:nil];
    [self setDoneBtn:nil];
    [self setTools:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)didDragMap:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [compassBtn setImage:[UIImage imageNamed:@"compassunselected"]];
    }
}


- (IBAction)selectMap:(id)sender {
    switch(((UISegmentedControl *)sender).selectedSegmentIndex){
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            mapView.mapType = MKMapTypeStandard;
            break;
    }
}

-(void)focus{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];

    [mapView setShowsUserLocation:YES];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    mapView.showsBuildings = YES;
    mapView.showsPointsOfInterest = YES;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, self->m_zoom, self->m_zoom);
    [mapView setRegion:region];
    [compassBtn setImage:[UIImage imageNamed:@"compassselected"]];
}

- (IBAction)refocus:(id)sender {
    [self focus];
}

-(void)cancelAndReturn{
    [self.managedObjectContext rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveData{
    NSError *error = nil;
    if([self.managedObjectContext hasChanges]){
        if(![self.managedObjectContext save:&error]){
            //NSLog(@"Save Failed: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Save Error"
                                                           message: [NSString stringWithFormat:@"Sorry Save Failed. Error: %@", [error localizedDescription]]
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)cancelAction{
    [cancelBtn removeFromSuperview];
    [doneBtn removeFromSuperview];
}

-(void)addButtons{
    [self.view addSubview:cancelBtn];
    [self.view addSubview:doneBtn];
}


-(void) setImages{
    
    NSMutableArray *tempPics = [[NSMutableArray alloc]init];
    
    for(NSInteger i = 0; i < 46;i++){
        NSString *q = [NSString stringWithFormat:@"%li",(long)i ];
        [tempPics addObject:[UIImage imageNamed:q]];
    }

    self.fishIcons = [[NSArray alloc] initWithArray:tempPics];

}
-(IBAction) touchedAd:(id)sender{
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/fishing-ledger/id931543078?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

-(void)runAds{
   
    //Ad Support
    bannerView_ = [[ADBannerView alloc]initWithFrame:CGRectMake(0, screenHeight - 90, screenWidth, 50)];
    bannerViewAlt_ =[[UIImageView alloc]initWithFrame:CGRectMake(0, screenHeight - 93, 50, 50)];
    adButton = [[UIButton alloc] initWithFrame:CGRectMake(50, screenHeight - 93, screenWidth - 50, 50)];
    [adButton setBackgroundColor:[UIColor blackColor] ];
    [adButton setTitle:@"Buy the Full Version!" forState:UIControlStateNormal];
    [adButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [adButton addTarget:self action:@selector(touchedAd:) forControlEvents:UIControlEventTouchUpInside];
    [bannerViewAlt_ setImage:[UIImage imageNamed:@"Iconad"]];
    
    //bannerView_.adUnitID = @"ca-app-pub-6226651418958209/7555948374";
    bannerView_.delegate = self;
    
   // request.testDevices = [NSArray arrayWithObjects:@"b628a205446419bf2d4a7a6b5a8d6c7565e4a2f8", nil];
    //[bannerView_ loadRequest:request];
    [self.view addSubview:bannerView_];
}


#pragma mark - ADBannerViewDelegate
-(void) bannerViewDidLoadAd:(ADBannerView *)banner{
    [self.view addSubview:bannerView_];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
    [bannerViewAlt_ removeFromSuperview];
    [adButton removeFromSuperview];

}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
    [self.view addSubview:bannerViewAlt_];
    [self.view addSubview:adButton];
    [bannerView_ removeFromSuperview];
}


@end
