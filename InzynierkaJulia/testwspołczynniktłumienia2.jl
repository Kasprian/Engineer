include("unweightedGraph.jl")
using .unweightedGraph
using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures

#Test współczynniku tłumienia dla dwóch autorów

g = read_data("out.wppt")
for k in 1:10
   len = 0
   for a in 1:28
      for b in 1:28
         if a == b
            continue
         end
         for y in 1:10
            x = Array{Int64,1}()
            for i in 1:100
               append!(x, map(x -> x[1],collect(runrandomwalkfor2(g, a, b, 10, 1000, 0.05+0.1*(k-1)))[1:5]))
            end
            m = collect(keys(countmap(x)))
            size = count(r->(r>0), m)
            len=len+size
         end
      end
   end
   println(0.05+0.1*(k-1)," ", len/7840)
end
