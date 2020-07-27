//
//  AstronautView.swift
//  Moonshot
//
//  Created by Ramsey on 2020/6/7.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let allMissions: [Mission]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    ForEach(self.allRelatedMissions()) { mission in
                        HStack {
                            Image(mission.image)
                                .resizable()
                            .scaledToFit()
                                .frame(width: 75, height: 75)

                            Text(mission.displayName)
                                .font(.headline)

                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    func allRelatedMissions() -> [Mission] {
        var relatedMissions: [Mission] = []
        for mission in self.allMissions {
            let missionCrewNames = mission.crew.map { $0.name }
            if missionCrewNames.contains(astronaut.id) {
                relatedMissions.append(mission)
            }
        }
        return relatedMissions
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], allMissions: missions)
    }
}
