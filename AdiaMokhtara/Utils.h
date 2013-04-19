//
//  Utils.h
//  AdiaMokhtara
//
//  Created by Lion User on 18/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//
static NSString * const kBWUtilitiesVersion = @"1.1.2";
static NSString * const kAlertTitle = @"Duaa";
static BOOL const kMessageActive = YES;

// populated from loadDidView
UITextView * messageTextView;

void message ( NSString *format, ... );
void alertMessage ( NSString *format, ... );
NSString * flattenHTML ( NSString * html );
NSString * trimString ( NSString * string );
