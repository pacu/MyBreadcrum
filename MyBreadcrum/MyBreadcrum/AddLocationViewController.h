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
@interface AddLocationViewController : ACBaseFormViewController <MKMapViewDelegate>
@property (nonatomic,strong)    IBOutlet UITextField    *nameTextField;
@property (nonatomic,strong)    IBOutlet UITextField    *addressTextField;
@property (nonatomic,strong)    IBOutlet UISwitch       *locateInMapSwitch;
@property (nonatomic,strong)    IBOutlet UISwitch       *useCurrentLocationSwitch;
@property (nonatomic,strong)    IBOutlet UILabel        *locateInMapLabel;
@property (nonatomic,strong)    IBOutlet UILabel        *useCurrentLocationLabel;
@property (nonatomic,strong)    IBOutlet MKMapView      *mapView;
@property (nonatomic,strong)    IBOutlet UILabel        *errorLabel;
-(IBAction)save:(id)sender;


-(IBAction)useCurrentLocationChanged:(id)sender;

@end
