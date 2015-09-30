//
//  CustomAnnotationView.m
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annotationViewImage:(UIImage *) avImage{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.image = avImage;
    return self;
}

@end
