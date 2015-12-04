//
//  ExerciseTests.m
//  ExerciseTests
//
//  Created by Vanitha on 04/12/15.
//  Copyright © 2015 Vanitha. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ExerciseTests : XCTestCase

@end

@implementation ExerciseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
- (void)testDataTask
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error, @"dataTaskWithURL error %@", error);
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
            XCTAssertEqual(statusCode, 200, @"status code was not 200; was %ld", (long)statusCode);
        }
        
        //XCTAssertTrue(data, @"data present");
        XCTAssert(data, @"data nil");
        
        // do additional tests on the contents of the `data` object here, if you want
        
        // when all done, Fulfill the expectation//
        
        [expectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
