module wpptdata

export read_data, random_walk, runrandomwalk, runrandomwalkfor2, absorbingrandomwalk, findreviewers, makestep

using LightGraphs, SimpleWeightedGraphs
using StatsBase
using DataStructures

function read_data(correlation_file::String)
	open(correlation_file) do file
		ln = split(readline(file))
		numberofUsers=parse(Int64, ln[1])
		g = SimpleWeightedGraph(numberofUsers+8)
		while !eof(file)
			ln = split(readline(file))
			n1 = parse(Int64, ln[1])
			n2 = parse(Int64, ln[2])
			w = parse(Int64, ln[3])
			if w == 0
				sum = 0
				for i in neighbors(g,n2)
					if i <= numberofUsers
						sum = sum + g.weights[n2, i]
					end
				end
				w = sum
				if w == 0
					w = 1
				end
			end
			add_edge!(g, n1, n2, w)
		end
		return g
	end
end


function simple_random_walk(g::SimpleWeightedGraph, start_edge::Int64, numberOfSteps::Int64)
	current_edge = start_edge
	for i in 1 : numberOfSteps
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
	end
return current_edge
end

function makestep(g::SimpleWeightedGraph, current_edge::Int64)
	NeighborsOfVertex = neighbors(g,current_edge)
	sum = 0
	for i in NeighborsOfVertex
			sum = sum + g.weights[current_edge, i]
	end
	chance = rand()
	if chance === 0.0
	chance = 1.0
	end
	current = 0
	for i in NeighborsOfVertex
		current  = current  + g.weights[current_edge, i]
		if chance <= (current/sum)
			current_edge = i
			break
		end
	end
	return current_edge
end


function random_walk(g::SimpleWeightedGraph, start_edge::Int64, numberOfSteps::Int64, prob::Float64)
	current_edge = start_edge
	NeighborsOfStart = neighbors(g,current_edge)
	for i in 1 : numberOfSteps
		if (rand() > prob)
			current_edge = start_edge
		else
			current_edge = makestep(g,current_edge)
		end
	end
	while (current_edge == start_edge || current_edge >28)
	current_edge=makestep(g,current_edge)
	end
return current_edge
end



function runrandomwalk(g::SimpleWeightedGraph, start_edge::Int64, numberOfSteps::Int64, howManyTimes::Int64, prob::Float64)
	x = Vector{Int64}()
	for i in 1:howManyTimes
		proposition = random_walk(g, start_edge , numberOfSteps , prob)
		append!(x, proposition)
	end
	d = countmap(x)
	return OrderedDict(sort(collect(d), by=x->x[2], rev=true))
end

function runrandomwalkfor2(g::SimpleWeightedGraph, firstScientist::Int64, secondScientist, numberOfSteps::Int64, howManyTimes::Int64, prob::Float64)
	x1=runrandomwalk(g, firstScientist, 20, 1000,0.85)
	x2=runrandomwalk(g, secondScientist, 20, 1000,0.85)
	ranking = Vector{Int64}()
	println(collect(x1)[1:20])
	println()
	println(collect(x2)[1:20])
	println()
	println()
	println(merge(+,x1,x2))
end

#list of scientists and reviewers
function absorbingrandomwalk(g::SimpleWeightedGraph, scientist::Int64, reviewers::Array{Int64,1})
	current_edge = scientist
	while true
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
		if current_edge in reviewers
			break
		end
	end
	return current_edge
end

function findreviewers(g::SimpleWeightedGraph, scientists::Array{Int64,1}, reviewers::Array{Int64,1}, howManyTimes::Int64)
	x = Vector{Int64}()
	for i in 1: howManyTimes
		proposition = absorbingrandomwalk(g, scientists[1], reviewers)
		append!(x, proposition)
	end
	d = countmap(x)
	println(OrderedDict(sort(collect(d), by=x->x[2], rev=true)))

end

end
