//
//  BreadcrumDetailViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface BreadcrumDetailViewController : UIViewController

@property (nonatomic,strong)    IBOutlet UILabel    *titleLabel;
@property (nonatomic,strong)    IBOutlet UILabel    *dateLabel;
@property (nonatomic,strong)    IBOutlet MKMapView  *mapView;
@property (nonatomic,strong)    IBOutlet UITextView *textView;


-(IBAction)deleteBreadcrum:(id)sender;
@end
