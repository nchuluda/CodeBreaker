//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Nathan on 12/5/25.
//
import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    var matches: [Match]
    
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
            if matches.count > 4 {
                VStack {
                    matchMarker(peg: 4)
                    matchMarker(peg: 5)
                }
            }
        }
    }
    
    
    func matchMarker(peg: Int) -> some View {
        let exactCount: Int = matches.count { $0 == .exact }
        let foundCount: Int = matches.count { $0 != .nomatch }
//        let exactCount: Int = matches.count(where: { match in match == .exact })
//        let foundCount: Int = matches.count(where: { match in match != .nomatch })

        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2).aspectRatio(1, contentMode: .fit)
    }
}



#Preview {
    VStack {
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact])
        MatchMarkersPreview(matches: [.exact, .nomatch, .nomatch])
        MatchMarkersPreview(matches: [.exact, .exact, .inexact, .inexact])
        MatchMarkersPreview(matches: [.exact, .exact, .inexact, .nomatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .nomatch, .nomatch])
        MatchMarkersPreview(matches: [.exact, .exact, .exact, .inexact, .nomatch, .nomatch])
        MatchMarkersPreview(matches: [.exact, .exact, .exact, .inexact, .inexact, .inexact])
        MatchMarkersPreview(matches: [.exact, .exact, .inexact, .inexact, .inexact])
        MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .nomatch, .nomatch])
    }
}

struct MatchMarkersPreview: View {
    let matches: [Match]
    var body: some View {
        HStack {
            ForEach(1...matches.count, id: \.self) { _ in
                Circle()
            }
            MatchMarkers(matches: matches)
            Spacer()
        }
        .padding()
    }
}

// Start at lecture 3! 1/15/26

// 9 minutes left of this video https://www.youtube.com/watch?v=63UHypFKRRM&list=PLoROMvodv4rPHblRXKsJCQs8TLGpiCTrG&index=3
