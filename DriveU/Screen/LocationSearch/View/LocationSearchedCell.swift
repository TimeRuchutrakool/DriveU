//
//  LocationSearchedCell.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct LocationSearchedCell: View {
    let title: String
    let subtitle: String
    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .imageScale(.large)
                .foregroundColor(Color(.systemBlue))
            VStack(alignment: .leading){
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding(.leading)
            Spacer()
        }
        .padding()
    }
}

struct LocationSearchedCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchedCell(title: "Starbucks", subtitle: "Silom Complex")
    }
}

