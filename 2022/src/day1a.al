def run(input) = {
    input
        |> String.split("\n\n")
        |> Enum.map(/x/
            String.split(x, "\n")
                |> Enum.map(Int.from_string)
                |> Enum.sum()
        )
        |> Enum.max()
}

def main() = File.read_string(".input.txt") |> run() |> println()