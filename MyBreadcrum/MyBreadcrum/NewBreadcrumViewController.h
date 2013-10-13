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
@interface NewBreadcrumViewController : UITableViewController    <UIPickerViewDataSource,
                                                            UIPickerViewDelegate,
                                                            AddLocationDelegate,
                                                            NSFetchedResultsControllerDelegate,
                                                            UITextFieldDelegate,
                                                            UITextViewDelegate>

@property (nonatomic,strong)    IBOutlet UIPickerView   *locationPicker;
@property (nonatomic,strong)    IBOutlet UIDatePicker   *datePicker;
@property (nonatomic,strong)    IBOutlet UIButton       *createLocationButton;
@property (nonatomic,strong)    IBOutlet UITextView     *notesTextField;
@property (nonatomic,strong)    IBOutlet UIView         *loadingView;
@property (nonatomic,strong)    IBOutlet UILabel        *noLocationsLabel;
@property (nonatomic,strong)    IBOutlet UILabel        *errorLabel;
@property (nonatomic,strong)    IBOutlet UITextField    *nameTextField;
@property (nonatomic,strong)    IBOutlet UITableView    *tableView;
@property (nonatomic,weak)      id<NewBreadcrumDelegate> delegate;
@property (nonatomic,strong)    IBOutlet UIView         *accessoryView;

-(IBAction)save:(id)sender;

-(IBAction)done:(id)sender;

@end

@protocol NewBreadcrumDelegate <NSObject>

-(void)newBreadcrumController:(NewBreadcrumViewController*)controller didCreateBreadCrumb:(Breadcrumb*)breadcrumb;
-(void)newBreadCrumbControllerCancelled:(NewBreadcrumViewController*)controller;
-(void)newBreadCrumbController:(NewBreadcrumViewController*)controller failedWithError:(NSError*)error;

@end
