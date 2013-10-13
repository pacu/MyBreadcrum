//
//  BreadcrumDetailViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Breadcrumb.h"
@protocol BreadcrumbDetailDelegate;
@interface BreadcrumDetailViewController : UIViewController <MKAnnotation, MKMapViewDelegate>

@property (nonatomic,strong)    IBOutlet UILabel    *titleLabel;
@property (nonatomic,strong)    IBOutlet UILabel    *dateLabel;
@property (nonatomic,strong)    IBOutlet MKMapView  *mapView;
@property (nonatomic,strong)    IBOutlet UITextView *textView;
@property (nonatomic,strong)             Breadcrumb *breadcrumb;


@property (nonatomic,weak)      id<BreadcrumbDetailDelegate> delegate;
-(IBAction)deleteBreadcrum:(id)sender;
@end

@protocol BreadcrumbDetailDelegate <NSObject>

-(void)breadcrumbDetailController:(BreadcrumDetailViewController*)controller didDelete:(Breadcrumb*)breadcrumb;

@end
