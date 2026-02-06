//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Nathan on 1/23/26.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    var pegCount: Int = 4
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = [.red, .green, .blue, .yellow]) {
//        self.pegCount = Int.random(in: 3...6)
        self.masterCode = Code(kind: .master, pegCount: pegCount)
        self.guess = Code(kind: .guess, pegCount: pegCount)
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices, pegCount: pegCount)
        print(masterCode)
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        if !attempts.contains(attempt) && !attempt.pegs.contains(Code.missing) {
            attempts.append(attempt)
        }
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    mutating func resetGame() {
        let randomPegCount = Int.random(in: 3...6)
        // Clear previous attempts
        self.attempts = []
        // Generate new masterCode
        masterCode.randomize(from: pegChoices, pegCount: randomPegCount)
        // Reset guess to clear
        guess = Code(kind: .guess, pegCount: randomPegCount)
        
    }
}

struct Code: Equatable {
    var kind: Kind
    var pegCount: Int
    var pegs: [Peg]
    
    init(kind: Kind, pegCount: Int) {
        self.kind = kind
        self.pegCount = pegCount
        self.pegs = Array(repeating: Code.missing, count: pegCount)
    }
    
    static let missing: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg], pegCount: Int) {
//        for index in pegChoices.indices {
        pegs = Array(repeating: Code.missing, count: pegCount)
        for index in 0..<pegCount {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
}

// Left off at L4 33:11
