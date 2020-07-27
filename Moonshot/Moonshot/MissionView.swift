//
//  MissionView.swift
//  Moonshot
//
//  Created by Ramsey on 2020/6/7.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    let allMissions: [Mission]
    let mission: Mission
    let astronauts: [CrewMember]
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    init(mission: Mission, astronauts: [Astronaut], allMissions: [Mission]) {
        self.allMissions = allMissions
        self.mission = mission
        
        var matches = [CrewMember]()

        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }

        self.astronauts = matches
    }
    
    var body: some View {
        GeometryReader { g in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: g.size.width * 0.7)
                        .padding(.top)
                    
                    Text(self.shownLaunchDate(launchDate: self.mission.formattedLaunchDate))
                        .font(.system(size: 12))
                        .foregroundColor(Color.secondary)
                    
                    Text(self.mission.description)
                        .padding()
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, allMissions: self.allMissions)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(self.isCommanderColor(crewMember: crewMember), lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    func isCommanderColor(crewMember: CrewMember) -> Color {
        return crewMember.role.contains("Command") ? Color.orange : Color.primary
    }
    
    func shownLaunchDate(launchDate: String) -> String {
        return launchDate != "N/A" ? "Launch at \(launchDate)" : ""
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[1], astronauts: astronauts, allMissions: missions)
    }
}
