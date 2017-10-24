

#import "ViewController.h"
#import "CatImageObject.h"
#import "MyCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *imagesArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *smallLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imagesArray = [NSMutableArray new];
    
    [self getImages];
    [self setupSmallLayout];
    self.myCollectionView.collectionViewLayout = self.smallLayout;

}

- (void)setupSmallLayout {
    CGFloat width = (self.view.frame.size.width / 3);
    self.smallLayout = [[UICollectionViewFlowLayout alloc] init];
    self.smallLayout.itemSize = CGSizeMake(width, width);
    self.smallLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.smallLayout.minimumLineSpacing = 0;
    self.smallLayout.minimumInteritemSpacing = 0;
    self.smallLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.myCollectionView.frame), 30);
    self.smallLayout.footerReferenceSize = CGSizeMake(CGRectGetWidth(self.myCollectionView.frame), 15);
    self.smallLayout.sectionHeadersPinToVisibleBounds = YES;
}
- (void)getImages {



    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=4c179dfa16ebec85b1cb4730e58b4d93&tags=cat"]; // 1
    
    // seeting the URL request using the url and the http method
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"GET"; // this is the default one any way
    
    
    // A url session so we can make a request
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    
    // Data task, and the download task
    // Create a task to make the request
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest
                                                   completionHandler:^(NSData * _Nullable data,
                                                                       NSURLResponse * _Nullable response,
                                                                       NSError * _Nullable error) {
               // Here we access HTTP data , Status codes, and JSON
               // If we don't get a 200 status code, error will not be nil
               if (error)
               {
                   NSLog(@"Error getting data");
               }
               else
               {
                   NSError *jsonError = nil;
                   NSDictionary *readStuffDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                   
                   if (jsonError)
                   {
                       NSLog(@"jsonError: %@", jsonError.localizedDescription);
                   }
                   else
                   {
                       NSLog(@"They are: %lu", (unsigned long)readStuffDict.count);
                       //              NSLog(@"They are: %@", readStuffDict.allValues[1]);
                       
                       
                       NSDictionary *masterArray = readStuffDict.allValues[1];
                       NSArray *origImageArray = [masterArray objectForKey:@"photo"];
                       
                       
                       
                       // We now have our data as Objective-C data
                       for (NSDictionary *image in origImageArray) {
                           CatImageObject *tempCat = [[CatImageObject alloc] initWithImageInfo:image];
                           [imagesArray addObject:tempCat];
                           NSString *title = [image objectForKey:@"title"];
                           NSLog(@"%@", title);
                       }
                       
                       NSLog(@"%lu", (unsigned long)imagesArray.count);
                       
                       // Tell the main queue, to do somthing
                       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                           // This will run on the main queue
                           [self.myCollectionView reloadData];
                       }];
                   }
               }
               
           }];
    
    [dataTask resume]; // Like saying start my request
}



- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return imagesArray.count;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"celId" forIndexPath:indexPath];
    CatImageObject *tempCatObject = [imagesArray objectAtIndex:indexPath.row];
//    UIImage *catImage = [UIImage imageNamed:tempCatObject.catImageStr];
    
    NSURL *url = [NSURL URLWithString:tempCatObject.catImageStr]; // 1
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data]; // 2
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            
        cell.imageView.image = image;  // 4
        }];
        
    }]; // 4
    
    [downloadTask resume]; // 5

    NSLog(@"Logged Image to cell");

    
    return cell;
}




@end
