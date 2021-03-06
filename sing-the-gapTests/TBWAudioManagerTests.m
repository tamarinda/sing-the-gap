//
//  TBWAudioManagerTests.m
//  sing-the-gap
//
//  Created by mariachi on 01/06/14.
//  Copyright (c) 2014 Tamara Bernad. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TBWAudioManager.h"
#import "TBWTextToSpeechService.h"
#import "TBWRecordingService.h"

@interface TBWAudioManagerTests : XCTestCase {
    NSURL *recordingsDirectory;
    NSURL *gapSongsDirectory;
    NSURL *creationsDirectory;
}

@end

@implementation TBWAudioManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSError *error = nil;
    recordingsDirectory = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"recordings"] isDirectory:YES];
    [[NSFileManager defaultManager] createDirectoryAtURL:recordingsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    gapSongsDirectory = [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"gap-songs"] isDirectory:YES];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:gapSongsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    
    creationsDirectory = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"creations"] isDirectory:YES];
    [[NSFileManager defaultManager] createDirectoryAtURL:creationsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAudioFileCreation
{
    
    NSString *songPath = [[gapSongsDirectory path] stringByAppendingPathComponent:@"test.m4a"];
    NSString *recordingPath = [[recordingsDirectory path] stringByAppendingPathComponent:@"campechano.wav"];
    NSString* file = [[creationsDirectory path] stringByAppendingPathComponent:@"mymp3"];
    
    TBWAudioManager *sut = [[TBWAudioManager alloc] init];
    [sut createAudioMixWithBaseAudio:songPath GapAudio:recordingPath AndDestinationPath:file AndMarkerMiliseconds:@[]];
    

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:file];
    XCTAssertTrue(fileExists);
}
- (void)testTextToSpeech{
    
    NSString *recordingFileName = [[recordingsDirectory path] stringByAppendingPathComponent:@"txttospeach"];
 
    TBWTextToSpeechService *sut = [[TBWTextToSpeechService alloc] init];
    [sut textToSpeech:@"how are you?" WithLanguage:@"en" AndGender:@"male" ToFileWithName:recordingFileName];
    
    NSString *recordingPath = [NSString stringWithFormat:@"%@.%@",recordingFileName, [sut getFileExtension]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:recordingPath];
    XCTAssertTrue(fileExists);
    
}
- (void)testRecording{
    NSString *recordingFileName = [[recordingsDirectory path] stringByAppendingPathComponent:@"record"];

    TBWRecordingService *sut = [[TBWRecordingService alloc] init];
    [sut recordAudioWithDuration:2.0 ToFileWithName:recordingFileName];
    
    NSString *recordingPath = [NSString stringWithFormat:@"%@.%@",recordingFileName, [sut getFileExtension]];
    
    XCTAssertTrue(YES);
    
}

@end
