//
//  UploadImageViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 4/8/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "UploadImageViewController.h"
#import "TwoDimArray.h"
#import <TesseractOCR/TesseractOCR.h>
#import "HorizontalProjectionViewController.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
@interface UploadImageViewController () <G8TesseractDelegate>{
    
    IBOutlet UIImageView *originalImage;
    IBOutlet UIButton *btnNextStep;
    IBOutlet UIButton *btnUpload;
    TwoDimArray* pixelArray;
    int numRows;
    int numCols;
    NSInteger sumRows;
    NSInteger sumCols;
    
    
    NSMutableArray* rowSums; // use this for the projection graph
    NSMutableArray* colSums;
}

@end

@implementation UploadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rowSums = [[NSMutableArray alloc] init];
    colSums = [[NSMutableArray alloc] init];
    
    pixelArray = [[TwoDimArray alloc] init];
    originalImage.image = self.image;
    
    
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng+ita"];
    tesseract.delegate = self;
}
#pragma mark Button Actions
- (IBAction)btnPhotoTapped:(id)sender {
    UIImage* img = self.image;
    
    originalImage.image =[img g8_grayScale];
    NSLog(@"the image is gray scale");

    // return an array of pixels value of 1 or 0
    NSArray* arr = [[self getImagePixelValues] copy];
    NSLog(@"%@", arr);
    // gets a 2D array of the image pixel
    pixelArray = [[TwoDimArray alloc] initWithRows:numRows cols:numCols values:arr];
    NSLog(@"%d", [pixelArray objectAtRow:0 col:30]);
    [self sumRowsandColomns:pixelArray];
    
}
- (IBAction)btnOpenProjectionTapped:(id)sender {
    
    HorizontalProjectionViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HorizontalProjectionViewController"];
    vc.rows = rowSums;
    [self presentViewController:vc animated:NO completion:nil];
    
}

#pragma mark Helping Functions
-(void)sumRowsandColomns:(TwoDimArray*)arr{
    for (int i = 0; i < numRows; i++) {
        sumRows = 0;
        for (int j = 0; j < numCols; j++) {
            sumRows+= [arr objectAtRow:i col:j];
        }
        [rowSums addObject:[NSNumber numberWithInteger:sumRows]]; // i need this
        NSLog(@"Sum of row %d: %lu", i, (unsigned long)sumRows);
    }
    
//    for (int i = 0; i < numCols; i++) {
//        sumCols = 0;
//        for (int j = 0; j < numRows; j++) {
//            sumCols+= [arr objectAtRow:j col:i];
//        }
//        [colSums addObject:[NSNumber numberWithInteger:sumCols]];
//        NSLog(@"Sum of colomun %d: %lu", i, (unsigned long)sumCols);
//
//    }
}
-(NSMutableArray*)getImagePixelValues{
    CGImageRef cgImg = originalImage.image.CGImage;
    NSUInteger width = CGImageGetWidth(cgImg);
    NSUInteger height = CGImageGetHeight(cgImg);
    numCols = (int)width;
    numRows = (int)height;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSMutableArray* pixArray = [[NSMutableArray alloc] init];
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImg);
    UInt32 * currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
//            printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
            //TODO: change the 127 parameter according to the histogram
            if ((R(color)+G(color)+B(color))/3.0 > 127) {
                [pixArray addObject:@1];
            }
            else
                [pixArray addObject:@0];
            
            currentPixel++;
        }
        printf("\n");
    }
    
    
    return pixArray;
    
}
#pragma mark NOT NEEDED
- (IBAction)btnNextStepTapped:(id)sender {
    
    originalImage.image =[[UIImage imageNamed:@"cuneiform"] g8_grayScale];
    NSLog(@"the image is greyscale");
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
