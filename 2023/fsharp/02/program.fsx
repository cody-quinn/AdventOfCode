#r "nuget: FParsec"

open System.IO
open FParsec

let input = File.ReadAllText(Path.Join(__SOURCE_DIRECTORY__, "input.txt"))

type Amount =
  | Red of int
  | Green of int
  | Blue of int

let ws = pchar ' '

let pred = pstring "red"
let pgreen = pstring "green"
let pblue = pstring "blue"

let pamount =
  many ws >>. pint32 .>> pchar ' ' .>>. (pred <|> pgreen <|> pblue)
  |>> (fun (i, c) ->
    match c with
    | "red" -> Red i
    | "green" -> Green i
    | "blue" -> Blue i
    | _ ->
      eprintfn "Unreachable"
      exit 1)

let pround = sepBy pamount (pchar ',')
let prounds = sepBy pround (pchar ';')
let pgame = pstring "Game " >>. pint32 .>> pstring ": " .>>. prounds
let pgames = many (pgame .>> many (ws <|> newline))

let processRounds round =
  let folder (r, g, b) curr =
    match curr with
    | Red r -> (r, g, b)
    | Green g -> (r, g, b)
    | Blue b -> (r, g, b)

  List.fold folder (0, 0, 0) round

let processGame (id, rounds) = id, List.map processRounds rounds

let games =
  match run pgames input with
  | Success(l, _, _) -> List.map processGame l
  | Failure(s, _, _) ->
    eprintfn $"Error parsing games: %s{s}"
    exit 1

let partOne =
  games
  |> List.map (fun (id, rounds) -> id, List.filter (fun (r, g, b) -> r > 12 || g > 13 || b > 14) rounds)
  |> List.filter (fun (_, r) -> r.Length = 0)
  |> List.map fst
  |> List.sum

let partTwo =
  let reducer (r0, g0, b0) (r1, g1, b1) =
    let r = if r1 > r0 then r1 else r0
    let g = if g1 > g0 then g1 else g0
    let b = if b1 > b0 then b1 else b0
    (r, g, b)

  games
  |> List.map snd
  |> List.map (List.reduce reducer)
  |> List.map (fun (r, g, b) -> r * g * b)
  |> List.sum

printfn $"%A{partOne}"
printfn $"%A{partTwo}"
