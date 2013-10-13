//
//  BreadcrumDetailViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "BreadcrumDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
@interface BreadcrumDetailViewController ()

@end

@implementation BreadcrumDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.titleLabel.text    = self.breadcrumb.title;
    self.textView.text      = self.breadcrumb.notes;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text     = [formatter stringFromDate:self.breadcrumb.date];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.mapView addAnnotation:self];

}
-(void)viewDidAppear:(BOOL)animated {
    [self.mapView showAnnotations:[NSArray arrayWithObject:self] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - actions
-(IBAction)deleteBreadcrum:(id)sender{
    
    [self.delegate breadcrumbDetailController:self didDelete:self.breadcrumb];

}

#pragma mark - mapview delegate 
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if (annotation == self ){
        MKPinAnnotationView * pin = [[MKPinAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"annotation"];
        return pin;
    }
    return nil;
}

#pragma  mark - MKAnnotation 
-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.breadcrumb.location.latitude doubleValue], [self.breadcrumb.location.longitude doubleValue]);
    return coord;
    
    
}
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    return;
}

-(NSString*)title {
    return self.breadcrumb.title;
    
}
-(NSString*)subtitle{
    return self.breadcrumb.location.name;
}

@end
