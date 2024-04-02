open System
open System.IO

let input = File.ReadAllText(Path.Join(__SOURCE_DIRECTORY__, "input.txt"))
let lines = input.Split("\n")

let result =
  lines
  |> Array.map (fun line ->
    line
      .Replace("one", "o1e")
      .Replace("two", "t2o")
      .Replace("three", "t3e")
      .Replace("four", "f4r")
      .Replace("five", "f5e")
      .Replace("six", "s6x")
      .Replace("seven", "s7n")
      .Replace("eight", "e8t")
      .Replace("nine", "n9e")
      .ToCharArray())
  |> Array.map (Array.filter Char.IsDigit)
  |> Array.map (fun inner ->
    let i0 = int (inner[0] - '0')
    let i1 = int (inner[inner.Length - 1] - '0')
    i0 * 10 + i1)
  |> Array.sum

printfn $"%A{result}"
