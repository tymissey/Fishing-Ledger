//
//  CustomAnnotationView.h
//  Fishing Ledger Mini
//
//  Created by Ty Missey on 7/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Mapkit/Mapkit.h>

@interface CustomAnnotationView : MKAnnotationView{

}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annotationViewImage:(UIImage *) avImage;

@end
