//
//  Member.swift
//  Uplift
//
//  Created by Anatoli Monsalve on 3/22/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Foundation

struct Member: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let imageName: String

    static let sp26members: [Member] = [
        Member(name: "Angela", role: "Pod Lead", imageName: "member_angela"),
        Member(name: "Enzo", role: "APL", imageName: "member_enzo"),
        Member(name: "Selena", role: "Design", imageName: "member_selena"),
        Member(name: "Caitlyn", role: "iOS", imageName: "member_caitlyn"),
        Member(name: "Jiwon", role: "iOS", imageName: "member_jiwon"),
        Member(name: "Anatoli", role: "iOS", imageName: "member_anatoli"),
        Member(name: "Sophie", role: "Backend", imageName: "member_sophie"),
        Member(name: "Chimdi", role: "Backend", imageName: "member_chimdi"),
        Member(name: "Yitbrek", role: "Backend", imageName: "member_yitbrek"),
        Member(name: "Melissa", role: "Android", imageName: "member_melissa"),
        Member(name: "Preston", role: "Android", imageName: "member_preston"),
        Member(name: "Wendy", role: "Marketing", imageName: "member_wendy")
    ]
}
