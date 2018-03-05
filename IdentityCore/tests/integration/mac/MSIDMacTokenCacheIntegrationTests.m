// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>
#import "MSIDMacTokenCache.h"
#import "MSIDTokenCacheKey.h"
#import "MSIDTokenCacheItem.h"

@interface MSIDMacTokenCacheIntegrationTests : XCTestCase
@end

@implementation MSIDMacTokenCacheIntegrationTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Tests

- (void)testSerialize_whenCacheIsEmpty_shouldReturnSameOnDeserialize
{
    MSIDMacTokenCache *cache1 = [MSIDMacTokenCache new];
    MSIDMacTokenCache *cache2 = [MSIDMacTokenCache new];
    NSError *error =  nil;
    
    id data = [cache1 serialize];
    BOOL result = [cache2 deserialize:data error:&error];
    
    id rawCache1 = [cache1 valueForKey:@"cache"];
    id rawCache2 = [cache2 valueForKey:@"cache"];
    XCTAssertNil(error);
    XCTAssertTrue(result);
    XCTAssertEqualObjects(rawCache1, rawCache2);
}

- (void)testSerialize_whenCacheHasItems_shouldReturnSameOnDeserialize
{
    MSIDMacTokenCache *cache1 = [MSIDMacTokenCache new];
    // Item 1.
    MSIDTokenCacheItem *token1 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key1 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account" service:@"item1" generic:nil type:nil];
    [cache1 saveToken:token1 key:key1 serializer:nil context:nil error:nil];
    // Item 2.
    MSIDTokenCacheItem *token2 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key2 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account" service:@"item2" generic:nil type:nil];
    [cache1 saveToken:token2 key:key2 serializer:nil context:nil error:nil];
    // Item 3.
    MSIDTokenCacheItem *token3 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key3 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account2" service:@"item3" generic:nil type:nil];
    [cache1 saveToken:token3 key:key3 serializer:nil context:nil error:nil];
    // Item 4.
    MSIDTokenCacheItem *token4 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key4 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account2" service:@"item4" generic:nil type:nil];
    [cache1 saveToken:token4 key:key4 serializer:nil context:nil error:nil];
    NSError *error = nil;
    MSIDMacTokenCache *cache2 = [MSIDMacTokenCache new];
    
    id data = [cache1 serialize];
    BOOL result = [cache2 deserialize:data error:&error];
    
    id rawCache1 = [cache1 valueForKey:@"cache"];
    id rawCache2 = [cache2 valueForKey:@"cache"];
    XCTAssertNil(error);
    XCTAssertTrue(result);
    XCTAssertEqualObjects(rawCache1, rawCache2);
}

- (void)testClear_whenCacheHasItems_shouldClearCache
{
    MSIDMacTokenCache *cache = [MSIDMacTokenCache new];
    // Item 1.
    MSIDTokenCacheItem *token1 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key1 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account" service:@"item1" generic:nil type:nil];
    [cache saveToken:token1 key:key1 serializer:nil context:nil error:nil];
    // Item 2.
    MSIDTokenCacheItem *token2 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key2 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account" service:@"item2" generic:nil type:nil];
    [cache saveToken:token2 key:key2 serializer:nil context:nil error:nil];
    // Item 3.
    MSIDTokenCacheItem *token3 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key3 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account2" service:@"item3" generic:nil type:nil];
    [cache saveToken:token3 key:key3 serializer:nil context:nil error:nil];
    // Item 4.
    MSIDTokenCacheItem *token4 = [MSIDTokenCacheItem new];
    MSIDTokenCacheKey *key4 = [[MSIDTokenCacheKey alloc] initWithAccount:@"test_account2" service:@"item4" generic:nil type:nil];
    [cache saveToken:token4 key:key4 serializer:nil context:nil error:nil];

    [cache clear];
    
    NSArray<MSIDTokenCacheItem *> *items = [cache tokensWithKey:nil serializer:nil context:nil error:nil];
    XCTAssertNotNil(items);
    XCTAssertEqual(items.count, 0);
}

@end
