module Id exposing (Id, equals, generate, unwrap)

import Murmur3


type Id
    = Id_ Int


generate : String -> Id
generate text =
    let
        hash =
            Murmur3.hashString 650190 text
    in
    Id_ hash


unwrap : Id -> Int
unwrap (Id_ hash) =
    hash


equals : Id -> Int -> Bool
equals (Id_ hash) val =
    hash == val
