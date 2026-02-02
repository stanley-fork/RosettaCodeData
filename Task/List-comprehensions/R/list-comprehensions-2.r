subset(expand.grid(x=1:20, y=1:20, z=1:20), x^2 + y^2 == z^2) |> print(row.names=FALSE)
