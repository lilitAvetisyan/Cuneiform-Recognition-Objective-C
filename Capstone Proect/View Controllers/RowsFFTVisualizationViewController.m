//
//  RowsFFTVisualizationViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/15/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "RowsFFTVisualizationViewController.h"
#import "Complex.h"
#include <math.h>

@interface RowsFFTVisualizationViewController (){
    NSMutableArray* finalFunctionG;
    NSMutableArray* inputArr;
    
}

@end

@implementation RowsFFTVisualizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self transformProjectionToComplex];
    [self discreteFourierTrasnform];
    // Do any additional setup after loading the view.
}
-(void)transformProjectionToComplex{
    for (int i = 0; i < _rows.count; i++) {
        Complex* complex = [[Complex alloc] init];
        complex.re = i;
        complex.im = [_rows[i] doubleValue];
        
        [inputArr addObject:complex];
        
    }
}

-(void)discreteFourierTrasnform{
    int n = (int)inputArr.count;
    
    for (int k = 0; k < n; k++) { // foreach output element
        double sumreal = 0;
        double sumimag = 0;
        for (int t = 0; t < n; t++) { //for each input element
            double angle = 2 * M_PI * t * k / n;
            sumreal += [inputArr[t] re] *cos(angle) + [inputArr[t] im]*sin(angle);
            sumimag +=  [inputArr[t] im] * cos(angle) - [inputArr[t] re] * sin(angle);
        }
        
        Complex* complex = [[Complex alloc] init];
        complex.re = sumreal;
        complex.im = sumimag;
        
        [finalFunctionG addObject:complex];
        
    }
    
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
