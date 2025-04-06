//
//  Task.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation

struct Task: Identifiable, Equatable {
    let id: UUID
    let title: String
    var isCompleted: Bool
    var dueDate: Date?
}

enum TaskCategory: String, CaseIterable, Codable {
    case work = "Work"
    case personal = "Personal"
    case shopping = "Shopping"
    case health = "Health"
    case others = "Others"
}
