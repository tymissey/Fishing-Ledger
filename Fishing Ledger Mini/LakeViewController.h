//
//  LakeViewController.h
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/11/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MapCoreViewController.h"
#include "Fish.h"

@interface LakeViewController : MapCoreViewController<MapCoreViewSubclass, UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIWebViewDelegate,UIAlertViewDelegate>{
    NSString *APIKey;
    CLLocation *weatherLocation;
    NSDate *weatherUpdateTime;
    
    NSString *currentTemp;
    NSString *currentSummary;
    NSString *currentWindMagnitude;
    NSString *currentWindDirection;
    NSString *currentPressure;
    NSString *currentMoon;
    NSString *currentPrecipIntensity;
    NSString *currentPrecipType;
    NSString *currentSunrise;
    NSString *currentSunset;
    NSString *currentPrecipProb;
    NSString *currentHumidity;
    NSString *currentFeelsLike;
    
    NSInteger fishCount;
    NSInteger weatherCount;
    BOOL useTrial;
    BOOL bugstopper;
}

@property (nonatomic,strong)NSArray* fetchedFishArray;
@property (strong, nonatomic) IBOutlet UIPickerView *fishPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *filterPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *filterPickerA;
@property (strong, nonatomic) IBOutlet UIPickerView *filterPickerB;
@property (strong, nonatomic) IBOutlet UIPickerView *filterPickerC;
@property (strong, nonatomic) IBOutlet UITextField *baitBox;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBtnA;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBtnB;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBtnC;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (strong, nonatomic) IBOutlet UILabel *infolabel;
@property (strong, nonatomic) IBOutlet UILabel *infolabel2;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *weatherBtn;
@property (strong, nonatomic) IBOutlet UIButton *forecastBtn;
@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) NSArray *fishnames;
@property (strong, nonatomic) NSArray *bass;
@property (strong, nonatomic) NSArray *catfish;
@property (strong, nonatomic) NSArray *panfish;
@property (strong, nonatomic) NSArray *pike;
@property (strong, nonatomic) NSArray *rough;
@property (strong, nonatomic) NSArray *salmon;
@property (strong, nonatomic) NSArray *sturgeon;
@property (strong, nonatomic) NSArray *trout;

@property (strong, nonatomic) NSMutableArray *baitTypes;

@property (strong, nonatomic) NSArray *filters;
@property (strong, nonatomic) NSArray *filtersA;
@property (strong, nonatomic) NSArray *filterStrings;
@property (strong, nonatomic) NSArray *filterStringsA;
@property (readwrite, nonatomic) NSInteger filter;
@property (readwrite, nonatomic) NSInteger filterA;
@property (readwrite, nonatomic) NSInteger filterB;
@property (readwrite, nonatomic) NSString *filterC;
@property (readwrite, nonatomic) NSString *filterC2;
@property (readwrite, nonatomic) BOOL booladdfish;
@property (readwrite, nonatomic) BOOL boolbusy;

@property (strong, nonatomic) NSString *strfish;
@property (strong, nonatomic) NSString *strfish2;
@property (readwrite, nonatomic) NSInteger currentrow;
@property (readwrite, nonatomic) NSInteger previousrow;

@property (readwrite, nonatomic) NSInteger deleteIndex;
@property (strong, nonatomic) NSString *strFilter;
@property (readwrite, nonatomic) NSInteger currentfilterrow;
@property (readwrite, nonatomic) NSInteger previousfilterrow;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

#ifdef FREE
@property (strong, nonatomic) IBOutlet UIButton *dmButton;
@property (strong, nonatomic) IBOutlet UIButton *dnldButton;
@property (strong, nonatomic) IBOutlet UIImageView *paidAd;
-(IBAction)didTouchUpInsidePaidAdDismissButton:(UIButton *)sender;
-(IBAction)didTouchUpInsidePaidAdDownloadButton:(UIButton *)sender;
-(void)drawInterstitial;
#endif
@property (strong, nonatomic) IBOutlet UIView *weatherView;
- (IBAction)showCurrentWeather:(id)sender;
- (IBAction)forecastButtonLink:(id)sender;
- (IBAction)didTouchUpInsideDismissWeatherButton:(id)sender;
- (IBAction)didTouchUpInsideDismissForecastWebpageButton:(id)sender;

//- (IBAction)didTouchUpInsideDismissRateWebpageButton:(id)sender;

- (IBAction)addFishControls:(id)sender;
- (IBAction)addBtnAction:(id)sender;
- (void)addFish;
- (void)setWeather;
- (IBAction)cancel:(id)sender;
- (IBAction)changeFilter:(id)sender;
- (IBAction)changeFilterA:(id)sender;
- (IBAction)changeFilterB:(id)sender;
- (IBAction)changeFilterC:(id)sender;
-(NSArray*)getAllFish;
-(IBAction)didTouchUpInsideCalloutDeleteButton:(CustomCalloutAnnotation *)sender;
-(NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;
-(NSInteger)hoursBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;
-(NSInteger)getID;

@end
