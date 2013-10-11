//
//  AddLocationViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ACBaseFormViewController.h"
@class Location;
@protocol AddLocationDelegate;

@interface AddLocationViewController : ACBaseFormViewController <MKMapViewDelegate, MKAnnotation>
{
    @private
    CLLocationCoordinate2D          _coordinate;
    UILongPressGestureRecognizer    *_longPress;
    BOOL                            _isAnnotationUsed;
}

@property (nonatomic,strong)    IBOutlet UITextField            *nameTextField;
@property (nonatomic,strong)    IBOutlet UITextField            *addressTextField;
@property (nonatomic,strong)    IBOutlet UISwitch               *locateInMapSwitch;
@property (nonatomic,strong)    IBOutlet UISwitch               *useCurrentLocationSwitch;
@property (nonatomic,strong)    IBOutlet UILabel                *locateInMapLabel;
@property (nonatomic,strong)    IBOutlet UILabel                *useCurrentLocationLabel;
@property (nonatomic,strong)    IBOutlet MKMapView              *mapView;
@property (nonatomic,strong)    IBOutlet UILabel                *errorLabel;
@property (nonatomic,assign)    id       <AddLocationDelegate>  delegate;


-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)useCurrentLocationChanged:(id)sender;

@end


@protocol AddLocationDelegate <NSObject>

-(void)locationController:(AddLocationViewController*)controller didAddLocation:(Location*)location;
-(void)addLocationCancelled:(AddLocationViewController*)controller;
-(void)locationController:(AddLocationViewController*)controller failedWithError:(NSError*)error;


@end