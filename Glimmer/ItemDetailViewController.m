//
//  ItemDetailViewController.m
//  Glimmer
//
//  Created by Gavin Potts on 12/9/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeDetail:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
