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
#import "MSIDTestTokenResponse.h"
#import "MSIDBaseToken.h"
#import "MSIDTestCacheIdentifiers.h"
#import "MSIDTestRequestParams.h"
#import "MSIDAADV1TokenResponse.h"
#import "MSIDAADV1RequestParameters.h"
#import "MSIDAADV2TokenResponse.h"
#import "MSIDAADV2RequestParameters.h"
#import "NSDictionary+MSIDTestUtil.h"

@interface MSIDBaseTokenIntegrationTests : XCTestCase

@end

@implementation MSIDBaseTokenIntegrationTests

#pragma mark - Init

- (void)testInitWithTokenResponse_whenOIDCTokenResponse_shouldFillToken
{
    MSIDTokenResponse *response = [MSIDTestTokenResponse defaultTokenResponseWithAT:DEFAULT_TEST_ACCESS_TOKEN
                                                                                 RT:DEFAULT_TEST_REFRESH_TOKEN
                                                                             scopes:[NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil]
                                                                           username:DEFAULT_TEST_ID_TOKEN_USERNAME
                                                                            subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    MSIDRequestParameters *params = [MSIDTestRequestParams defaultParams];
    
    MSIDBaseToken *token = [[MSIDBaseToken alloc] initWithTokenResponse:response request:params];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    XCTAssertEqualObjects(token.uniqueUserId, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertNil(token.clientInfo);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
}

- (void)testInitWithTokenResponse_whenAADV1TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDBaseToken *token = [[MSIDBaseToken alloc] initWithTokenResponse:response request:params];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
}

- (void)testInitWithTokenResponse_whenAADV1TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDBaseToken *token = [[MSIDBaseToken alloc] initWithTokenResponse:response request:params];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
}

- (void)testInitWithTokenResponse_whenAADV2TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDBaseToken *token = [[MSIDBaseToken alloc] initWithTokenResponse:response request:params];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
}

- (void)testInitWithTokenResponse_whenAADV2TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDBaseToken *token = [[MSIDBaseToken alloc] initWithTokenResponse:response request:params];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
}

@end
