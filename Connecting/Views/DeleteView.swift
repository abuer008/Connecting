//
// Created by bowei xiao on 17.10.20.
//

import SwiftUI

struct DeleteView: View {
    @Binding var deleteId: UUID
    @Binding var deletingCharacter: Bool

    @StateObject var characterSet = CharacterSettings()

    var body: some View {
        HStack {
//            Text("\(characterSet.characterSettings.count)")
            Button(action: {
                self.deletingCharacter = false
            }, label: {
                Text("Cancel")
                    .frame(width: 100, height: 45, alignment: .center)
                    .background(Color.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            })
            
            Button(action: {
                guard characterSet.characterSettings.count > 1 else {
                    return
                }
                withAnimation(.spring()) {
                    characterSet.deleteCharacter(id: deleteId)
                    deletingCharacter.toggle()
                }
            }, label: {
                Text("Delete")
                    .frame(width: 100, height: 45, alignment: .center)
                .background(Color("characterRedBottom"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            })
        }
        .foregroundColor(.white)
    }
}

struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView(deleteId: .constant(UUID()), deletingCharacter: .constant(false), characterSet: CharacterSettings())
    }
}
