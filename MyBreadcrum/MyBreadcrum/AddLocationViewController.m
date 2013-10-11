//
//  AddLocationViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "AddLocationViewController.h"
#import "ACAppDelegate.h"
#import "Location.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+MLScreenshot.h"
@interface AddLocationViewController (MKAnnotationCompliance)

@property (nonatomic)   CLLocationCoordinate2D coordinate;

@end

@implementation AddLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.lastResponderInvokesAction = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _longPress= [[UILongPressGestureRecognizer alloc ]initWithTarget:self action:@selector(handleLongPress:)];
    _longPress.minimumPressDuration      = 1.5f;
    _longPress.numberOfTouchesRequired   = 1;
    
    [self.mapView addGestureRecognizer:_longPress];
    self.locateInMapLabel.hidden        = NO;
}
-(void)dealloc {
    _longPress = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
-(IBAction)save:(id)sender{
    NSString *message = nil;
    if ([self isFormValid:&message]){
        
        NSManagedObjectContext * ctx = APP_DELEGATE.managedObjectContext;
        NSEntityDescription *desc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:ctx];
        Location * location = [[Location alloc]initWithEntity:desc insertIntoManagedObjectContext:ctx];
        
        location.address    = self.addressTextField.text; // Description: this could be done with a reverse geocoder
        location.name       = self.nameTextField.text;
        
        if ([self.mapView showsUserLocation]){
            location.longitude  = [NSNumber numberWithDouble:self.mapView.userLocation.location.coordinate.longitude];
            location.latitude   = [NSNumber numberWithDouble:self.mapView.userLocation.location.coordinate.latitude];
            
        }else {
            location.latitude   = [NSNumber numberWithDouble:self.coordinate.latitude];
            location.longitude  = [NSNumber numberWithDouble:self.coordinate.longitude];
        }
        
        // snapshot
        UIImage * snapshot = [self.mapView screenshot];
        location.thumb     = snapshot;

        if ([APP_DELEGATE saveContext]){
            [self.delegate locationController:self didAddLocation:location];
        }else {
            NSError * error = [NSError errorWithDomain:@"biz.appcrafter.mybreadcrum.location"
                                                  code:1
                                              userInfo:[NSDictionary dictionaryWithObject:@"Location could not be saved to database"
                                                                                   forKey:NSLocalizedDescriptionKey]];
            
            [self.delegate locationController:self failedWithError:error];
        }
    }else {
        self.errorLabel.text   = message;
        self.errorLabel.hidden = NO;
    }
    
}

-(BOOL) isFormValid:(__autoreleasing NSString**)message {
    NSMutableString * string = [[NSMutableString alloc]init];
    BOOL error = NO;
    if ([self.nameTextField.text length]<= 0 ) {
        [string appendFormat:@"Name is empty.\n"];
        error = YES;
    }
    if ([self.addressTextField.text length]<=0){
        [string appendFormat:@"Address is empty"];
        error = YES;
    }
    if (!self.mapView.showsUserLocation && !_isAnnotationUsed) { // if you did not annotate your location
        [string appendFormat:@"annotate your location or use current"];
        error = YES;
        
    }

    if (error)
        *message = string;
    return !error;
    
}

-(IBAction)useCurrentLocationChanged:(id)sender{
    if ([self.useCurrentLocationSwitch isOn]) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        _isAnnotationUsed               = NO;
        self.mapView.showsUserLocation  = YES;
        self.locateInMapLabel.hidden    = YES;
        
    }else {
        self.locateInMapLabel.hidden    = NO;
        self.mapView.showsUserLocation  = NO;
        self.locateInMapLabel.hidden    = NO;
    }
}

#pragma mark - MKMapViewDelegate methods

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if (![self.mapView showsUserLocation]){
    NSAssert(annotation == self, @"there should not be two annotations");
    
    MKPinAnnotationView * annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
    return annotationView;
    }
    
    return nil;
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    
}
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    
}
        
#pragma mark - MKAnnotation delegate

-(NSString*)title{
    return self.nameTextField.text;
}

-(NSString*)subtitle {
    return self.addressTextField.text;
}


#pragma mark - long press
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if (![self.mapView showsUserLocation]){ // if the map does not show the current location, allow the user to pin one
        [self.mapView removeAnnotation:self];
        
        CGPoint                         touchPoint = [gestureRecognizer locationInView:self.mapView];
        
        CLLocationCoordinate2D  touchMapCoordinate = [self.mapView convertPoint:touchPoint
                                                          toCoordinateFromView:self.mapView];
        
        self.coordinate                            = touchMapCoordinate;
        _isAnnotationUsed                          = YES;
        
        [self.mapView addAnnotation:self];
    }

}

#pragma mark - MKAnnotation

-(CLLocationCoordinate2D)coordinate {
    return _coordinate;
}
-(void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    _coordinate = coordinate;
}

#pragma mark - actions 
-(IBAction)cancel:(id)sender{
    [self.delegate addLocationCancelled:self];
}

@end
