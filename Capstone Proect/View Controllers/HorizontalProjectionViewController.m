//
//  HorizontalProjectionViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/13/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "HorizontalProjectionViewController.h"
#import "RowsProjectionSootheningViewController.h"

@interface HorizontalProjectionViewController (){
    
    IBOutlet UIView *projectionView;
}

@end

@implementation HorizontalProjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    projectionView.hidden = YES;
    self.title = @"Row projection";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Back";
    self.navigationItem.backBarButtonItem = barButton;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Smooth" style:UIBarButtonItemStylePlain target:self action:@selector(smoothen)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [self optimizeRowsArray];
    [self createProjection];
    [self printArray];
    // TODO: add button on navigation bar which will lead to the DFT page
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)printArray{
    NSLog(@"%@", _rows);
    for (int i = 0; i < self.rows.count; i++) {
//        NSLog(@"%@", _rows[i]);
//        NSLog(<#NSString * _Nonnull format, ...#>)
        
    }
}
-(void)optimizeRowsArray{
    NSNumber *min = [self.rows valueForKeyPath:@"@min.intValue"];
    NSLog(@"minimal value in array :%@", min);
    for (int i = 0; i < self.rows.count; i++) {
        NSNumber *newValue = [NSNumber numberWithInt:([_rows[i] intValue] - [min intValue])];
        _rows[i] = newValue;

    }
}
-(void)createProjection{
    for (int i = 0; i < self.rows.count; i++) {
        float width = self.view.frame.size.width;
        float lineWidth = width*width/[self.rows[i] intValue];
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 30+i, lineWidth, 1 )];
        NSLog(@"rows[i] :%f", lineWidth);
        NSLog(@"rows.count :%lu", (unsigned long)self.rows.count);
        [line setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:line];
    }
}

-(void)smoothen{
    RowsProjectionSootheningViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RowsFFTVisualizationViewController"];
    vc.rows = self.rows;
    vc.image = self.image;

    [self.navigationController pushViewController:vc animated:NO];
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
