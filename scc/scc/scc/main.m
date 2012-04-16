//
//  main.m
//  scc
//
//  Created by Liang Huang on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#import "ConciseKit.h"

@interface Edge : NSObject
{
    int head;
    int tail;
}

@property (nonatomic, assign) int head;
@property (nonatomic, assign) int tail;

- (void)print;

@end

@implementation Edge

@synthesize head, tail;

- (void)print
{
    NSLog(@"\tedge: %d -> %d\n", tail, head);
}

@end

@class Node;

NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}

@interface Node : NSObject 
{
    int index;
    NSMutableArray *incomingEdges;
    NSMutableArray *outgoingEdges;
    
    int finishingTime;
    BOOL isExplored;
}

@property (nonatomic, assign) int index;
@property (nonatomic, assign) int finishingTime;
@property (nonatomic, assign) BOOL isExplored;

- (NSMutableArray *)incomingEdges;
- (NSMutableArray *)outgoingEdges;
- (void)addIncomingEdge:(Edge *)e;
- (void)addOutgoingEdge:(Edge *)e;
- (id)initWithIndex:(int)theIndex;
- (void)print;
@end

@implementation Node

@synthesize finishingTime, isExplored, index;

- (id)initWithIndex:(int)theIndex
{
    if (self = [super init]) {
        index = theIndex;
        isExplored = NO;
        incomingEdges = [[NSMutableArray array] retain];
        outgoingEdges = [[NSMutableArray array] retain];
    }
    return self;
}

- (BOOL)isEqual:(id)anObject
{
    if (![anObject isKindOfClass:[Node class]]) {
        return NO;
    }
    return self.index == ((Node *)anObject).index;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%d", index];
}

- (void)print
{
    NSLog(@"node: %d, ft: %d\n", index, finishingTime);
    NSLog(@"  incoming edges: %lu\n", [incomingEdges count]);
    for (Edge *e in incomingEdges) {
        [e print];
    }
    NSLog(@"  outgoing edges: %lu\n", [outgoingEdges count]);
    for (Edge *e in outgoingEdges) {
        [e print];
    }
}

- (NSMutableArray *)incomingEdges
{
    return incomingEdges;
}
- (NSMutableArray *)outgoingEdges
{
    return outgoingEdges;
}

- (void)addIncomingEdge:(Edge *)e
{
    [incomingEdges addObject:e];
}
- (void)addOutgoingEdge:(Edge *)e
{
    [outgoingEdges addObject:e];
}

- (void)dealloc
{
    [incomingEdges release];
    [outgoingEdges release];
    [super dealloc];
}

@end



//@interface Edge : NSObject
//{
//    Node *tail;
//    Node *head;
//}
//
//@property (nonatomic, retain)Node *tail;
//@property (nonatomic, retain)Node *head;
//
//- (id)initWithTail:(Node *)aTail andHead:(Node *)aHead;
//- (NSString *)key;
//
//- (void)print;
//@end
//
//@implementation Edge
//@synthesize head, tail;
//
//- (id)initWithTail:(Node *)aTail andHead:(Node *)aHead
//{
//    if (self = [super init]) {
//        tail = [aTail retain];
//        head = [aHead retain];
//    }
//    return self;
//}
//
//- (BOOL)isEqual:(id)anObject
//{
//    if (![anObject isKindOfClass:[Edge class]]) {
//        return NO;
//    }
//    Edge *another = (Edge *)anObject;
//    return [self.head isEqual:another.head] && [self.tail isEqual:another.tail];
//}
//
//- (NSString *)description 
//{
//    return [NSString stringWithFormat:@"%@,%@", tail, head];
//}
//
//- (NSString *)key
//{
//    return [NSString stringWithFormat:@"%d,%d", tail.index, head.index];
//}
//
//- (void)print
//{
//    NSLog(@"\tedge: %@ -> %@\n", tail, head);
//}
//
//- (void)dealloc
//{
//    [head release];
//    [tail release];
//    [super dealloc];
//}
//
//@end

@interface Graph : NSObject
{
    NSMutableDictionary *nodes;
//    NSMutableSet *edges;
}

@property (nonatomic, retain)NSMutableDictionary *nodes;
//@property (nonatomic, retain)NSMutableSet *edges;

+ (Graph *)parseFile:(NSString *)file;
+ (Graph *)parseList:(NSArray *)list;

- (void)print;

- (void)findFinishingTimes:(NSMutableArray *)orderedNodesByFT;
- (void)findSCC;
@end

@implementation Graph

@synthesize nodes;

- (id)init
{
    if (self = [super init]) {
        nodes = [[NSMutableDictionary dictionary] retain];
//        edges = [[NSMutableSet set] retain];
    }
    return self;
}

- (void)startDFSWith:(Node *)node andFT:(unsigned long *)ft andList:(NSMutableArray *)orderedNodesByFT
{
    node.isExplored = YES;
    for (id e in node.incomingEdges) {
        Node *next = [nodes objectForKey:[NSNumber numberWithInt:[e tail]]];
        if (!next.isExplored) {
            [self startDFSWith:next andFT:ft andList:orderedNodesByFT];
        }
    }
    (*ft)++;
    node.finishingTime = (*ft);
    [orderedNodesByFT insertObject:node atIndex:0];
}

- (void)findFinishingTimes:(NSMutableArray *)orderedNodesByFT
{
    unsigned long ft = 0;
    for (Node *node in [nodes allValues]) {
//    [nodes $each:^(id key, Node *node) {
        if (!node.isExplored) {
            [self startDFSWith:node andFT:(unsigned long *)&ft andList:orderedNodesByFT];
        }
    }
}

- (void)startDFS2With:(Node *)node andSCC:(NSMutableArray *)scc
{
    node.isExplored = YES;
//    NSArray *es = [node.outgoingEdges allObjects];
//    unsigned long count = [es count];
    for (id e in node.outgoingEdges) {
//    for (unsigned long i = 0; i++; i < count) {
//        Edge *e = [es objectAtIndex:i];
        Node *next = [nodes objectForKey:[NSNumber numberWithInt:[e head]]];
        if (!next.isExplored) {
            [self startDFS2With:next andSCC:scc];
        }
    }
    [scc addObject:node];
}

- (void)findSCC
{
    NSMutableArray *orderedNodesByFT = [NSMutableArray array];
    [self findFinishingTimes:orderedNodesByFT];
    [nodes $each:^(id key, Node *node) {
        node.isExplored = NO;
    }];
    NSMutableArray *sccs = [NSMutableArray array];
    [orderedNodesByFT $each:^(Node *node) {
        if (!node.isExplored) {
            NSMutableArray *scc = [NSMutableArray array];
            [self startDFS2With:node andSCC:scc];
            [sccs addObject:scc];
        }
    }];
    NSArray *sortedSCCs = [sccs sortedArrayUsingComparator:^(id scc1, id scc2) {
        if ([scc1 count] < [scc2 count]) {
            return (NSComparisonResult)NSOrderedDescending;
        } 
        if ([scc1 count] > [scc2 count]) {
            return (NSComparisonResult)NSOrderedAscending;
        } 
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSLog(@"scc count: %lu", [sortedSCCs count]);
    __block int i =0;
    [sortedSCCs $eachWithStop:^(NSArray *scc, BOOL *stop) {
        NSLog(@"scc %lu", [scc count]);
//        NSLog(@"%@", scc);
        i++;
        if (i > 7) *stop = YES;
    }];
}

- (void)print
{
    [nodes $each:^(id key, id node) {
        [node print];
    }];
}

- (void)dealloc
{
    [nodes release];
//    [edges release];
    [super dealloc];
}

+ (void)fillGraph:(Graph *)g with:(NSArray *)r 
{
    if ([r count] < 2) {
        return;
    }
    NSNumber *tail_index = [NSNumber numberWithInt:[[r objectAtIndex:0] intValue]];
    NSNumber *head_index = [NSNumber numberWithInt:[[r objectAtIndex:1] intValue]];
    if (![g.nodes objectForKey:tail_index]) {
        Node *n = [[Node alloc] initWithIndex:tail_index.intValue];
        [g.nodes setObject:n forKey:tail_index];
        [n release];
    }
    if (![g.nodes objectForKey:head_index]) {
        Node *n = [[Node alloc] initWithIndex:head_index.intValue];
        [g.nodes setObject:n forKey:head_index];
        [n release];
    }
    Node *tail_node = [g.nodes objectForKey:tail_index];
    Node *head_node = [g.nodes objectForKey:head_index];
    Edge *e = [[Edge alloc] init];
    e.tail = tail_node.index;
    e.head = head_node.index;
//    [g.edges addObject:e];
    [tail_node addOutgoingEdge:e];
    [head_node addIncomingEdge:e];
    [e release];
}

+ (Graph *)parseList:(NSArray *)list
{
    Graph *g = [[[Graph alloc] init] autorelease];
    for (NSArray *r in list) {
        [self fillGraph:g with:r];
    }
    return g;
}

+ (Graph *)parseFile:(NSString *)file
{
    Graph *g = [[[Graph alloc] init] autorelease];
    FILE *f = fopen([file UTF8String], "r");
    int i = 0;
    while(!feof(f))
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        NSString *line = readLineAsNSString(f);
//        NSLog(@"%@", line);
        i++;
        NSArray *r = [[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self fillGraph:g with:r];
        if (i % 100000 == 0) {
            NSLog(@"processed %d lines", i);
        }
        [pool drain];
    }
    NSLog(@"processed %d lines", i);
    fclose(f);
    
    return g;
}



@end

int main(int argc, const char * argv[])
{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        Graph *g = [Graph parseFile:@"/Users/huangliang/code/algorithm/scc/data2/scc-aa"];
        
//        NSArray *list = $arr($arr(@"1", @"3"), $arr(@"3", @"2"), $arr(@"2", @"1"), $arr(@"3", @"4"), $arr(@"4", @"5"), $arr(@"4", @"6"), $arr(@"1", @"7"), $arr(@"7", @"8"), $arr(@"8", @"7"), $arr(@"5", @"6"), $arr(@"6", @"4"), $arr(@"9", @"10"), $arr(@"10", @"9"));
//        NSLog(@"array: %lu", [list count]);
//        Graph *g = [Graph parseList:list];
        
        NSLog(@"Graph nodes: %lu", [g.nodes count]);
        NSLog(@"start to find scc");
//        [g.edges enumerateObjectsUsingBlock:^(id e, BOOL *stop) {
//            [e print];
//        }];
//        [[g.nodes objectForKey:@"217360"] print];
        [g findSCC];
        
        
        
//        NSMutableSet *s = [NSMutableSet set];
//        [s addObject:[[Node alloc] initWithIndex:1]];
//        [s addObject:[[Node alloc] initWithIndex:1]];
//        [s addObject:@"1"];
//        [s addObject:@"1"];
//        NSLog(@"%lu", [s count]);
    [pool drain];
    return 0;
}

