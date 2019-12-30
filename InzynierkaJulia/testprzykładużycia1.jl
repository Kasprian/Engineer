include("unweightedGraph.jl")
using .unweightedGraph
using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures

g = read_data("out.wppt")
names = read_names("ListaImion")

println("prof. dr hab. Jacek Cichoń")
#Przykład użycia dla prof. dr hab. Jacka Cichonia
for i in 1:3
for j in collect(runrandomwalk(g, 2, 5, 1000, 0.85, true))[1:5]
    for k in names
        if j.first == k.first
            println(k.second," ",j.second)

        end
    end
end
println()
end


println("dr inż. Jakub Lemiesz")
#Przykład użycia dla dr inż. Jakuba Lemiesza
for i in 1:3
for j in collect(runrandomwalk(g, 15, 5, 1000, 0.85, true))[1:5]
    for k in names
        if j.first == k.first
            println(k.second," ",j.second)

        end
    end
end
println()
end
