//
//  NewBreadcrumViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "NewBreadcrumViewController.h"
#import <CoreData/CoreData.h>
#import "ACAppDelegate.h"
#import "Location.h"
#import "Breadcrumb.h"
@interface NewBreadcrumViewController ()


@property (nonatomic,strong) NSFetchedResultsController *resultsController;

@property (nonatomic,strong) Location                   *selectedLocation;
@property (nonatomic,strong) Breadcrumb                 *breadCrumb;

@end

@implementation NewBreadcrumViewController

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
    
    // Keyboard notifications

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    
    

    
    // set content size to the y position of notes text + it's height. We assume that the notes field is the last one on the view.


    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    self.resultsController =     [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[APP_DELEGATE managedObjectContext] sectionNameKeyPath:nil cacheName:@"LocationsCache"];
    
    NSError *error = nil;
    [self.resultsController performFetch:&error];
    
    if ([[self.resultsController fetchedObjects]count] == 0){
        self.noLocationsLabel.hidden = NO;
        self.locationPicker.hidden   = YES;
    }else {
        self.noLocationsLabel.hidden = YES;
        self.locationPicker.hidden   = NO;
    }
    
    self.datePicker.maximumDate = [NSDate date];
   
    
}

-(void)viewDidAppear:(BOOL)animated {

}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(IBAction)save:(id)sender{
    NSString * message = nil;
    if ([self isFormValid:&message]){
        
        NSEntityDescription * desc = [NSEntityDescription entityForName:@"Breadcrumb" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
        
        self.breadCrumb = [[Breadcrumb alloc]initWithEntity:desc
                             insertIntoManagedObjectContext:APP_DELEGATE.managedObjectContext];
        
        self.breadCrumb.date = [self.datePicker date];
        
        self.breadCrumb.notes = self.notesTextField.text;
        self.breadCrumb.title = self.nameTextField.text;
        self.breadCrumb.location = [self.resultsController.fetchedObjects objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
        if ([APP_DELEGATE saveContext]){
            
            [self.delegate newBreadcrumController:self
                              didCreateBreadCrumb:self.breadCrumb];
            
        }else {
            NSError *error = [NSError errorWithDomain:@"biz.appcrafter.mybreadcrumb"
                                                 code:1 // Discussion: an error message code structure should be defined
                                             userInfo:[NSDictionary dictionaryWithObject:@"Breadcrumb could not be saved" forKey:NSLocalizedDescriptionKey]];// NSLocalizedString should be used with the appropriate table
            [self.delegate newBreadCrumbController:self failedWithError:error];
            
        }
    }else {
        
    }
    
    
    
}
-(BOOL) isFormValid:(__autoreleasing NSString**)message{
    NSMutableString * string = [[NSMutableString alloc]init];
    BOOL              error  = NO;
    
    if ([self pickerView:nil numberOfRowsInComponent:0]==0){
        [string appendString:@"No location available.\n"];
        error = YES;
    }
    if (self.nameTextField.text.length <= 0){
        [string appendString:@"Write a name"];
        error = YES;
    }
    
    if (error)
        *message = string;
    
    return !error;
    
}

#pragma mark - PickerView data source
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return pickerView.bounds.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 20;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[self.resultsController fetchedObjects]count];
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

#pragma mar - Picker view delegate 
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedLocation = [[self.resultsController fetchedObjects]objectAtIndex:row];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Location * location = [[self.resultsController fetchedObjects]objectAtIndex:row];
    return location.name;
}
#pragma mark - AddLocationDelegate

-(void)locationController:(AddLocationViewController*)controller didAddLocation:(Location*)location {
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSError *error = nil;
    [self.resultsController performFetch:&error];
    self.locationPicker.hidden      = NO;
    self.noLocationsLabel.hidden    = YES;
    [self.locationPicker reloadAllComponents];
    
}
-(void)addLocationCancelled:(AddLocationViewController*)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)locationController:(AddLocationViewController *)controller failedWithError:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
        [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil]show];
        
    }];
}

#pragma mark - Fetched results controller
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    [self.locationPicker reloadAllComponents];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddLocation"]){
        
        UINavigationController             *nc = segue.destinationViewController;
        AddLocationViewController *addLocation = [[nc viewControllers]objectAtIndex:0];
        addLocation.delegate                   = self;
    }
}

#pragma mark UITextField delegate 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.nameTextField.inputAccessoryView == nil) {
        
        self.nameTextField.inputAccessoryView = self.accessoryView;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.notesTextField.inputAccessoryView == nil) {
        
        self.notesTextField.inputAccessoryView = self.accessoryView;
    }

    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
        [textView resignFirstResponder];

}

#pragma mark - Keyboard notifications
-(void)keyboardWillShowNotification:(NSNotification*)notification {
    

}

-(void)keyboardDidShowNotification:(NSNotification*)notification {
    
}
-(void)keyboardWillHideNotification:(NSNotification*)notification {

}

-(void)keyboardDidHideNotification:(NSNotification*)notification {
    
}
-(void)done:(id)sender {
    [self.notesTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}
@end
