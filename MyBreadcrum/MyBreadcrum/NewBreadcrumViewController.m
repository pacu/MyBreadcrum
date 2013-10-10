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
@interface NewBreadcrumViewController ()


@property (nonatomic,strong) NSFetchedResultsController *resultsController;

@property (nonatomic,strong) Location                   *selectedLocation;
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
    
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    self.resultsController =     [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[APP_DELEGATE managedObjectContext] sectionNameKeyPath:nil cacheName:@"LocationsCache"];
    
    NSError *error = nil;
    [self.resultsController performFetch:&error];
    
    if ([[self.resultsController fetchedObjects]count] == 0){
        self.noLocationsLabel.hidden = NO;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(IBAction)save:(id)sender{
    
}


#pragma mark - PickerView data source

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

-(void)locationController:(AddLocationViewController*)controller didAddLocation:(Location*)location{
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSError *error = nil;
    [self.resultsController performFetch:&error];
    
    [self.locationPicker reloadAllComponents];
}
-(void)addLocationCancelled:(AddLocationViewController*)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Fetched results controller


@end
