//
//  VerticalProjectionViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/22/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "VerticalProjectionViewController.h"
#import "ColumnProjectionSmootheningViewController.h"

@interface VerticalProjectionViewController ()

@end

@implementation VerticalProjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Column projection";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Back";
    self.navigationItem.backBarButtonItem = barButton;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Smooth" style:UIBarButtonItemStylePlain target:self action:@selector(smoothen)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [self optimizeRowsArray];
    [self createProjection];
    
}



-(void)optimizeRowsArray{
    NSNumber *min = [self.colmns valueForKeyPath:@"@min.intValue"];
    NSLog(@"minimal value in array :%@", min);
    for (int i = 0; i < self.colmns.count; i++) {
        NSNumber *newValue = [NSNumber numberWithInt:([self.colmns[i] intValue] - [min intValue])];
        self.colmns[i] = newValue;
        
    }
}
-(void)createProjection{
    for (int i = 0; i < self.colmns.count; i++) {
        float width = self.view.frame.size.width;
        float lineWidth = [self.colmns[i] intValue];
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 30+i, lineWidth, 1 )];
        NSLog(@"columns[i] :%f", lineWidth);
        NSLog(@"columns :%lu", (unsigned long)self.colmns.count);
        [line setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:line];
    }
}

-(void)smoothen{
    ColumnProjectionSmootheningViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ColumnProjectionSmootheningViewController"];
    vc.clmns = self.colmns;
    vc.image = self.image;
    
    [self.navigationController pushViewController:vc animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
