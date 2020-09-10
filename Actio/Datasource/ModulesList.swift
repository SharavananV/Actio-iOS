//
//  ModulesList.swift
//  Actio
//
//  Created by senthil on 07/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

struct Modules : Codable {
    let id : Int?
    let name : String?
    let image : String?
    let icon : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case image = "image"
        case icon = "icon"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
    }
    
    internal init(id: Int, name: String, image: String, icon: String) {
           self.id = id
           self.name = name
           self.image = image
           self.icon = icon
       }

}
