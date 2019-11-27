module algo

export read_data, random_walk, runrandomwalk, absorbingrandomwalk, findreviewers

using LightGraphs
using StatsBase
using DataStructures

function read_data(file_path::String)
	open(file_path) do file
		ln = split(readline(file))
		g = SimpleGraph(parse(Int64, ln[1]));
		while !eof(file)
			ln = split(readline(file))
			n1 = parse(Int64, ln[1])
			n2 = parse(Int64, ln[2])
			add_edge!(g, n1, n2)
		end
	return g
	end
end


function simple_random_walk(g::SimpleGraph, start_edge::Int64, numberOfSteps::Int64)
	current_edge = start_edge
	for i in 1 : numberOfSteps
		NeighborsOfVertex = neighbors(g,current_edge)
		#println(NeighborsOfVertex)
		a = rand(1:length(NeighborsOfVertex))
		#println(a)
		current_edge = NeighborsOfVertex[a]
		#println(current_edge)
	end
return current_edge
end

function random_walk(g::SimpleGraph, start_edge::Int64, numberOfSteps::Int64,prob::Float64)
	current_edge = start_edge
	NeighborsOfStart = neighbors(g,current_edge)
	while true
		a = rand(1:length(NeighborsOfStart))
		current_edge = NeighborsOfStart[a]
		NeighborsOfVertex = neighbors(g,current_edge)
		a = rand(1:length(NeighborsOfVertex))
		current_edge = NeighborsOfVertex[a]
		if !(current_edge in NeighborsOfStart)
			break
		end
	end
	for i in 1 : numberOfSteps
		if (rand() < prob)
			while true
				a = rand(1:length(NeighborsOfStart))
				current_edge = NeighborsOfStart[a]
				NeighborsOfVertex = neighbors(g,current_edge)
				a = rand(1:length(NeighborsOfVertex))
				current_edge = NeighborsOfVertex[a]
				if !(current_edge in NeighborsOfStart) && current_edge !=1
					break
				end
			end
		else
			while true
				NeighborsOfVertex = neighbors(g,current_edge)
				a = rand(1:length(NeighborsOfVertex))
				current_edge = NeighborsOfVertex[a]
				if !(current_edge in NeighborsOfStart)  && current_edge !=1
					break
				end
			end
		end
	end
return current_edge
end

function runrandomwalk(g::SimpleGraph,start_edge::Int64, numberOfSteps::Int64,howManyTimes::Int64,prob::Float64)
	x = Vector{Float64}()
	append!(x, rand(10))
	for i in 1:howManyTimes
		proposition = random_walk(g, start_edge , numberOfSteps , prob::Float64)
		append!(x, proposition)
		#println(proposition)
		#enumerate_paths(dijkstra_shortest_paths(g, 1), proposition)
		#println()
	end
	return x
end

function absorbingrandomwalk(g::SimpleGraph,scientist::Int64,reviewers::Array{Int64,1})
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

function findreviewers(g::SimpleGraph,scientists::Array{Int64,1},reviewers::Array{Int64,1},howManyTimes::Int64)
	x = Vector{Float64}()
	append!(x, rand(10))
	for i in 1: howManyTimes
		proposition = absorbingrandomwalk(g, scientists[1], reviewers)
		append!(x, proposition)
	end
	d = countmap(x)
	println(OrderedDict(sort(collect(d), by=x->x[2], rev=true)))
end

end
