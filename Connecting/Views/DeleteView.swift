//
// Created by bowei xiao on 17.10.20.
//

import SwiftUI

struct DeleteView: View {
  @Binding var deleteId: UUID
  @Binding var deletingCharacter: Bool
  
  @StateObject var characterSet = CharacterSettings()
  
  var characterName:String {
    var name:String = ""
    for character in characterSet.characterSettings {
      if character.id == deleteId {
        name = character.name
      }
    }
    return name
  }
  
  var body: some View {
    VStack {
      Text("Remove \(characterName) from your family list?")
              .font(.headline)
              .foregroundColor(.white)
      .multilineTextAlignment(.center)
      .frame(width: 170)
      
      HStack {
//            Text("\(characterSet.characterSettings.count)")
        Button(action: {
          self.deletingCharacter = false
        }, label: {
          Text("Cancel")
                  .frame(width: 70, height: 35, alignment: .center)
                  .background(Color.secondary)
                  .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        })
        .padding()
        
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
                  .frame(width: 70, height: 35, alignment: .center)
                  .background(Color("characterRedBottom"))
                  .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        })
        .padding()
      }
              .foregroundColor(.white)
    }
  }
}

struct DeleteView_Previews: PreviewProvider {
  static var previews: some View {
    DeleteView(deleteId: .constant(UUID()), deletingCharacter: .constant(false), characterSet: CharacterSettings())
  }
}
