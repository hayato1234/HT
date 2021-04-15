//
//  UnitRow.swift
//  HayaTan
//
//  Created by Hayato Moritani on 3/30/21.
//

import SwiftUI

struct UnitRow: View {
    var unit: Unit
    var body: some View {
        Text(unit.unitName)
    }
}

struct UnitRow_Previews: PreviewProvider {
    static var previews: some View {
        UnitRow(unit: <#Unit#>)
    }
}
