//
//  MapViewController.m
//  Miller
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"
#import "convert.h"

@interface UIImage (RotationMethods)
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees withSize:(CGSize)size;
@end

@implementation UIImage (RotationMethods)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees withSize:(CGSize)size
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,size.width, size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degrees);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width,size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
@end
@interface MapView(){
    //UIImage *arrowImage;
}
@property(nonatomic,strong)UIImage *arrowImage;
@property(nonatomic,strong)PlaceMark *motionPoint;
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t ;
-(void) updateRouteView;
-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;
-(void) centerMap;

@end

@implementation MapView

//@synthesize lineColor;
@synthesize mapView;
- (id) initWithFrame:(CGRect) frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		[mapView setDelegate:self];
		[self addSubview:mapView];
        /*
		routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
		routeView.userInteractionEnabled = NO;
		[mapView addSubview:routeView];
		*/
//		self.lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];
	}
	return self;
}

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
    CLLocation *first = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ] autorelease];
    CLLocation *end = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ] autorelease];
	[array insertObject:first atIndex:0];
    [array addObject:end];
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl];
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	return [self decodePolyLine:[encodedPoints mutableCopy]:f to:t];
}

-(void) centerMap {

	MKCoordinateRegion region;

	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < routes.count; idx++)
	{
		CLLocation* currentLocation = [routes objectAtIndex:idx];
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;

	[mapView setRegion:region animated:YES];
}
- (void)centralMapwithPoints:(NSArray*)points{

    MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < points.count; idx++)
	{
		CLLocation* currentLocation = [points objectAtIndex:idx];
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;
    
	[mapView setRegion:region animated:YES];
}
- (void)centralMapwithPoint:(CLLocationCoordinate2D)point{
    
    MKCoordinateRegion region;
	region.center.latitude     = point.latitude;
	region.center.longitude    = point.longitude;
	region.span.latitudeDelta  = 0.118;
	region.span.longitudeDelta =0.018;
    
	[mapView setRegion:region animated:YES];
}

-(void) showRouteFrom: (Place*) f to:(Place*) t {
	
	if(routes) {
		[mapView removeAnnotations:[mapView annotations]];
		[routes release];
	}
	PlaceMark* from = [[[PlaceMark alloc] initWithPlace:f] autorelease];
	PlaceMark* to = [[[PlaceMark alloc] initWithPlace:t] autorelease];
	
	[mapView addAnnotation:from];
	[mapView addAnnotation:to];
	
	routes = [[self calculateRoutesFrom:from.coordinate to:to.coordinate] retain];
	[self updateRouteView];
	[self centerMap];
}
- (void)addPointToMap:(Place*)f {

    
    PlaceMark* point = [[[PlaceMark alloc] initWithPlace:f] autorelease];
    point.type = f.pointType;
    
    if(f.pointType == 2){
        self.motionPoint = point;
        point.degree = f.degree;
    }
	//PlaceMark* to = [[[PlaceMark alloc] initWithPlace:t] autorelease];
	[mapView addAnnotation:point];
	//[mapView addAnnotation:to];
//    if(self.motionPoint){
//        MKAnnotationView *motionPointView = [mapView viewForAnnotation:self.motionPoint];
//        
//        if(motionPointView)
//            [motionPointView removeFromSuperview];
//    }

}
- (void)addMotionPointToMap:(Place*)f{
    
//    for(MKAnnotation *item in mapView.annotations){
//        if(item.pinColor == MKPinAnnotationColorRed){
//            
//        }
//    }
//    MKAnnotationView *motionPointView = [mapView viewForAnnotation:self.motionPoint];
    
    if(self.motionPoint){
        [mapView removeAnnotation:self.motionPoint];
    }
    [self addPointToMap:f];
    //if(motionPointView)
     //[motionPointView removeFromSuperview];
        
    
}
- (void)addPinToMap:(CLLocationCoordinate2D)annotationCoord withName:(NSString*)name{

    //[mapView removeAnnotations:[mapView annotations]];
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = name;
    annotationPoint.subtitle = @"";
    [mapView addAnnotation:annotationPoint];
    [annotationPoint release];
}
- (void)showRouteWithPointsData:(NSArray*)points{
    [routes release];
    routes = [points retain];
    [self centerMap];
    [self updateRouteView];
    
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [view setCanShowCallout:YES];
    NSLog(@"Title:%@",view.annotation.title);
}
-(void) addRouterView:(NSArray*)points{
    CLLocationCoordinate2D pointsToUse[[points count]];
    for (int i = 0; i < [points count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [points objectAtIndex:i];
        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        coords = transform(coords);
        printf("[%lf,%lf]",coords.latitude,coords.longitude);
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[points count]];
    [mapView addOverlay:lineOne];
}
- (void)addRouterView:(CLLocationCoordinate2D *)points withCount:(int)count{
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:points count:count];
    lineOne.title = @"red";
    [mapView addOverlay:lineOne];
}
- (void)clearMapView{

    if([[mapView overlays]count]){
        [mapView removeOverlays:[mapView overlays]];
    }
    //clear motion map
    if([[mapView annotations] count]){
        [mapView removeAnnotations:[mapView annotations]];
    }
    
    
}
- (void)addRouterView:(CLLocationCoordinate2D *)points withCount:(int)count withColor:(NSString*)color withCenter:(BOOL)isCenter{
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:points count:count];
    lineOne.title = color;
    [mapView addOverlay:lineOne];

    if(isCenter){
        float maxLat = points[1].latitude;
        float maxLon = points[1].longitude;
        float minLat = points[1].latitude;
        float minLon = points[1].longitude;
        MKCoordinateRegion region;
        region.center.latitude     = (minLat+maxLat)/2.f;
        region.center.longitude    = (minLon+maxLon)/2.f;
        region.span.latitudeDelta  = maxLat - minLat + 0.018;
        region.span.longitudeDelta = maxLon - minLon + 0.028;
        [mapView regionThatFits:region];
        [mapView setRegion:region animated:YES];
    }
    
}
-(void) updateRouteView {
    [mapView removeOverlays:mapView.overlays];

    CLLocationCoordinate2D pointsToUse[[routes count]];
    for (int i = 0; i < [routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [routes objectAtIndex:i];
        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        coords = transform(coords);
        printf("[%lf,%lf]",coords.latitude,coords.longitude);
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[routes count]];
    lineOne.title = @"green";
    [mapView addOverlay:lineOne];
    
//********************作者源代码********************
//直接画线。
//	CGContextRef context = 	CGBitmapContextCreate(nil, 
//												  routeView.frame.size.width, 
//												  routeView.frame.size.height, 
//												  8, 
//												  4 * routeView.frame.size.width,
//												  CGColorSpaceCreateDeviceRGB(),
//												  kCGImageAlphaPremultipliedLast);
//	
//	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
//	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
//	CGContextSetLineWidth(context, 10);
//	CGContextSetAlpha(context, 0.5);
//    CGContextSetLineJoin(context, kCGLineJoinRound);
//    CGContextSetLineCap(context, kCGLineCapRound);
//	for(int i = 0; i < routes.count; i++) {
//		CLLocation* location = [routes objectAtIndex:i];
//		CGPoint point = [mapView convertCoordinate:location.coordinate toPointToView:routeView];
//		
//		if(i == 0) {
//			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
//		} else {
//			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
//		}
//	}
//	
//	CGContextStrokePath(context);
//	
//	CGImageRef image = CGBitmapContextCreateImage(context);
//	UIImage* img = [UIImage imageWithCGImage:image];
//	
//	routeView.image = img;
//	CGContextRelease(context);
//
}

#pragma mark mapView delegate functions
//作者源代码
//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
//{
//	routeView.hidden = YES;
//}
//
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//	[self updateRouteView];
//	routeView.hidden = NO;
//	[routeView setNeedsDisplay];
//}
static MKPolylineView *lineview =  nil;
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *targetView = (MKPolyline*)overlay;
        
        //if(lineview == nil)
            lineview=[[MKPolylineView alloc] initWithOverlay:overlay] ;

        if([targetView.title isEqual:@"red"]){
            lineview.strokeColor = [UIColor redColor];
        }
        if([targetView.title isEqualToString:@"yeallow"]){
            lineview.strokeColor = [UIColor yellowColor];
        }
        if([targetView.title isEqualToString:@"green"]){
            lineview.strokeColor = [UIColor greenColor];
        }
        //路线颜色
//        lineview.strokeColor=[UIColor colorWithRed:69.0f/255.0f green:212.0f/255.0f blue:255.0f/255.0f alpha:0.9];
        lineview.lineWidth=8.0;
        
        return [lineview autorelease];
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews NS_DEPRECATED_IOS(4_0, 7_0){


}
//- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers NS_AVAILABLE(10_9, 7_0);{
//    if ([overlay isKindOfClass:[MKPolyline class]])
//    {
//        
//        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay] ;
//        //路线颜色
//        lineview.strokeColor=[UIColor colorWithRed:69.0f/255.0f green:212.0f/255.0f blue:255.0f/255.0f alpha:0.9];
//        lineview.lineWidth=8.0;
//        
//        return lineview;
//    }
//
//}
- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    NSLog(@"add annotation");
    static NSString* ShopAnnotationIdentifier = @"shopAnnotationIdentifier";
    PlaceMark *place = (PlaceMark*)annotation;
    if(place.type == 2){
        ShopAnnotationIdentifier = @"customAnnomation";
    }
    else{
        
        ShopAnnotationIdentifier = @"shopAnnotationIdentifier";
    }
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:ShopAnnotationIdentifier];
    if(place.type == 2){
        if (!pinView) {
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ShopAnnotationIdentifier] autorelease];
            UIImageWithFileName(self.arrowImage, @"run_arrow.png");
            pinView.image = _arrowImage;
            pinView.frame = CGRectMake(0.f, 0.f,_arrowImage.size.width/kScale, _arrowImage.size.height/kScale);
            pinView.animatesDrop = NO;
            CGFloat width = _arrowImage.size.width/4;
            CGFloat height = _arrowImage.size.height/4;
            pinView.centerOffset = CGPointMake(width,height);
            //pinView.centerOffset = CGPointMake(0,0);
            [pinView setCanShowCallout:NO];
            pinView.tag = 3;
        }
        CGFloat fdegree = place.degree/180.f*M_PI;
        NE_LOG(@"rotation:%lf==%lf",place.degree,fdegree);
        //CGAffineTransform rotation = CGAffineTransformMakeRotation(fdegree);
        UIImage *newImage = [_arrowImage imageRotatedByDegrees:fdegree withSize:CGSizeMake(self.arrowImage.size.width/kScale, self.arrowImage.size.height/kScale)];
        //[pinView setTransform:rotation];
        pinView.image = newImage;
        CGFloat width = _arrowImage.size.width/4;
        CGFloat height = _arrowImage.size.height/4;
        pinView.centerOffset = CGPointMake(width-12,height);
        if(kIsIOS7Check){
            //pinView.centerOffset = CGPointMake(2*(-width),2*(height));
        }
    }
    
    else{
        if (!pinView) {
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ShopAnnotationIdentifier] autorelease];
            pinView.pinColor = MKPinAnnotationColorGreen;
            pinView.animatesDrop = YES;
            [pinView setCanShowCallout:YES];
            pinView.tag = 0;
        }
    }
    if(place.type == 1){
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.tag = 1;
    }
    if(place.type == 2){
    }
    return pinView;
}
- (void)dealloc {
	if(routes) {
		[routes release];
	}
	[mapView release];
	[routeView release];
    [super dealloc];
}

@end
