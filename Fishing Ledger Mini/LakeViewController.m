//
//  LakeViewController.m
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/11/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LakeViewController.h"

@implementation LakeViewController

@synthesize fetchedFishArray;
@synthesize fishPicker;
@synthesize filterPicker;
@synthesize filterPickerA;
@synthesize filterPickerB;
@synthesize filterPickerC;
@synthesize baitBox;
@synthesize filterBtn;
@synthesize filterBtnA;
@synthesize filterBtnB;
@synthesize filterBtnC;
@synthesize addBtn;
@synthesize infolabel;
@synthesize infolabel2;
@synthesize weatherBtn;
@synthesize forecastBtn;
@synthesize weatherView;

@synthesize fishnames,bass,catfish,panfish,pike,rough,salmon,sturgeon,trout, strfish, strfish2, currentrow, previousrow, filter,filterA,filterB,filterC,filterC2,filters,booladdfish, deleteIndex,strFilter,filterStrings,boolbusy,defaults, webView, baitTypes,currentfilterrow,previousfilterrow,filtersA,filterStringsA;

#ifdef FREE
@synthesize paidAd,dnldButton,dmButton;
#endif


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
    
    //set up user defaults
    self.defaults = [NSUserDefaults standardUserDefaults];
    self->fishCount = (NSInteger)[defaults objectForKey:@"fishCount"];
    self->weatherCount = (NSInteger)[defaults objectForKey:@"weatherCount"];
    if (weatherCount < 0 || weatherCount > 5) {
        weatherCount = 0;
        [defaults setInteger:weatherCount forKey:@"weatherCount"];
        [defaults synchronize];
    }
    self->useTrial = YES;
    self->bugstopper = YES;

    //other setup
    [self.baitBox setDelegate:self];
    [self.mapView setDelegate:self];
    
    [self addToolBar];

    self.fetchedFishArray = [self getAllFish];
    self.fishnames = [[NSArray alloc]initWithObjects:@"Bass",@"Catfish",@"Crappie",@"Panfish",@"Pike", @"Rough Fish",@"Salmon",@"Sauger",@"Sturgeon",@"Trout",@"Walleye",@"Yellow Perch",nil];
    self.bass = [[NSArray alloc]initWithObjects:@"Largemouth",@"Rock",@"Smallmouth",@"Spotted",@"Striped",@"Hybrid",@"White", nil];
    self.catfish = [[NSArray alloc]initWithObjects:@"Blue",@"Bullhead",@"Channel",@"Flathead", nil];
    self.pike = [[NSArray alloc]initWithObjects:@"Northern Pike",@"Muskie",@"Chain Pickerel",@"Grass Pickerel", @"Redfin Pickerel",nil];
    self.panfish = [[NSArray alloc]initWithObjects:@"Bluegill",@"Green Sunfish",@"Redear Sunfish",@"Redbreast Sunfish",@"Spotted Sunfish",@"Pumpkinseed",@"Warmouth", nil];
    self.rough = [[NSArray alloc]initWithObjects:@"Bowfin",@"Bighead Carp",@"Common Carp",@"Grass Carp",@"Drum",@"Alligator Gar",@"Florida Gar",@"Longnose Gar",@"Shortnose Gar",@"Spotted Gar", nil];    
    self.salmon = [[NSArray alloc]initWithObjects:@"Chinook",@"Coho",@"Arctic Greyling",nil];
    self.sturgeon = [[NSArray alloc]initWithObjects:@"Lake",@"Shovelnose",nil];
    self.trout = [[NSArray alloc]initWithObjects:@"Brown",@"Lake",@"Rainbow",nil];
    
    self.baitTypes =[[NSMutableArray alloc]init];
    //[self.baitTypes addObject:@"None"];
    NSInteger count = [self.fetchedFishArray count];
    for (NSInteger i = 0; i < count; i++) {
        Fish *ty = [self.fetchedFishArray objectAtIndex:i];
        NSInteger countB = [self.baitTypes count];
        if(countB > 0){
            NSString *yt = @"";
            for (NSInteger l = 0; l < countB; l++) {
                if (l > 0) {
                    yt = [self.baitTypes objectAtIndex:l - 1];
                }
                if ([ty.fishBait localizedCaseInsensitiveCompare:[self.baitTypes objectAtIndex:l]] == NSOrderedAscending && ![ty.fishBait isEqualToString:yt]) {
                    [self.baitTypes insertObject:ty.fishBait atIndex:l];
                }
                if (l == countB - 1 && ([ty.fishBait localizedCaseInsensitiveCompare:[self.baitTypes objectAtIndex:l]] == NSOrderedDescending)&& ![ty.fishBait isEqualToString:yt]) {
                    [self.baitTypes addObject:ty.fishBait];
                }
                //Repeating values
            }
        }else{
            countB++;
            [self.baitTypes addObject:ty.fishBait];
        }
    }

    for(NSInteger p = 0; p < [self.baitTypes count]; p++){
        for(NSInteger o = 0; o < [self.baitTypes count]; o++){
            if(o != p){
                if([[baitTypes objectAtIndex:p]isEqualToString:[baitTypes objectAtIndex:o]]){
                    [baitTypes removeObjectAtIndex:o];
                }
            }
        }
    }

    self.filters = [[NSArray alloc] initWithObjects:@"None",@"Today", @"This Week", @"This Month", @"This Year", @"Time",@"2 Weeks and Time",@"Month and Time", @"Year and Time", nil];
    self.filterStrings = [[NSArray alloc] initWithObjects:@"All times are shown",@"All fish that have been caught on the current calendar day ar shown", @"All fish caught in the last seven days are shown", @"All fish caught in the current calendar month are shown", @"All fish caught in the current calendar year are shown", @"All fish caught within an hour of the current time on any day are shown",@"Only fish that have been caught within an hour of the current time and within 7 days of the current calendar month and day, any year will be shown",@"Only fish that have been caught within an hour of the current time and in the same calendar month, any year will be shown", @"Only fish that have been caught within an hour of the current time this current calendar year will be shown", nil];
    
    self.filtersA = [[NSArray alloc] initWithObjects:@"None", @"Weather", @"Weather + Wind",@"Weather, Wind, + Moonphase",@"Wind", @"Moonphase", @"Wind + Moonphase", nil];
    self.filterStringsA = [[NSArray alloc] initWithObjects:@"All weather conditions are shown", @"Filters fish based on current weather attributes such as temperature and overhead conditions",@"Weather filter with the addition of the wind filter",@"Weather, Wind, and Moonphase all blended into one filter",@"Filters by similar wind magnitude and direction to current conditions",@"Filters fish that were caught during the same lunar phase as today",@"Filters by Wind and moonphase",nil];

    
    self.filter = 0;
    self.filterA = 0;
    self.filterB = -1;
    self.filterC = @"All";
    self.filterC2 = @"";
    self.strFilter = [self.filterStrings objectAtIndex:filter];
    self.strfish = [self.fishnames objectAtIndex:0];
    self.strfish2 =[self.bass objectAtIndex:0];
    self.currentrow = 0;
    self.boolbusy = NO;
    self->currentSummary = @"NULL";
    
    [addBtn setEnabled:NO];
    [filterBtn setEnabled:NO];
    [filterBtnA setEnabled:NO];
    [filterBtnB setEnabled:NO];
    [filterBtnC setEnabled:NO];
    [weatherBtn setEnabled:NO];
    
    CALayer *forecastBtnLayer = [forecastBtn layer];
    [forecastBtnLayer setMasksToBounds:YES];
    [forecastBtnLayer setCornerRadius:5.0f];
    
    CALayer *filterlabelLayer = [infolabel2 layer];
    [filterlabelLayer setMasksToBounds:YES];
    [filterlabelLayer setCornerRadius:5.0f];

    [self drawPins];
    //NSLog([NSString stringWithFormat:@"Number of pins: %lu",(unsigned long)[fetchedFishArray count]]);

}

-(void)viewWillAppear:(BOOL)animated{
    [super cancelAction];
    [fishPicker removeFromSuperview];
    [baitBox removeFromSuperview];
    [filterPicker removeFromSuperview];
    [filterPickerA removeFromSuperview];
    [filterPickerB removeFromSuperview];
    [filterPickerC removeFromSuperview];
    [infolabel removeFromSuperview];
    [infolabel2 removeFromSuperview];
    [forecastBtn removeFromSuperview];
    #ifdef FREE
        [weatherBtn setEnabled:NO];
        [weatherBtn setImage:[UIImage imageNamed:@"forecastdeselected"]];
    #else
        [weatherBtn setImage:[UIImage imageNamed:@"forecastdeselected"]];
    #endif
}

- (void)viewDidUnload
{
    [self setFishPicker:nil];
    [self setBaitBox:nil];
    [self setFilterPicker:nil];
    [self setFilterPickerA:nil];
    [self setFilterPickerB:nil];
    [self setFilterPickerC:nil];
    [self setFilterBtn:nil];
    [self setFilterBtnA:nil];
    [self setFilterBtnB:nil];
    [self setFilterBtnC:nil];
    [self setAddBtn:nil];
    [self setInfolabel:nil];
    [self setInfolabel2:nil];
    [self setInfolabel2:nil];
    [self setWeatherBtn:nil];
    [self setForecastBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return[textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark - PickerViewDelegate Protocal

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (pickerView.tag){
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag){
        case 1:
            switch(component){
                case 0:
                    return [fishnames count];
                    break;
                case 1:
                    if([strfish isEqualToString:@"Bass"]){
                        return [self.bass count];
                    }else if([strfish isEqualToString:@"Catfish"]){
                        return [self.catfish count];
                    }else if([strfish isEqualToString:@"Crappie"]){
                        return 2;
                    }else if([strfish isEqualToString:@"Pike"]){
                        return [self.pike count];
                    }else if([strfish isEqualToString:@"Panfish"]){
                        return [self.panfish count];
                    }else if([strfish isEqualToString:@"Rough Fish"]){
                        return [self.rough count];
                    }else if([strfish isEqualToString:@"Salmon"]){
                        return [self.salmon count];
                    }else if([strfish isEqualToString:@"Sturgeon"]){
                        return [self.sturgeon count];
                    }else if([strfish isEqualToString:@"Trout"]){
                        return [self.trout count];
                    }else{
                        return 0;
                    }
                    break;
                default:
                    return [fishnames count];
            }

            break;
        case 2:
            return [filters count];
            break;
        case 3:
            return [baitTypes count] + 1;
            break;
        case 4:
            switch(component){
                case 0:
                    return [fishnames count] + 1;
                    break;
                case 1:
                    if([filterC isEqualToString:@"Bass"]){
                        return [self.bass count];
                    }else if([filterC isEqualToString:@"Catfish"]){
                        return [self.catfish count];
                    }else if([filterC isEqualToString:@"Crappie"]){
                        return 2;
                    }else if([filterC isEqualToString:@"Pike"]){
                        return [self.pike count];
                    }else if([filterC isEqualToString:@"Panfish"]){
                        return [self.panfish count];
                    }else if([filterC isEqualToString:@"Rough Fish"]){
                        return [self.rough count];
                    }else if([filterC isEqualToString:@"Salmon"]){
                        return [self.salmon count];
                    }else if([filterC isEqualToString:@"Sturgeon"]){
                        return [self.sturgeon count];
                    }else if([filterC isEqualToString:@"Trout"]){
                        return [self.trout count];
                    }else{
                        return 0;
                    }
                    break;
                default:
                    return [fishnames count];
            }

            break;
        case 5:
            return [filtersA count];
            break;
        default:
            return 0;
            break;
    }

    
    
}
 


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (pickerView.tag){
        case 1:
            if(component == 0){
                
                return [self.fishnames objectAtIndex:row];
            }else{
                if([strfish isEqualToString:@"Bass"]){
                    return [self.bass objectAtIndex:row];
                }else if([strfish isEqualToString:@"Catfish"]){
                    return [self.catfish objectAtIndex:row];
                }else if([strfish isEqualToString:@"Pike"]){
                    return [self.pike objectAtIndex:row];
                }else if([strfish isEqualToString:@"Panfish"]){
                    return [self.panfish objectAtIndex:row];
                }else if([strfish isEqualToString:@"Rough Fish"]){
                    return [self.rough objectAtIndex:row];
                }else if([strfish isEqualToString:@"Salmon"]){
                    return [self.salmon objectAtIndex:row];
                }else if([strfish isEqualToString:@"Sturgeon"]){
                    return [self.sturgeon objectAtIndex:row];
                }else if([strfish isEqualToString:@"Trout"]){
                    return [self.trout objectAtIndex:row];
                }else if([strfish isEqualToString:@"Crappie"]){
                    if(row == 0){
                        return @"Black";
                    }else{
                        return @"White";
                    }
                }else{
                    return @"";
                }
            }
            break;
        case 2:
            return [self.filters objectAtIndex:row];
            break;
        case 3:
            if(row == 0){
                return @"All";
            }else{
                return [self.baitTypes objectAtIndex:row - 1];
            }
            break;
        case 4:
            if(component == 0){
                if(row == 0){
                    return @"All";
                }else{
                    return [self.fishnames objectAtIndex:row - 1];
                }
            }else{
                if([filterC isEqualToString:@"Bass"]){
                    return [self.bass objectAtIndex:row];
                }else if([filterC isEqualToString:@"Catfish"]){
                    return [self.catfish objectAtIndex:row];
                }else if([filterC isEqualToString:@"Pike"]){
                    return [self.pike objectAtIndex:row];
                }else if([filterC isEqualToString:@"Panfish"]){
                    return [self.panfish objectAtIndex:row];
                }else if([filterC isEqualToString:@"Rough Fish"]){
                    return [self.rough objectAtIndex:row];
                }else if([filterC isEqualToString:@"Salmon"]){
                    return [self.salmon objectAtIndex:row];
                }else if([filterC isEqualToString:@"Sturgeon"]){
                    return [self.sturgeon objectAtIndex:row];
                }else if([filterC isEqualToString:@"Trout"]){
                    return [self.trout objectAtIndex:row];
                }else if([filterC isEqualToString:@"Crappie"]){
                    if(row == 0){
                        return @"Black";
                    }else{
                        return @"White";
                    }
                }else{
                    return @"";
                }
            }
            break;
        case 5:
            return [self.filtersA objectAtIndex:row];
            break;
        default:
            return [self.filters objectAtIndex:row];
            break;
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (pickerView.tag){
        case 1:
            if(component == 0){
                self.strfish = [self.fishnames objectAtIndex:row];
                if(row == 7 || row == 10 || row == 11) {
                    currentrow = 0;
                }
                if (previousrow == 7 || previousrow == 10 ||previousrow == 11) {
                    currentrow = 0;
                }
                [pickerView reloadComponent:1];
                
                if([strfish isEqualToString:@"Bass"]){
                    if(currentrow < [self.bass count]){
                        self.strfish2 = [self.bass objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.bass objectAtIndex:[bass count]-1];
                    }
                }else if([strfish isEqualToString:@"Catfish"]){
                    if(currentrow < [self.catfish count]){
                        self.strfish2 = [self.catfish objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.catfish objectAtIndex:[catfish count]-1];
                    }
                }else if([strfish isEqualToString:@"Panfish"]){
                    if(currentrow < [self.panfish count]){
                        self.strfish2 = [self.panfish objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.panfish objectAtIndex:[panfish count]-1];
                    }
                }else if([strfish isEqualToString:@"Pike"]){
                    if(currentrow < [self.pike count]){
                        self.strfish2 = [self.pike objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.pike objectAtIndex:[pike count]-1];
                    }
                }else if([strfish isEqualToString:@"Rough Fish"]){
                    if(currentrow < [self.rough count]){
                        self.strfish2 = [self.rough objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.rough objectAtIndex:[rough count]-1];
                    }
                }else if([strfish isEqualToString:@"Salmon"]){
                    if(currentrow < [self.salmon count]){
                        self.strfish2 = [self.salmon objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.salmon objectAtIndex:[salmon count]-1];
                    }
                }else if([strfish isEqualToString:@"Sturgeon"]){
                    if(currentrow < [self.sturgeon count]){
                        self.strfish2 = [self.sturgeon objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.sturgeon objectAtIndex:[sturgeon count]-1];
                    }
                }else if([strfish isEqualToString:@"Trout"]){
                    if(currentrow < [self.trout count]){
                        self.strfish2 = [self.trout objectAtIndex:currentrow];
                    }else{
                        self.strfish2 = [self.trout objectAtIndex:[trout count]-1];
                    }
                }else if([strfish isEqualToString:@"Crappie"]){
                    if(currentrow > 0){
                        self.strfish2 = @"White";
                    }else{
                        self.strfish2 = @"Black";
                    }
                }
                previousrow = row;
            }else{
                
                self.currentrow = row;
                
                if([strfish isEqualToString:@"Bass"]){
                    self.strfish2 = [self.bass objectAtIndex:row];
                }else if([strfish isEqualToString:@"Catfish"]){
                    self.strfish2 = [self.catfish objectAtIndex:row];
                }else if([strfish isEqualToString:@"Panfish"]){
                    self.strfish2 = [self.panfish objectAtIndex:row];
                }else if([strfish isEqualToString:@"Pike"]){
                    self.strfish2 = [self.pike objectAtIndex:row];
                }else if([strfish isEqualToString:@"Rough Fish"]){
                    self.strfish2 = [self.rough objectAtIndex:row];
                }else if([strfish isEqualToString:@"Salmon"]){
                    self.strfish2 = [self.salmon objectAtIndex:row];
                }else if([strfish isEqualToString:@"Sturgeon"]){
                    self.strfish2 = [self.sturgeon objectAtIndex:row];
                }else if([strfish isEqualToString:@"Trout"]){
                    self.strfish2 = [self.trout objectAtIndex:row];
                }else if([strfish isEqualToString:@"Crappie"]){
                    if(row == 0){
                        self.strfish2 = @"Black";
                    }else{
                        self.strfish2 = @"White";
                    }
                }
                
            }
            break;
        case 2:
            self.filter = row;
            infolabel2.text = [filterStrings objectAtIndex:filter];
            break;
        case 3:
            self.filterB = row - 1;
            infolabel2.text = @"This filter only shows fish caught using the selected bait";
            break;
        case 4:
            infolabel2.text = @"This filter only shows of the selected species";
            if(component == 0){
                if(row == 0){
                    self.filterC = @"All";
                }else{
                    self.filterC = [self.fishnames objectAtIndex:row - 1];
                }
                
                if(row == 0 || row == 8 || row == 11 || row == 12) {
                    currentfilterrow = 0;
                }
                if (previousfilterrow == 0 || previousfilterrow == 8 || previousfilterrow == 11 ||previousfilterrow == 12) {
                    currentfilterrow = 0;
                }
                [pickerView reloadComponent:1];
                
                if([filterC isEqualToString:@"Bass"]){
                    if(currentfilterrow < [self.bass count]){
                        self.filterC2 = [self.bass objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.bass objectAtIndex:[bass count]-1];
                    }
                }else if([filterC isEqualToString:@"Catfish"]){
                    if(currentfilterrow < [self.catfish count]){
                        self.filterC2 = [self.catfish objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.catfish objectAtIndex:[catfish count]-1];
                    }
                }else if([filterC isEqualToString:@"Panfish"]){
                    if(currentfilterrow < [self.panfish count]){
                        self.filterC2 = [self.panfish objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.panfish objectAtIndex:[panfish count]-1];
                    }
                }else if([filterC isEqualToString:@"Pike"]){
                    if(currentfilterrow < [self.pike count]){
                        self.filterC2 = [self.pike objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.pike objectAtIndex:[pike count]-1];
                    }
                }else if([filterC isEqualToString:@"Rough Fish"]){
                    if(currentfilterrow < [self.rough count]){
                        self.filterC2 = [self.rough objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.rough objectAtIndex:[rough count]-1];
                    }
                }else if([filterC isEqualToString:@"Salmon"]){
                    if(currentfilterrow < [self.salmon count]){
                        self.filterC2 = [self.salmon objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.salmon objectAtIndex:[salmon count]-1];
                    }
                }else if([filterC isEqualToString:@"Sturgeon"]){
                    if(currentfilterrow < [self.sturgeon count]){
                        self.filterC2 = [self.sturgeon objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.sturgeon objectAtIndex:[sturgeon count]-1];
                    }
                }else if([filterC isEqualToString:@"Trout"]){
                    if(currentfilterrow < [self.trout count]){
                        self.filterC2 = [self.trout objectAtIndex:currentfilterrow];
                    }else{
                        self.filterC2 = [self.trout objectAtIndex:[trout count]-1];
                    }
                }else if([filterC isEqualToString:@"Crappie"]){
                    if(currentfilterrow > 0){
                        self.filterC2 = @"White";
                    }else{
                        self.filterC2 = @"Black";
                    }
                }
                previousfilterrow = row;
            }else{
                
                self.currentfilterrow = row;
                
                if([filterC isEqualToString:@"Bass"]){
                    self.filterC2 = [self.bass objectAtIndex:row];
                }else if([filterC isEqualToString:@"Catfish"]){
                    self.filterC2 = [self.catfish objectAtIndex:row];
                }else if([filterC isEqualToString:@"Panfish"]){
                    self.filterC2 = [self.panfish objectAtIndex:row];
                }else if([filterC isEqualToString:@"Pike"]){
                    self.filterC2 = [self.pike objectAtIndex:row];
                }else if([filterC isEqualToString:@"Rough Fish"]){
                    self.filterC2 = [self.rough objectAtIndex:row];
                }else if([filterC isEqualToString:@"Salmon"]){
                    self.filterC2 = [self.salmon objectAtIndex:row];
                }else if([filterC isEqualToString:@"Sturgeon"]){
                    self.filterC2 = [self.sturgeon objectAtIndex:row];
                }else if([filterC isEqualToString:@"Trout"]){
                    self.filterC2 = [self.trout objectAtIndex:row];
                }else if([filterC isEqualToString:@"Crappie"]){
                    if(row == 0){
                        self.filterC2 = @"Black";
                    }else{
                        self.filterC2 = @"White";
                    }
                }
                
            }
            break;
        case 5:
            self.filterA = row;
            infolabel2.text = [filterStringsA objectAtIndex:filterA];
            break;
        default:
            break;
    }
}

#pragma  mark - MKMapVIewDelegate Protocol

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[CustomPin class]]&& self.boolbusy == NO) {
        boolbusy = YES;
        self->bugstopper = NO;
        [filterBtn setEnabled:NO];
        [filterBtnA setEnabled:NO];
        [filterBtnB setEnabled:NO];
        [filterBtnC setEnabled:NO];
        [addBtn setEnabled:NO];
        [weatherBtn setEnabled:NO];
        CustomCalloutAnnotation *calloutAnnotation = [[CustomCalloutAnnotation alloc] initWithCustomPin:view.annotation];
        [self.mapView addAnnotation:calloutAnnotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView selectAnnotation:calloutAnnotation animated:YES];
        });
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[CustomCalloutAnnotation class]]) {
        boolbusy = NO;
        self->bugstopper = YES;
        [self.mapView removeAnnotation:view.annotation];
        [filterBtn setEnabled:YES];
        
        [filterBtnB setEnabled:YES];
        [filterBtnC setEnabled:YES];
        [addBtn setEnabled:YES];
        #ifdef PAID
            [weatherBtn setEnabled:YES];
            [filterBtnA setEnabled:YES];
        #endif
        [forecastBtn removeFromSuperview];
        [self drawPins];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(CustomPin *)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }else if([annotation isKindOfClass:[CustomPin class]]){
        static NSString *AnnotationViewID = @"annotationViewID";
        
        CustomAnnotationView *customAnnotationView =(CustomAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        
        UIImage *img = [self.fishIcons objectAtIndex:(NSInteger) annotation.mID];
        customAnnotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID annotationViewImage:img];
        customAnnotationView.canShowCallout = NO;
        return customAnnotationView;
    }else if([annotation isKindOfClass:[CustomCalloutAnnotation class]]){

        static NSString *calloutIdentifier = @"CalloutAnnotation";
        //view
        CGSize size;
        UIColor *textColor = [UIColor colorWithRed:0.35f green:0.45f blue:1.0f alpha:1.0f];
        #ifdef FREE
        if(![annotation.myWeather isEqualToString:@""] && annotation.myWeather != NULL ){
            size = CGSizeMake(200.0, 117.0);
        }else{
            size = CGSizeMake(200.0, 86.0);
        }
        
        #else
            size = CGSizeMake(200.0, 117.0);
        #endif
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:calloutIdentifier];
        view.frame             = CGRectMake(0.0, 0.0, size.width, size.height);
        view.backgroundColor   = [UIColor blackColor];
        
        //image
        UIImage *pic = [[UIImage alloc]init];
        pic = [self.fishIcons objectAtIndex:(NSInteger)annotation.mID ];
        UIImageView *icon = [[UIImageView alloc]initWithImage:pic];
        icon.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        icon.frame = CGRectMake(0.0, 0.0, 32, 29);
        [view addSubview:icon];
        
        //title
        UILabel *tit = [[UILabel alloc] initWithFrame:CGRectMake(32.0, 0.0, size.width - 64.0, 29.0)];
        tit.textAlignment = NSTextAlignmentCenter;
        tit.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        tit.text = annotation.title;
        tit.textColor = textColor;
        tit.numberOfLines = 1;
        tit.adjustsFontSizeToFitWidth = YES;
        [view addSubview:tit];
        
        //bait
        UILabel *baitline = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 34.0, size.width - 10.0, 21.0)];
        baitline.text = [NSString stringWithFormat:@"Bait/Lure: %@", annotation.subtitle];
        baitline.textAlignment = NSTextAlignmentLeft;
        baitline.textColor = textColor;
        baitline.numberOfLines = 1;
        baitline.adjustsFontSizeToFitWidth = YES;
        [view addSubview:baitline];
        
        //date
        UILabel *when = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 55.0, size.width - 10.0, 21.0)];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *temp = [[NSDate alloc]init];
        temp = [dateFormat dateFromString:annotation.myDate];
        [dateFormat setDateFormat:@"M/d/yyyy  h:mm aaa"];
        when.text = [dateFormat stringFromDate:temp];
        when.textAlignment = NSTextAlignmentRight;
        when.textColor = textColor;
        when.numberOfLines = 1;
        when.adjustsFontSizeToFitWidth = YES;
        [view addSubview:when];
        
        if(![annotation.myWeather isEqualToString:@""]&& annotation.myWeather != NULL){
            UILabel *weather = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 76.0, size.width - 10.0, 21.0)];
            //weather text
            NSString *weatherString = [NSString stringWithFormat:@"%@  %@    Wind: %@",annotation.myWeather, annotation.myTemp , annotation.myWind];
            weather.text = weatherString;
            weather.textAlignment = NSTextAlignmentCenter;
            weather.textColor = [UIColor greenColor];
            weather.numberOfLines = 1;
            weather.adjustsFontSizeToFitWidth = YES;
            [view addSubview:weather];
            
            UILabel *weatherB = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 91.0, size.width - 10.0, 21.0)];
            weatherString = [NSString stringWithFormat:@"Lunar Phase: %@    Pressure: %@",annotation.myMoon, annotation.myPressure];
            weatherB.text = weatherString;
            weatherB.textAlignment = NSTextAlignmentCenter;
            weatherB.textColor = [UIColor greenColor];
            weatherB.numberOfLines = 1;
            weatherB.adjustsFontSizeToFitWidth = YES;
            [view addSubview:weatherB];
            
#ifdef FREE
            forecastBtn.frame = CGRectMake(self.screenWidth - 125.0, self.screenHeight - 125.0, 120.0, 31.0);
#else
            forecastBtn.frame = CGRectMake(self.screenWidth - 125.0, self.screenHeight - 75.0, 120.0, 31.0);
#endif
            [self.view addSubview:forecastBtn];
        }else{
            UILabel *unav = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 86.0, size.width - 10.0, 21.0)];
            unav.text = @"Weather Data is unavailable for this fish";
            unav.textAlignment = NSTextAlignmentCenter;
            unav.textColor = [UIColor greenColor];
            unav.numberOfLines = 2;
            unav.adjustsFontSizeToFitWidth = YES;
            [view addSubview:unav];
        }
        
        
        //delete
        UIButton *dltbutton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        dltbutton.frame           = CGRectMake(168.0, 0.0, 32.0, 29.0);
        dltbutton.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        [dltbutton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
        [dltbutton addTarget:self action:@selector(didTouchUpInsideCalloutDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:dltbutton];
        
        deleteIndex = (NSInteger)annotation.identifyer;
        
        CALayer *viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        [viewLayer setCornerRadius:10.0f];
        view.canShowCallout    = NO;
        view.centerOffset      = CGPointMake(0.0, -10.0);
        return view;
    }else{
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(self->bugstopper == YES){
        [addBtn setEnabled:YES];
        [filterBtn setEnabled:YES];

        [filterBtnB setEnabled:YES];
        [filterBtnC setEnabled:YES];
        #ifdef PAID
            [weatherBtn setEnabled:YES];
            [filterBtnA setEnabled:YES];
        #endif
    }
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   
{
    if(alertView.tag != 86){
        if (buttonIndex == 0) {
            if (booladdfish == YES) {
                return;
            }else{
                boolbusy = NO;
                [weatherBtn setImage:[UIImage imageNamed:@"forecastdeselected"]];
                [addBtn setEnabled:YES];
                [filterBtn setEnabled:YES];
                
                [filterBtnB setEnabled:YES];
                [filterBtnC setEnabled:YES];
                
                [forecastBtn removeFromSuperview];
                #ifdef PAID
                    [filterBtnA setEnabled:YES];
                    [weatherBtn setEnabled:YES];
                    [weatherView removeFromSuperview];
                #endif
            }
        }else{
            fetchedFishArray = [self getAllFish];        
            for (Fish * fish in fetchedFishArray) {
                if ([fish.fishIdentifyer integerValue] == self.deleteIndex) {
                    [self.managedObjectContext deleteObject:fish];
                    [self saveData];
                    break;
                }
            }
            [mapView deselectAnnotation:[[mapView selectedAnnotations]objectAtIndex:0] animated:YES];
        }
    }else{

    }
}


#pragma mark - Class methods
-(NSArray*)getAllFish
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fish"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}

- (IBAction)addFishControls:(id)sender {
    [super addButtons];
    [self.addBtn setImage:[UIImage imageNamed: @"addfishselected"]];
    [self.view addSubview:fishPicker];
    [self.view addSubview: baitBox];
    [self.view addSubview:infolabel];
    [filterBtn setEnabled:NO];
    [filterBtnA setEnabled:NO];
    [filterBtnB setEnabled:NO];
    [filterBtnC setEnabled:NO];
    [weatherBtn setEnabled:NO];
    booladdfish = YES;
    boolbusy = YES;
}

- (IBAction)addBtnAction:(id)sender {
    if(booladdfish == YES){
        [self addFish];
    }else{
        [super cancelAction];
        [filterPicker removeFromSuperview];
        [filterPickerA removeFromSuperview];
        [filterPickerB removeFromSuperview];
        [filterPickerC removeFromSuperview];
        [infolabel2 removeFromSuperview];
        [addBtn setEnabled:YES];
        [filterBtn setEnabled:YES];
        
        [filterBtnB setEnabled:YES];
        [filterBtnC setEnabled:YES];
        [filterBtn setImage:[UIImage imageNamed:@"timefilterdeselected"]];
        [filterBtnA setImage:[UIImage imageNamed:@"weatherfilterdeselected"]];
        [filterBtnB setImage:[UIImage imageNamed:@"baitdeselected"]];
        [filterBtnC setImage:[UIImage imageNamed:@"fishfilterdeselected"]];
        #ifdef PAID
            [weatherBtn setEnabled:YES];
            [filterBtnA setEnabled:YES];
        #endif
        [self drawPins];
    }
    boolbusy = NO;
}

- (void)addFish
{

    NSInteger idid = [self getID]; 
    NSString *strFishType;
    
    if([strfish isEqualToString:@""] || [baitBox.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Incomplete Form"
                                                       message: @"Please be sure to fill in the bait/lure description"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }else{    
        
        //change fishname
        if([strfish isEqualToString:@"Bass"]||[strfish isEqualToString:@"Catfish"]||[strfish isEqualToString:@"Crappie"]||[strfish isEqualToString:@"Salmon"]||[strfish isEqualToString:@"Sturgeon"]||[strfish isEqualToString:@"Trout"]){
            if(![strfish2 isEqualToString:@"Arctic Greyling"]){
                strFishType = [NSString stringWithFormat:@"%@ %@",strfish2,strfish];
            }else{
                strFishType = strfish2;
            }
        }else if([strfish isEqualToString:@"Panfish"]||[strfish isEqualToString:@"Pike"]||[strfish isEqualToString:@"Rough Fish"]){
            strFishType = strfish2;
        }else{
            strFishType = strfish;
        }
        
        //  new fish object haha insert Shawshank reference here
        Fish *newFish = [NSEntityDescription insertNewObjectForEntityForName:@"Fish" inManagedObjectContext:self.managedObjectContext];

        //  set fields
        NSString *theBait = [baitBox.text capitalizedString];
        
        [newFish setFishWithType:strFishType bait:theBait at:mapView.userLocation.coordinate fishId:idid saveID:[self.fetchedFishArray count]];
        
        BOOL dostuff = YES;
        for (NSInteger w = 0; w < [baitTypes count]; w++){
            if ([[baitTypes objectAtIndex:w]isEqualToString:theBait]) {
                dostuff = NO;
            }
        }
        if (dostuff == YES) {
            NSInteger count = [baitTypes count];
            if(count > 0){
                for (NSInteger i = 0; i < count; i++) {
                    NSString *yt = [baitTypes objectAtIndex:i];

                        if ([theBait localizedCaseInsensitiveCompare:yt] == NSOrderedAscending && ![theBait isEqualToString:yt]) {
                            [self.baitTypes insertObject:theBait atIndex:i];
                        }
                        if (i == count - 1 && ([theBait localizedCaseInsensitiveCompare:yt] == NSOrderedDescending)&& ![theBait isEqualToString:yt]) {
                            [self.baitTypes addObject:theBait];
                        }
                        //Repeating values
                }
            }else{
                [self.baitTypes addObject:theBait];
            }
            
        }
        
        for(NSInteger p = 0; p < [self.baitTypes count]; p++){
            for(NSInteger o = 0; o < [self.baitTypes count]; o++){
                if(o != p){
                    if([[baitTypes objectAtIndex:p]isEqualToString:[baitTypes objectAtIndex:o]]){
                        [baitTypes removeObjectAtIndex:o];
                    }
                }
            }
        }
        //Weather for Paid version
        #ifdef PAID        
            if ([currentSummary isEqualToString: @"NULL"]) {
                [self setWeather];
            }else{
                CLLocationDistance distance = [mapView.userLocation.location distanceFromLocation:weatherLocation];
                if(([self hoursBetweenDate:self->weatherUpdateTime andDate:[NSDate date]]>1) || distance > 20000.0){
                    [self setWeather];
                }
            }
            [newFish setFishWeatherAttributes:currentSummary temp:currentTemp moon:currentMoon pressure:currentPressure windMagnitude:currentWindMagnitude windDirection:currentWindDirection];
        #else
            if (weatherCount < 5){
                if ([currentSummary isEqualToString: @"NULL"]) {
                    [self setWeather];
                }else{
                    CLLocationDistance distance = [mapView.userLocation.location distanceFromLocation:weatherLocation];
                    if(([self hoursBetweenDate:self->weatherUpdateTime andDate:[NSDate date]]>1) || distance > 20000.0){
                        [self setWeather];
                    }
                }
                [newFish setFishWeatherAttributes:currentSummary temp:currentTemp moon:currentMoon pressure:currentPressure windMagnitude:currentWindMagnitude windDirection:currentWindDirection];
                self->weatherCount++;
                [defaults setInteger:self->weatherCount forKey:@"weatherCount"];
                [defaults synchronize];
            }else{
                NSString *d = @"";
                [newFish setFishWeatherAttributes:d temp:d moon:d pressure:d windMagnitude:d windDirection:d];
            }
        #endif
        
        //save context     
        [self saveData];

        //rmove buttons
        [super cancelAction];
        [fishPicker removeFromSuperview];
        [baitBox removeFromSuperview];
        [infolabel removeFromSuperview];
        [self.addBtn setImage:[UIImage imageNamed: @"addfishdeselected"]];
        [filterBtn setEnabled:YES];
        
        [filterBtnB setEnabled:YES];
        [filterBtnC setEnabled:YES];
        self.booladdfish = NO;
        #ifdef PAID
            [weatherBtn setEnabled:YES];
            [filterBtnA setEnabled:YES];
        #endif
        [self drawPins];
        
        self->fishCount++;
        [defaults setValue:[NSNumber numberWithInteger:self->fishCount] forKey:@"fishCount"];
        [defaults synchronize];
        #ifdef FREE
            if (fishCount == 4) {
                [self drawInterstitial];
                self->fishCount = 0;
                [defaults setValue:[NSNumber numberWithInteger:self->fishCount] forKey:@"fishCount"];
                [defaults synchronize];
            }

        #endif
    }
}

- (IBAction)cancel:(id)sender {
    [super cancelAction];
    [fishPicker removeFromSuperview];
    [baitBox removeFromSuperview];
    [filterPicker removeFromSuperview];
    [filterPickerA removeFromSuperview];
    [filterPickerB removeFromSuperview];
    [filterPickerC removeFromSuperview];
    [infolabel removeFromSuperview];
    [infolabel2 removeFromSuperview];
    [addBtn setEnabled:YES];
    self.booladdfish = NO;
    #ifdef PAID
        [filterBtnA setEnabled:YES];
        [weatherBtn setEnabled:YES];
    #endif
    [filterBtn setEnabled:YES];
    
    [filterBtnB setEnabled:YES];
    [filterBtnC setEnabled:YES];
    [self.addBtn setImage:[UIImage imageNamed: @"addfishdeselected"]];
    [filterBtn setImage:[UIImage imageNamed:@"timefilterdeselected"]];
    [filterBtnA setImage:[UIImage imageNamed:@"weatherfilterdeselected"]];
    [filterBtnB setImage:[UIImage imageNamed:@"baitdeselected"]];
    [filterBtnC setImage:[UIImage imageNamed:@"fishfilterdeselected"]];
    
    boolbusy = NO;
}

- (IBAction)changeFilter:(id)sender {
    #ifdef PAID        
        if ([currentSummary isEqualToString: @"NULL"]) {
            [self setWeather];
        }else{
            CLLocationDistance distance = [mapView.userLocation.location distanceFromLocation:weatherLocation];
            if(([self hoursBetweenDate:self->weatherUpdateTime andDate:[NSDate date]]>1) || distance > 20000.0){
                [self setWeather];
            }
        }

    #endif
    [super addButtons];
    [self.view addSubview:filterPicker];
    [self.view addSubview:infolabel2];
    [filterBtn setImage:[UIImage imageNamed:@"timefilterselected"]];
    infolabel2.text = [filterStrings objectAtIndex:filter];
    [addBtn setEnabled:NO];
    [filterBtnA setEnabled:NO];
    [filterBtnB setEnabled:NO];
    [filterBtnC setEnabled:NO];
    [weatherBtn setEnabled:NO];
    booladdfish = NO;
    boolbusy =YES;
}

- (IBAction)changeFilterA:(id)sender {
    [super addButtons];
    [self.view addSubview:filterPickerA];
    [self.view addSubview:infolabel2];
    [filterBtnA setImage:[UIImage imageNamed:@"weatherfilterselected"]];
    infolabel2.text = [filterStringsA objectAtIndex:filterA];
    [addBtn setEnabled:NO];
    [filterBtn setEnabled:NO];
    [filterBtnB setEnabled:NO];
    [filterBtnC setEnabled:NO];
    [weatherBtn setEnabled:NO];
    booladdfish = NO;
    boolbusy =YES;
}

- (IBAction)changeFilterB:(id)sender {
    [super addButtons];
    [self.view addSubview:filterPickerB];
    [self.view addSubview:infolabel2];
    [filterBtnB setImage:[UIImage imageNamed:@"baitselected"]];
    infolabel2.text = @"This filter only shows fish caught using the selected bait";
    [addBtn setEnabled:NO];
    [filterBtn setEnabled:NO];
    [filterBtnA setEnabled:NO];
    [filterBtnC setEnabled:NO];
    [weatherBtn setEnabled:NO];
    booladdfish = NO;
    boolbusy =YES;
}

- (IBAction)changeFilterC:(id)sender {
    [super addButtons];
    [self.view addSubview:filterPickerC];
    [self.view addSubview:infolabel2];
    [filterBtnC setImage:[UIImage imageNamed:@"fishfilterselected"]];
    infolabel2.text = @"This filter only shows of the selected species";
    [addBtn setEnabled:NO];
    [filterBtn setEnabled:NO];
    [filterBtnA setEnabled:NO];
    [filterBtnB setEnabled:NO];
    [weatherBtn setEnabled:NO];
    booladdfish = NO;
    boolbusy =YES;
}

-(void)addToolBar{
    CGRect toolsize = CGRectMake(0,super.screenHeight - 44, super.screenWidth, 44);
    if (IS_IPHONE_5) {
        toolsize = CGRectMake(0, 568 - 44, 320, 44);
    }else if(IS_IPHONE_6){
        toolsize = CGRectMake(0, 667 - 44, 375, 44);
    }else if(IS_IPHONE_6_PLUS){
        toolsize = CGRectMake(0, 736 - 44, 414, 44);
    }else if(IS_IPHONE_4){
        toolsize = CGRectMake(0, 480 - 44, 320, 44);
    }
    self.tools = [[UIToolbar alloc]initWithFrame:toolsize];
    [self.tools setBarStyle:UIBarStyleBlackOpaque];
    
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    #ifdef PAID
    self.weatherBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"forecastdeselected"] style:UIBarButtonItemStylePlain target:self action:@selector(showCurrentWeather:)];

    #endif
    self.filterBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"timefilterdeselected"] style:UIBarButtonItemStylePlain target:self action:@selector(changeFilter:)];
    
    self.filterBtnA = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"weatherfilterdeselected"] style:UIBarButtonItemStylePlain target:self action:@selector(changeFilterA:)];
    
    self.filterBtnB = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"baitdeselected"] style:UIBarButtonItemStylePlain target:self action:@selector(changeFilterB:)];
    
    self.filterBtnC = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fishfilterdeselected"] style:UIBarButtonItemStylePlain target:self action:@selector(changeFilterC:)];
    
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    self.compassBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"compassselected"] style:UIBarButtonItemStylePlain target:self action:@selector(focus)];
    
    
    self.tools.items = [[NSArray alloc]initWithObjects: self.compassBtn,spaceItem, self.filterBtn, self.filterBtnA,self.filterBtnB,self.filterBtnC,spaceItem2, self.weatherBtn, nil];
    [self.view addSubview:self.tools];
}

-(void)drawPins{
    
    self.fetchedFishArray = [self getAllFish];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *today = [NSDate date];
    NSDate *fishDay = [[NSDate alloc]init];
    
    id userLocation = [mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc]initWithArray:[mapView annotations]];
    if(userLocation != nil){
        [pins removeObject:userLocation];
    }
    
    //FilterB
    NSMutableArray *filteredFish = [[NSMutableArray alloc]initWithArray:self.fetchedFishArray];
    for (NSInteger i = 0; i < [filteredFish count]; i++) {
        Fish *fish = [filteredFish objectAtIndex:i];
        if(filterB != -1){
            if (![fish.fishBait isEqualToString:[baitTypes objectAtIndex:filterB ]]) {
                [filteredFish removeObjectAtIndex:i];
                i--;
            }
        }

    }
    
    //filterC
    for(NSInteger i = 0; i < [filteredFish count];i++){
        if (![filterC isEqualToString:@"All"]) {
            Fish *fish = [filteredFish objectAtIndex:i];
            NSString *ttt = [NSString stringWithFormat:@"%@ %@", filterC2, filterC];
            if (![fish.fishType isEqualToString:ttt]) {
                [filteredFish removeObjectAtIndex:i];
                i--;
            }
        }
    }
    
    //filterA
    if (filterA > 0) {
        
            switch(filterA){
                case 1:     //weather
                    for(NSInteger i = 0; i < [filteredFish count];i++){
                        Fish *fish = [filteredFish objectAtIndex:i];
                        if ([fish.fishWeather isEqualToString:currentSummary]) {
                            NSInteger diff = [fish.fishTemperature intValue] - [currentTemp intValue];
                            if (diff < -5 || diff > 5) {
                                [filteredFish removeObjectAtIndex:i];
                                i--;
                            }
                        }else{
                            [filteredFish removeObjectAtIndex:i];
                            i--;
                        }
                    }
                    break;
                case 2:     //weather + wind
                    for(NSInteger i = 0; i < [filteredFish count];i++){
                        Fish *fish = [filteredFish objectAtIndex:i];
                        if ([fish.fishWeather isEqualToString:currentSummary]) {
                            NSInteger diff = [fish.fishTemperature intValue] - [currentTemp intValue];
                            if (diff < -5 || diff > 5) {
                                [filteredFish removeObjectAtIndex:i];
                                i--;
                            }else{
                                if ([fish.fishWindDirection isEqualToString:currentWindDirection]) {
                                    float di = [currentWindMagnitude floatValue] - [fish.fishWindMagnitude floatValue];
                                    if (di < -3 || di > 3) {
                                        [filteredFish removeObjectAtIndex:i];
                                        i--;
                                    }
                                }else{
                                    [filteredFish removeObjectAtIndex:i];
                                    i--;
                                }
                            }
                        }else{
                            [filteredFish removeObjectAtIndex:i];
                            i--;
                        }
                    }
                    break;
                case 3:     //weather + wind + moon
                    for(NSInteger i = 0; i < [filteredFish count];i++){
                        Fish *fish = [filteredFish objectAtIndex:i];
                        if ([fish.fishWeather isEqualToString:currentSummary]) {
                            NSInteger diff = [fish.fishTemperature intValue] - [currentTemp intValue];
                            if (diff < -5 || diff > 5) {
                                [filteredFish removeObjectAtIndex:i];
                                i--;
                            }else{
                                if ([fish.fishWindDirection isEqualToString:currentWindDirection]) {
                                    float di = [currentWindMagnitude floatValue] - [fish.fishWindMagnitude floatValue];
                                    if (di < -3 || di > 3) {
                                        [filteredFish removeObjectAtIndex:i];
                                        i--;
                                    }else{
                                        if (![fish.fishMoon isEqualToString:currentMoon]) {
                                            [filteredFish removeObjectAtIndex:i];
                                            i--;
                                        }
                                    }
                                }else{
                                    [filteredFish removeObjectAtIndex:i];
                                    i--;
                                }
                            }
                        }else{
                            [filteredFish removeObjectAtIndex:i];
                            i--;
                        }
                    }
                    break;
                case 4:     //wind
                    for(NSInteger i = 0; i < [filteredFish count];i++){
                        Fish *fish = [filteredFish objectAtIndex:i];
                        if ([fish.fishWindDirection isEqualToString:currentWindDirection]) {
                            float di = [currentWindMagnitude floatValue] - [fish.fishWindMagnitude floatValue];
                            if (di < -3 || di > 3) {
                                [filteredFish removeObjectAtIndex:i];
                                i--;
                            }
                        }else{
                            [filteredFish removeObjectAtIndex:i];
                            i--;
                        }
                    }
                    break;
                case 5:     //moon
                    for(NSInteger i = 0; i < [filteredFish count];i++){
                        Fish *fish = [filteredFish objectAtIndex:i];
                        if (![fish.fishMoon isEqualToString:currentMoon]) {
                            [filteredFish removeObjectAtIndex:i];
                            i--;
                        }
                    }
                    break;
                case 6:     //wind + moon
                    for(NSInteger i = 0; i < [filteredFish count];i++){
                        Fish *fish = [filteredFish objectAtIndex:i];
                        if ([fish.fishWindDirection isEqualToString:currentWindDirection]) {
                            float di = [currentWindMagnitude floatValue] - [fish.fishWindMagnitude floatValue];
                            if (di < -3 || di > 3) {
                                [filteredFish removeObjectAtIndex:i];
                                i--;
                            }else{
                                if (![fish.fishMoon isEqualToString:currentMoon]) {
                                    [filteredFish removeObjectAtIndex:i];
                                    i--;
                                }
                            }
                        }else{
                            [filteredFish removeObjectAtIndex:i];
                            i--;
                        }
                    }
                    break;
                default:
                    break;
            }
            
    }
    
    NSInteger count = [filteredFish count];

    [mapView removeAnnotations:pins];
    pins = nil;
    pins = [[NSMutableArray alloc]init];
    
    switch (filter){        
        case 0://nofilter
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                [pins addObject:pin];                   
            }
            break;
        case 1://today            
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                fishDay = [dateFormat dateFromString:fish.fishDate];
                NSInteger days = [self daysBetweenDate:fishDay andDate:today];                
                if (days == 0) {
                    CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                    [pins addObject:pin];     
                }
            }
            break;
        case 2:// this week
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                NSInteger days = [self daysBetweenDate:[dateFormat dateFromString:fish.fishDate] andDate:[NSDate date]];
                if(days <= 7){
                    CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                    [pins addObject:pin];    
                }    
            }
            break;
        case 3://this month
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                NSDateComponents *fishDay = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[dateFormat dateFromString:fish.fishDate]];
                NSDateComponents *today = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
                if([today month] == [fishDay month] || [today year] == [fishDay year]){
                    CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                    [pins addObject:pin]; 
                }
            }
            break;
        case 4://this year
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                NSDateComponents *fishDay = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[dateFormat dateFromString:fish.fishDate]];
                NSDateComponents *today = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
                if([today year] == [fishDay year]){
                    CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                    [pins addObject:pin]; 
                }
            }
            break;
        case 5://time
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                NSInteger hours = [self hoursBetweenDate:[dateFormat dateFromString:fish.fishDate] andDate:[NSDate date]];
                hours %= 24;
                if(hours <= 1){
                    CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                    [pins addObject:pin]; 
                }
            }
            break;            
        case 6://biweek and time
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                NSInteger days = [self daysBetweenDate:[dateFormat dateFromString:fish.fishDate] andDate:[NSDate date]];
                int leap = 0;
                while(days >= 365){
                    if(leap != 3){
                        days -= 365;
                        leap++;
                    }else{
                        days -= 366;
                        leap = 0;
                    }
                }
                if(days <= 7){
                    NSInteger hours = [self hoursBetweenDate:[dateFormat dateFromString:fish.fishDate] andDate:[NSDate date]];
                    hours %= 24;
                    if(hours <= 1){
                        CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                        [pins addObject:pin]; 
                    }  
                } 
            }
            break;
        case 7://month and time
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                NSDateComponents *fishDay = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[dateFormat dateFromString:fish.fishDate]];
                NSDateComponents *today = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
                if([today month] == [fishDay month]){
                    NSInteger hours = [self hoursBetweenDate:[dateFormat dateFromString:fish.fishDate] andDate:[NSDate date]];
                    hours %= 24;
                    if(hours <= 1){
                        CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                        [pins addObject:pin]; 
                    }  
                } 
            }
            break;
        case 8://year and time
            for (NSInteger i = 0; i < count; i++) {
                Fish *fish = [filteredFish objectAtIndex:i];
                NSDateComponents *fishDay = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[dateFormat dateFromString:fish.fishDate]];
                NSDateComponents *today = [[NSCalendar currentCalendar]components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];

                if([today year] == [fishDay year]){
                    NSInteger hours = [self hoursBetweenDate:[dateFormat dateFromString:fish.fishDate] andDate:[NSDate date]];
                    hours %= 24;
                    if(hours <= 1){
                        CustomPin *pin = [[CustomPin alloc] initWithFish:fish];
                        [pins addObject:pin]; 
                    }  
                }
            }
            break;
        default:
            break;
    }
    [mapView addAnnotations:pins];
} 

-(void)setWeather{
    self->APIKey = @"0d92b446f16989f3a2c8173bb8324a24";
    self->weatherLocation = mapView.userLocation.location;
    self->weatherUpdateTime = [NSDate date];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    float lat = mapView.userLocation.coordinate.latitude;
    float lon = mapView.userLocation.coordinate.longitude;
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%f,%f",APIKey,lat,lon]];
    NSData *data = [NSData dataWithContentsOfURL:url];

    if (data != nil) {
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

        if (error == nil) {
            NSDictionary *current = [result valueForKey:@"daily"];
            current =[current valueForKey:@"data"];
            NSArray *moons = [current valueForKey:@"moonPhase"];
            NSArray *sunrise = [current valueForKey:@"sunriseTime"];
            NSArray *sunset = [current valueForKey:@"sunsetTime"];
            
            current = [result valueForKey:@"currently"];
            
            currentTemp = [NSString stringWithFormat:@"%.f",[[current valueForKey:@"temperature"]floatValue]];
            currentFeelsLike = [NSString stringWithFormat:@"%.f",[[current valueForKey:@"apparentTemperature"]floatValue]];
            currentHumidity = [NSString stringWithFormat:@"%.f",[[current valueForKey:@"humidity"]floatValue] * 100];
            currentPrecipProb = [NSString stringWithFormat:@"%.f%%",[[current valueForKey:@"precipProbability"]floatValue] * 100];
            currentSunrise = [sunrise objectAtIndex:0];
            currentSunset = [sunset objectAtIndex:0];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
           // [formatter setLocale:[NSLocale currentLocale]];
            //NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            //[formatter setTimeZone:timeZone];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            double timestamp = [currentSunrise doubleValue];
            NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            currentSunrise = [formatter stringFromDate:tempDate];
            timestamp = [currentSunset doubleValue];
            tempDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            currentSunset = [formatter stringFromDate:tempDate];
            
            currentMoon = [NSString stringWithFormat:@"%@",[moons objectAtIndex:0]];
            currentPrecipIntensity = [NSString stringWithFormat:@"%.03f",[[current valueForKey:@"precipIntensity"]floatValue]];
            if([currentPrecipIntensity floatValue] > 0.000){
                currentPrecipType = [current valueForKey:@"precipType"];
                if ([currentPrecipIntensity floatValue] <= 0.002) {
                    currentPrecipIntensity = @"Very Light";
                }else if([currentPrecipIntensity floatValue] <= 0.017){
                    currentPrecipIntensity = @"Light";
                }else if([currentPrecipIntensity floatValue] <= 0.1){
                    currentPrecipIntensity = @"Moderate";
                }else{
                    currentPrecipIntensity = @"Heavy";
                }
            }else{
                currentPrecipType = @"None";
                currentPrecipIntensity = @"None";
            }
            float moon = [currentMoon floatValue];
            if (moon == 0) {
                currentMoon = @"New";
            }else if(moon > 0 && moon < 0.25){
                currentMoon = @"Waxing Crescent";
            }else if(moon == 0.25){
                currentMoon = @"First Quarter";
            }else if(moon > 0.25 && moon < 0.5){
                currentMoon = @"Waxing Gibbous";
            }else if(moon == 0.5){
                currentMoon = @"Full";
            }else if(moon > 0.5 && moon < 0.75){
                currentMoon = @"Waning Gibbous";
            }else if(moon == 0.75){
                currentMoon = @"Third Quarter";
            }else{
                currentMoon = @"Waning Crescent";
            }
            currentSummary = [NSString stringWithFormat:@"%@",[current valueForKey:@"summary"]];
            currentPressure = [NSString stringWithFormat:@"%@",[current valueForKey:@"pressure"]];
            float baro = [currentPressure floatValue];
            baro *= 0.0295301;
            currentPressure = [NSString stringWithFormat:@"%.02f",baro];
            currentWindMagnitude = [NSString stringWithFormat:@"%.02f",[[current valueForKey:@"windSpeed"]floatValue]];
            if([currentWindMagnitude intValue] != 0){
                NSInteger degrees = [[current valueForKey:@"windBearing"]intValue];
                if (degrees > 337 || degrees < 23) {
                    currentWindDirection = @"N";
                }else if(degrees >= 23 && degrees <= 67){
                    currentWindDirection = @"NE";
                }else if(degrees > 67 && degrees < 113){
                    currentWindDirection = @"E";
                }else if(degrees >= 113 && degrees <= 157){
                    currentWindDirection = @"SE";
                }else if(degrees > 157 && degrees < 203){
                    currentWindDirection = @"S";
                }else if(degrees >= 203 && degrees <= 247){
                    currentWindDirection = @"SW";
                }else if(degrees > 247 && degrees < 293){
                    currentWindDirection = @"W";
                }else{
                    currentWindDirection = @"NW";
                }
            }else{
                currentWindDirection = @"None";
            }
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(IBAction)didTouchUpInsideCalloutDeleteButton:(CustomCalloutAnnotation *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Remove Pin"
                                                   message: @"Are you sure you wish to delete this fish?"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    [alert show];
}



#ifdef FREE
-(IBAction)didTouchUpInsidePaidAdDismissButton:(UIButton *)sender{
    [filterBtn setEnabled:YES];
    [filterBtnA setEnabled:NO];
    [filterBtnB setEnabled:YES];
    [filterBtnC setEnabled:YES];
    [addBtn setEnabled:YES];
    [dmButton removeFromSuperview];
    [dnldButton removeFromSuperview];
    [paidAd removeFromSuperview];
}
-(IBAction)didTouchUpInsidePaidAdDownloadButton:(UIButton *)sender{
    //////////////////////////////////////////////////////
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/fishing-ledger/id931543078?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    

    ////////////////////////////////////////////////////
    [filterBtn setEnabled:YES];
    [filterBtnA setEnabled:NO];
    [filterBtnB setEnabled:YES];
    [filterBtnC setEnabled:YES];
    [addBtn setEnabled:YES];
    [dmButton removeFromSuperview];
    [dnldButton removeFromSuperview];
    [paidAd removeFromSuperview];
}
-(void)drawInterstitial{
    [filterBtn setEnabled:NO];
    [filterBtnA setEnabled:NO];
    [filterBtnB setEnabled:NO];
    [filterBtnC setEnabled:NO];
    [weatherBtn setEnabled:NO];
    [addBtn setEnabled:NO];
    
    //view
    CGSize size = CGSizeMake(self.screenWidth, self.screenHeight);
    paidAd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"freead"]];
    paidAd.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    paidAd.backgroundColor = [UIColor blackColor];
    [self.view addSubview:paidAd];
    
    //text labels
    UILabel *textline = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 290.0, size.width - 10.0, 21.0)];
    textline.text = @"Upgrade to the Full Version now!";
    //textline.textAlignment = UITextAlignmentCenter;
    textline.textColor = [UIColor whiteColor];
    textline.numberOfLines = 2;
    textline.adjustsFontSizeToFitWidth = YES;
    [paidAd addSubview:textline];
    
    UILabel *textline2 = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 325.0, size.width - 10.0, 21.0)];
   // textline2.textAlignment = UITextAlignmentLeft;
    textline2.textColor = [UIColor whiteColor];
    textline2.numberOfLines = 2;
    textline2.adjustsFontSizeToFitWidth = YES;
    textline2.text = @"-Gain access to unlimited weather data to pick your spot more effectively";
    [paidAd addSubview:textline2];
    
    UILabel *textline3 = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 355.0, size.width - 10.0, 21.0) ];
    //textline3.textAlignment = UITextAlignmentLeft;
    textline3.textColor = [UIColor whiteColor];
    textline3.numberOfLines = 2;
    textline3.adjustsFontSizeToFitWidth = YES;
    textline3.text = @"-Access new filters that help you find fish you've caught in similar conditions";
    [paidAd addSubview:textline3];
    
    UILabel *textline4 = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 385.0, size.width - 10.0, 21.0) ];
    //textline4.textAlignment = UITextAlignmentLeft;
    textline4.textColor = [UIColor whiteColor];
    textline4.numberOfLines = 2;
    textline4.adjustsFontSizeToFitWidth = YES;        
    textline4.text = @"-Remove all ads including this obnoxious screen for good so you can fish in peace";
    [paidAd addSubview:textline4];
    
    //dismiss
    dmButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dmButton.frame           = CGRectMake(self.screenWidth - 32.0, 64.0, 32.0, 29.0);
    dmButton.backgroundColor = [UIColor clearColor];
    [dmButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
    [dmButton addTarget:self action:@selector(didTouchUpInsidePaidAdDismissButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dmButton];
    
    //download
    dnldButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dnldButton.frame           = CGRectMake(5.0, self.screenHeight - 55.0, self.screenWidth - 10.0, 50.0);
    dnldButton.backgroundColor = [UIColor greenColor];
    CALayer *dnldBtnLayer = [dnldButton layer];
    [dnldBtnLayer setMasksToBounds:YES];
    [dnldBtnLayer setCornerRadius:5.0f];
    
    [dnldButton setTitle:@"Buy Full Version" forState:UIControlStateNormal];
    [dnldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dnldButton addTarget:self action:@selector(didTouchUpInsidePaidAdDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dnldButton];
}
#endif
- (IBAction)showCurrentWeather:(id)sender {
    if(boolbusy == NO){
        boolbusy = YES;
        self->bugstopper = NO;
        [weatherBtn setImage:[UIImage imageNamed:@"forecastselected"]];
        [addBtn setEnabled:NO];
        [filterBtn setEnabled:NO];
        [filterBtnA setEnabled:NO];
        [filterBtnB setEnabled:NO];
        [filterBtnC setEnabled:NO];
        forecastBtn.frame = CGRectMake(self.screenWidth - 125.0, self.screenHeight - 75.0, 120.0, 31.0);
        [self.view addSubview:forecastBtn];
        UIColor *textColor = [UIColor colorWithRed:0.35f green:0.45f blue:1.0f alpha:1.0f];
        
        if ([currentSummary isEqualToString: @"NULL"]) {
            [self setWeather];
        }else{
            CLLocationDistance distance = [mapView.userLocation.location distanceFromLocation:weatherLocation];
            if(([self hoursBetweenDate:self->weatherUpdateTime andDate:[NSDate date]]>1) || distance > 20000.0){
                [self setWeather];
            }
        }
        
        if (![currentSummary isEqualToString: @"NULL"]) {            
        
            //View
            CGSize size = CGSizeMake(self.screenWidth - 10.0, 178.0);

            weatherView = [[UIView alloc] initWithFrame:CGRectMake((self.screenWidth * 0.5) - (size.width * 0.5), (self.screenHeight * 0.5) - (size.height * 0.5), size.width, size.height)];
            weatherView.backgroundColor   = [UIColor blackColor];

            UILabel *weather = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, 36.0)];
            //weather text
            NSString *weatherString = [NSString stringWithFormat:@"     %@  %@\u00B0F",currentSummary, currentTemp];
            weather.text = weatherString;
            weather.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
            weather.textAlignment = NSTextAlignmentLeft;
            weather.textColor = [UIColor greenColor];
            weather.numberOfLines = 1;
            weather.adjustsFontSizeToFitWidth = YES;
            [weatherView addSubview:weather];
            
            UILabel *weather2 = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 42.0, size.width - 100.0, 21.0)];
            //weather text
            weatherString = [NSString stringWithFormat:@"Humidity: %@%@     Feels Like: %@%@",currentHumidity,@"%",currentFeelsLike, @"\u00B0F"];
            weather2.text = weatherString;
            weather2.textAlignment = NSTextAlignmentCenter;
            weather2.textColor = [UIColor greenColor];
            weather2.numberOfLines = 1;
            weather2.adjustsFontSizeToFitWidth = YES;
            [weatherView addSubview:weather2];
            
            UILabel *weather3 = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 63.0, size.width - 20.0, 21.0)];
            if ([currentPrecipIntensity isEqualToString:@"None"]) {
                weatherString = [NSString stringWithFormat:@"Precipitation Probability: %@     Wind: %@mph %@",currentPrecipProb,currentWindMagnitude,currentWindDirection ];
            }else{
                weatherString = [NSString stringWithFormat:@"Precipitation %@ %@     Wind: %@mph %@",currentPrecipIntensity, currentPrecipType,currentWindMagnitude,currentWindDirection];
            }
            weather3.text = weatherString;
            weather3.textAlignment = NSTextAlignmentCenter;
            weather3.textColor = [UIColor greenColor];
            weather3.numberOfLines = 1;
            weather3.adjustsFontSizeToFitWidth = YES;
            [weatherView addSubview:weather3];
            
            UILabel *weather4 = [[UILabel alloc] initWithFrame:CGRectMake(43.0, 89.0, size.width - 86.0, 21.0)];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *tempA = [[NSDate alloc]init];
            NSDate *tempB = [[NSDate alloc]init];
            tempA = [dateFormat dateFromString:currentSunrise];
            tempB = [dateFormat dateFromString:currentSunset];
            [dateFormat setDateFormat:@"h:mm aaa"];
            NSString *sr = [dateFormat stringFromDate:tempA];
            NSString *ss = [dateFormat stringFromDate:tempB];
            
            weatherString = [NSString stringWithFormat:@"Sunrise: %@    Sunset: %@",sr, ss];
            weather4.text = weatherString;
            weather4.textAlignment = NSTextAlignmentCenter;
            weather4.textColor = [UIColor greenColor];
            weather4.numberOfLines = 1;
            weather4.adjustsFontSizeToFitWidth = YES;
            [weatherView addSubview:weather4];
            
            UILabel *weather5 = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 105.0, size.width - 20.0, 21.0)];
            weatherString = [NSString stringWithFormat:@"Lunar Phase: %@    Pressure: %@",currentMoon, currentPressure];
            weather5.text = weatherString;
            weather5.textAlignment = NSTextAlignmentCenter;
            weather5.textColor = [UIColor greenColor];
            weather5.numberOfLines = 1;
            weather5.adjustsFontSizeToFitWidth = YES;
            [weatherView addSubview:weather5];
            
            UIButton *dismiss = [[UIButton alloc]initWithFrame:CGRectMake(10.0, size.height - 41.0, size.width - 20.0, 31.0)];
            [dismiss setTitle:@"OK" forState:UIControlStateNormal];
            [dismiss setBackgroundColor:textColor];
            [dismiss setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [dismiss addTarget:self action:@selector(didTouchUpInsideDismissWeatherButton:) forControlEvents:UIControlEventTouchUpInside];
            CALayer *dBtnLayer = [dismiss layer];
            [dBtnLayer setMasksToBounds:YES];
            [dBtnLayer setCornerRadius:5.0f];
            [weatherView addSubview:dismiss];
            
            CALayer *viewLayer = [weatherView layer];
            [viewLayer setMasksToBounds:YES];
            [viewLayer setCornerRadius:10.0f];
            [self.view addSubview:weatherView];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Connection Error"
                                                           message: [NSString stringWithFormat:@"Weather data cannot be loaded without access to the internet"]
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (IBAction)forecastButtonLink:(id)sender {
    self->bugstopper = NO;
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.screenWidth, self.screenHeight - 104.0)];
    webView.delegate = self;
    [webView setScalesPageToFit:YES];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://forecast.io/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 3];  
    [webView loadRequest: request]; 
    
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(5.0, webView.bounds.size.height - 31.0, 65.0, 31.0)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor blackColor]];
    [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(didTouchUpInsideDismissForecastWebpageButton:) forControlEvents:UIControlEventTouchUpInside];
    CALayer *bBtnLayer = [back layer];
    [bBtnLayer setMasksToBounds:YES];
    [bBtnLayer setCornerRadius:5.0f];
    [webView addSubview:back];
    
    [self.filterBtn setEnabled:NO];
    [self.filterBtnA setEnabled:NO];
    [self.filterBtnB setEnabled:NO];
    [self.filterBtnC setEnabled:NO];
    [self.addBtn setEnabled:NO];
    [self.weatherBtn setEnabled:NO];
    [self.compassBtn setEnabled:NO];
    [self.mapSelect setEnabled:NO];
    [self.view addSubview:webView];

}

- (IBAction)didTouchUpInsideDismissWeatherButton:(id)sender{
    boolbusy = NO;
    self->bugstopper = YES;
    [weatherBtn setImage:[UIImage imageNamed:@"forecastdeselected"]];
    [addBtn setEnabled:YES];
    [filterBtn setEnabled:YES];
    [filterBtnA setEnabled:YES];
    [filterBtnB setEnabled:YES];
    [filterBtnC setEnabled:YES];
    [weatherBtn setEnabled:YES];
    [forecastBtn removeFromSuperview];
    [weatherView removeFromSuperview];
}

- (IBAction)didTouchUpInsideDismissForecastWebpageButton:(id)sender{
    [webView removeFromSuperview];
    self->bugstopper = YES;
    [self.compassBtn setEnabled:YES];
    [self.mapSelect setEnabled:YES];

}

//- (IBAction)didTouchUpInsideDismissRateWebpageButton:(id)sender{
//    [webView removeFromSuperview];
//    [self.compassBtn setEnabled:YES];
//    [self.mapSelect setEnabled:YES];
//    [self.filterBtn setEnabled:YES];
//    [filterBtnA setEnabled:YES];
//    [self.filterBtnB setEnabled:YES];
//    [self.filterBtnC setEnabled:YES];
//    [self.addBtn setEnabled:YES];
//    [self.weatherBtn setEnabled:YES];
//}

-(NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime{
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:toDateTime];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return [difference day];
}

-(NSInteger)hoursBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime{
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitHour startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitHour startDate:&toDate interval:NULL forDate:toDateTime];
    NSDateComponents *difference = [calendar components:NSCalendarUnitHour fromDate:fromDate toDate:toDate options:0];
    return [difference hour];
}

-(NSInteger)getID{
    NSInteger row = 0; 
    NSInteger limit = [fishnames count];
    for (NSInteger i = 0; i < limit; i++) {
        if([strfish isEqualToString:[fishnames objectAtIndex:i ]]){
            row = i;
            break;
        }
    }
    switch (row){
        case 0:
            for(NSInteger l = 0; l < [bass count]; l++){
                if([strfish2 isEqualToString:[bass objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 1:
            row = [bass count];
            for(NSInteger l = 0; l < [catfish count]; l++){
                if([strfish2 isEqualToString:[catfish objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 2:
            row = [bass count] + [catfish count];
            if([strfish2 isEqualToString:@"White"]){
                row += 1;
            }
            break;
        case 3:
            row = [bass count] + [catfish count] + 2;
            for(NSInteger l = 0; l < [panfish count]; l++){
                if([strfish2 isEqualToString:[panfish objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 4:
            row = [bass count] + [catfish count] + 2 + [panfish count];
            for(NSInteger l = 0; l < [pike count]; l++){
                if([strfish2 isEqualToString:[pike objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 5:
            row = [bass count] + [catfish count] + 2 + [panfish count] + [pike count];
            for(NSInteger l = 0; l < [rough count]; l++){
                if([strfish2 isEqualToString:[rough objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 6:
            row = [bass count] + [catfish count] + 2 + [panfish count] + [pike count] + [rough count];
            for(NSInteger l = 0; l < [salmon count]; l++){
                if([strfish2 isEqualToString:[salmon objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 7:
            row = [bass count] + [catfish count] + 2 + [panfish count] + [pike count] + [rough count] + [salmon count];
            break;
        case 8:
            row = [bass count] + [catfish count] + 2 + [panfish count] + [pike count] + [rough count] + [salmon count] + 1;
            for(NSInteger l = 0; l < [sturgeon count] ; l++){
                if([strfish2 isEqualToString:[sturgeon objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 9:
            row = [bass count] + [catfish count] + 2 + [panfish count] + [pike count] + [rough count] + [salmon count] + 1 + [sturgeon count];
            for(NSInteger l = 0; l < [trout count]; l++){
                if([strfish2 isEqualToString:[trout objectAtIndex:l]]){
                    row += l;
                    break;
                }
            }
            break;
        case 10:
            row = [bass count] + [catfish count] + 2 + [panfish count] + [pike count] + [rough count] + [salmon count] + 1 + [sturgeon count] + [trout count];
            break;
        case 11:
            row = [bass count] + [catfish count] + 2 + [panfish count] + [pike count] + [rough count] + [salmon count] + 1 + [sturgeon count] + [trout count] + 1;
            break;
    }
    return row;
}



@end
