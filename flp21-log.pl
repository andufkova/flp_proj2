% FLP: Spanning tree
% Aneta Dufkova (xdufko02)
% 2022

%%%%%%%%%%%%%%%%%%%%%%%% input2.pl %%%%%%%%%%%%%%%%%%%%%%%%

read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),% atom_codes(C,[Cd]),
		[C|LL] = L).

isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).


read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
	  read_lines(LLs), Ls = [L|LLs]
	).

split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]).

split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).

%%%%%%%%%%%%%%%% ignore incorrect lines %%%%%%%%%%%%%%%%

% does the line contain two chars representing two connected vertices?
% if not return empty list, otherwise return list of those connected vertices
% if there is a self loop (from vertice A to vertice A), return emtpty list as well
good_line([[Ch], [Ch2] | _], []) :- Ch == Ch2.
good_line([[Ch], [Ch2] | Rest], [Ch, Ch2]) :- char_type(Ch, alpha), char_type(Ch2, alpha), Rest == [].
good_line(_, []).

% take every line and check if it follows the expected structure
check_lines([], []).
check_lines([X|Xs], [R|M]) :- good_line(X, R), check_lines(Xs, M), !.

% definition of an empty list
% needed to filter the empty lists
empty([]).

% sorts lists inside of a list
% needed to eliminate inputs with the same edge like A B and B A
sort_inside([], []).
sort_inside([L|Ls], [K|S]) :-
    sort(L,K), sort_inside(Ls, S).

%%%%%%%%%%%%%%% is the graph connected? %%%%%%%%%%%%%%%

% get all the vertices
% flatten the input array of edges and take just unique elements
get_vertices(L, Vertices) :- flatten(L, Tmp), sort(Tmp, Vertices).

% there is an edge from X to Y if there exists an element [X, Y] or [Y, X]
edge(X,Y,L) :- ((member([X, Y], L) ; member([Y, X], L))).

% check if there exists a path from X to Y
% the path can lead throught other vertices
is_path(X, Y, L, _) :- edge(X,Y,L). 
is_path(X, Y, L, [V|Vs]) :- is_path(X, V, L, Vs), is_path(V, Y, L, Vs).

% get all the possible combinations of vertices
get_pairs(L, Pairs) :- findall([X,Y], (append(_,[X|R],L), member(Y,R)), Pairs).

% take a list and join its elements to pairs
% example: [1,2,3,4] -> [[1,2], [3,4]]
pair([],[]) :- !.
pair([A,B|T],[[A,B]|T1]):-
    pair(T,T1).

% is the graph connected?
% is there a path from every vertice to every vertice?
is_connected([], _, _).
is_connected([[X,Y]|Ls], L, Vs) :- is_path(X, Y, L, Vs), is_connected(Ls, L, Vs), !.

%%%%%%%%%%%%%%% get spanning trees %%%%%%%%%%%%%%%

% https://stackoverflow.com/questions/53668887/a-combination-of-a-list-given-a-length-followed-by-a-permutation-in-prolog
% take combinations of edges length N
comb(0,_,[]).
comb(N,[X|T],[X|Comb]) :-
    N>0,
    N1 is N-1,
    comb(N1,T,Comb).
comb(N,[_|T],Comb) :-
    N>0,
    comb(N,T,Comb).

% from possible spanning trees take just actual spanning trees
% exclude graphs with cycles and graphs which dont contain all the initial vertices
exclude_cycles_and_not_all_vertices(_, [], []).
exclude_cycles_and_not_all_vertices(Vertices, [Pst|Psts], SpanningTrees) :-
	((check_all_cycles(Vertices, Pst), check_all_vertices(Vertices, Pst))
		-> SpanningTrees = [Pst|Q]; SpanningTrees = Q), 
		exclude_cycles_and_not_all_vertices(Vertices, Psts, Q).

% find possible spanning trees and filter them
get_spanning_trees(Vertices, Edges, SpanningTrees) :-
	length(Vertices, L),
	findall(A, comb(L-1, Edges, A), PossibleSpanningTrees),
	exclude_cycles_and_not_all_vertices(Vertices, PossibleSpanningTrees, SpanningTrees).

% are the lists equal?
equal_lists(L1, L2) :-
    sort(L1, L1_Sorted), sort(L2, L2_Sorted), L1_Sorted == L2_Sorted.

% check if a graph contains all the initial vertices
check_all_vertices(Vertices, Pst) :-
	flatten(Pst, Edges),
	get_vertices(Edges, Vertices2),
	equal_lists(Vertices, Vertices2).

% call cyc(...) for all the vertices
check_all_cycles([], _).
check_all_cycles([V|Vs], Tree) :-
	\+ cyc(V, Tree, []), check_all_cycles(Vs, Tree).

% does cycle exist in the graph from vertice X to X?
cyc(X, L, Visited) :-
    edge(X, Y, L), 
    cyc(X, Y, L, [[X, Y], [Y, X]|Visited]).

cyc(X, Z, L, Visited) :- 
    edge(Z, X, L), 
    \+member([X, Z], Visited), \+member([Z, X], Visited), !.

cyc(X, Y, L, Visited) :- 
    edge(Y, Z, L),
    \+member([Y, Z], Visited), \+member([Z, Y], Visited), 
    cyc(X, Z, L, [[Z, Y], [Y, Z]|Visited]).

cyc(_, _, _, _) :- false, !.

%%%%%%%%%%%%%%%%%%%%% write output %%%%%%%%%%%%%%%%%%%%%

write_spanning_tree([[H1,H2|_]|SpanningTree]) :-
	write(H1), write('-'), write(H2), write_spanning_tree2(SpanningTree).

write_spanning_tree2([]) :- write('\n').
write_spanning_tree2([[H1,H2|_]|SpanningTree]) :-
	write(' '), write(H1), write('-'), write(H2), write_spanning_tree2(SpanningTree).

write_spanning_trees([]).
write_spanning_trees([ST|SpanningTrees]) :-
	write_spanning_tree(ST), write_spanning_trees(SpanningTrees).


%%%%%%%%%%%%%%%%%%%%%%%% main %%%%%%%%%%%%%%%%%%%%%%%%

start :-
	prompt(_, ''),
	read_lines(LL),
	split_lines(LL,S),
	check_lines(S,S2),
	exclude(empty, S2, Edges_p),
	sort_inside(Edges_p, Edges_s),
	sort(Edges_s, Edges),
	flatten(Edges, M),
	pair(M, N),
	get_vertices(Edges, Vertices),
	get_pairs(Vertices, P),
	(is_connected(P, N, Vertices) 
		-> %writeln('graph is connected'),
		get_spanning_trees(Vertices, Edges, SpanningTrees),
		% just to be sure, it shouldnt be needed to make them unique
		sort(SpanningTrees, SpanningTreesSorted), 
		write_spanning_trees(SpanningTreesSorted)
		%writeln(SpanningTrees)
		; write('')),
		%writeln('graph is not connected')),
	halt.



