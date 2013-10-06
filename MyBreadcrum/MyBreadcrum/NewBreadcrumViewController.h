//
//  NewBreadcrumViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewBreadcrumViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)    IBOutlet UIPickerView   *locationPicker;
@property (nonatomic,strong)    IBOutlet UIDatePicker   *datePicker;
@property (nonatomic,strong)    IBOutlet UIButton       *createLocationButton;
@property (nonatomic,strong)    IBOutlet UITextView     *notesTextField;


-(IBAction)save:(id)sender;
@end
