//
//  NewBreadcrumViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddLocationViewController.h"
#import <CoreData/CoreData.h>
@class Breadcrumb;
@protocol NewBreadcrumDelegate;
@interface NewBreadcrumViewController : UIViewController    <UIPickerViewDataSource,
                                                            UIPickerViewDelegate,
                                                            AddLocationDelegate,
                                                            NSFetchedResultsControllerDelegate>

@property (nonatomic,strong)    IBOutlet UIPickerView   *locationPicker;
@property (nonatomic,strong)    IBOutlet UIDatePicker   *datePicker;
@property (nonatomic,strong)    IBOutlet UIButton       *createLocationButton;
@property (nonatomic,strong)    IBOutlet UITextView     *notesTextField;
@property (nonatomic,strong)    IBOutlet UIView         *loadingView;
@property (nonatomic,strong)    IBOutlet UILabel        *noLocationsLabel;
@property (nonatomic,weak)      id<NewBreadcrumDelegate> delegate;
-(IBAction)save:(id)sender;

@end

@protocol NewBreadcrumDelegate <NSObject>

-(void)newBreadcrumController:(NewBreadcrumViewController*)controller didCreateBreadCrumb:(Breadcrumb*)breadcrumb;
-(void)newBreadCrumbControllerCancelled:(NewBreadcrumViewController*)controller;
-(void)newBreadCrumbController:(NewBreadcrumViewController*)controller failedWithError:(NSError*)error;

@end
