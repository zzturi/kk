//
//  PlaceMark.h
//  Miller
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface PlaceMark : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate;
	Place* place;
}
@property (nonatomic,assign)int type;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) Place* place;
@property (nonatomic,assign)CGFloat degree;

-(id) initWithPlace: (Place*) p;

@end
