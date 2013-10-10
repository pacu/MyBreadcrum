//
//  AddLocationViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "AddLocationViewController.h"
#import "ACAppDelegate.h"
@interface AddLocationViewController ()

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
        
        [APP_DELEGATE saveContext];
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
    
    if (error)
        *message = string;
    return !error;
    
}

-(IBAction)useCurrentLocationChanged:(id)sender{
    if ([self.useCurrentLocationSwitch isOn]) {
        
        self.mapView.showsUserLocation  = YES;
        
    }else {
        self.locateInMapLabel.hidden    = NO;
        self.mapView.showsUserLocation  = NO;
    }
}

#pragma mark - MKMapViewDelegate methods



@end
