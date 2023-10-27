-module(main).
-import(io, [fwrite/1] ).
-export( [start/0, remove/2, find_smallest/1, selection_sort/1, run_sort_ss/0, parallel_selection_sort_2/1, parallel_selection_sort_4/1, parallel_selection_sort_8/1, split/1, merge/2, merge_sort/1, run_sort/0, merge_sort_parallel_2/1, merge_sort_parallel_4/1, merge_sort_parallel_8/1, createTestList/1, testSort/1, sortList/1] ).

start() ->
   fwrite("Hello, world!\n").


% ---------------------------------------------------
% Global helper functions:
% Split list into two halves
split( List ) ->
    split_help( length(List) div 2, List, [] ).
split_help( 0, Original, FirstHalf ) ->
    { FirstHalf, Original };
split_help( N, [H|T], FirstHalf ) ->
    split_help( N - 1, T, [H | FirstHalf] ).


% Merge two sorted lists:
merge( [], List2 ) -> List2;
merge( List1, [] ) -> List1;
merge( [H1 | T1], [H2 | T2] ) when H1 < H2 ->
    [H1 | merge( T1, [H2 | T2])];
merge( [H1 | T1], [H2 | T2] ) ->
    [H2 | merge( [H1 | T1], T2 )].


% ---------------------------------------------------
% Slow Algorithim Implementatoin using Selection Sort:
% Return the list without an item:
remove([], _) -> [];
remove([H | T], H) -> T;
remove([H | T], Item) -> [H | remove(T, Item)].

% Return the smallest item in the list:
find_smallest([]) -> io:format( "Error!" );
find_smallest([X]) -> X;
find_smallest([H | T]) -> SmallestT = find_smallest(T),
    if
         H < SmallestT -> H;
         true -> SmallestT
     end. 

% Sequential selection sort:
selection_sort([]) -> io:format( "Error!" );
selection_sort([X]) -> [X];
selection_sort(List) ->
	Smallest = find_smallest(List),
	OldList = remove(List, Smallest),
	[Smallest | selection_sort(OldList)].

% Run sequential sort for a process, to be used in parallel processing:
run_sort_ss( ) ->
    receive
        { Pid, List } -> Sorted = selection_sort( List ), Pid ! Sorted;
        _ -> io:format( "Error!" )
    end.

% 2 Parallel processes selection sort:
parallel_selection_sort_2( [] ) -> [];
parallel_selection_sort_2( [X] ) -> [X];
parallel_selection_sort_2( List ) ->
    { L1, L2 } = split( List ),
    Pid1 = spawn( main, run_sort_ss, [] ),
    Pid2 = spawn( main, run_sort_ss, [] ),
    Pid1 ! { self(), L1 },
    Pid2 ! { self(), L2 },
    receive X -> Sorted1 = X end,
    receive Y -> Sorted2 = Y end,
    merge( Sorted1, Sorted2 ).

% 4 Parallel processes selection sort:
parallel_selection_sort_4([]) -> [];
parallel_selection_sort_4([X]) -> [X];
parallel_selection_sort_4(List) ->
    {L1, L2} = split(List),
    {L3, L4} = split(L1),
    {L5, L6} = split(L2),
    Pid1 = spawn(main, run_sort_ss, []),
    Pid2 = spawn(main, run_sort_ss, [] ),
    Pid3 = spawn(main, run_sort_ss, [] ),
    Pid4 = spawn(main, run_sort_ss, [] ),
    Pid1 ! { self(), L3 },
    Pid2 ! { self(), L4 },
    Pid3 ! { self(), L5 },
    Pid4 ! { self(), L6 },
    receive W -> Sorted1 = W end,
    receive X -> Sorted2 = X end,
    receive Y -> Sorted3 = Y end,
    receive Z -> Sorted4 = Z end,
    MergedList1 = merge( Sorted1, Sorted2 ),
    MergedList2 = merge( Sorted3, Sorted4 ),
    Pid1 ! stop,
    Pid2 ! stop,
    Pid3 ! stop,
    Pid4 ! stop,
    merge(MergedList1, MergedList2).

% 8 Parallel processes selection sort:
parallel_selection_sort_8([]) -> [];
parallel_selection_sort_8([X]) -> [X];
parallel_selection_sort_8(List) ->
    {L1, L2} = split(List),
    {L3, L4} = split(L1),
    {L5, L6} = split(L2),
    {L7, L8} = split(L3),
    {L9, L10} = split(L4),
    {L11, L12} = split(L5),
    {L13, L14} = split(L6),
    Pid1 = spawn(main, run_sort_ss, [] ),
    Pid2 = spawn(main, run_sort_ss, [] ),
    Pid3 = spawn(main, run_sort_ss, [] ),
    Pid4 = spawn(main, run_sort_ss, [] ),
    Pid5 = spawn(main, run_sort_ss, [] ),
    Pid6 = spawn(main, run_sort_ss, [] ),
    Pid7 = spawn(main, run_sort_ss, [] ),
    Pid8 = spawn(main, run_sort_ss, [] ),
    Pid1 ! { self(), L7 },
    Pid2 ! { self(), L8 },
    Pid3 ! { self(), L9 },
    Pid4 ! { self(), L10 },
    Pid5 ! { self(), L11 },
    Pid6 ! { self(), L12 },
    Pid7 ! { self(), L13 },
    Pid8 ! { self(), L14 },
    receive A -> Sorted1 = A end,
    receive B -> Sorted2 = B end,
    receive C -> Sorted3 = C end,
    receive D -> Sorted4 = D end,
    receive W -> Sorted5 = W end,
    receive X -> Sorted6 = X end,
    receive Y -> Sorted7 = Y end,
    receive Z -> Sorted8 = Z end,
    MergedList1 = merge( Sorted1, Sorted2 ),
    MergedList2 = merge( Sorted3, Sorted4 ),  
    MergedList3 = merge( Sorted5, Sorted6 ),  
    MergedList4 = merge( Sorted7, Sorted8 ),  
    FinalList1 = merge(MergedList1, MergedList2),
    FinalList2 = merge(MergedList3, MergedList4),
    merge(FinalList1, FinalList2).



% -----------------------------------------------
% Fast Algorithim Implementatoin using Merge Sort:
% Sequential merge sort:
merge_sort([]) -> [];
merge_sort([X]) -> [X];
merge_sort(List) ->
    {L1, L2} = split(List),
    merge(merge_sort(L1), merge_sort(L2)).

% Run sequential sort for a process, to be used in parallel processing:
run_sort( ) ->
    receive
        { Pid, List } -> Sorted = merge_sort( List ), Pid ! Sorted;
        _ -> io:format("Error!")
    end.

% 2 Parallel processes merge sort:
merge_sort_parallel_2([]) -> [];
merge_sort_parallel_2([X]) -> [X];
merge_sort_parallel_2(List) ->
    {L1, L2} = split(List),
    Pid1 = spawn(main, run_sort, []),
    Pid2 = spawn(main, run_sort, []),
    Pid1 ! { self(), L1 },
    Pid2 ! { self(), L2 },
    receive X -> Sorted1 = X end,
    receive Y -> Sorted2 = Y end,
    merge( Sorted1, Sorted2 ).

% 4 Parallel processes merge sort:
merge_sort_parallel_4([]) -> [];
merge_sort_parallel_4([X]) -> [X];
merge_sort_parallel_4(List) ->
    {L1, L2} = split(List),
    {L3, L4} = split(L1),
    {L5, L6} = split(L2),
    Pid1 = spawn(main, run_sort, [] ),
    Pid2 = spawn(main, run_sort, [] ),
    Pid3 = spawn(main, run_sort, [] ),
    Pid4 = spawn(main, run_sort, [] ),
    Pid1 ! { self(), L3 },
    Pid2 ! { self(), L4 },
    Pid3 ! { self(), L5 },
    Pid4 ! { self(), L6 },
    receive W -> Sorted1 = W end,
    receive X -> Sorted2 = X end,
    receive Y -> Sorted3 = Y end,
    receive Z -> Sorted4 = Z end,
    MergedList1 = merge( Sorted1, Sorted2 ),
    MergedList2 = merge( Sorted3, Sorted4 ),  
    merge(MergedList1, MergedList2).


% 8 Parallel processes merge sort:
merge_sort_parallel_8([]) -> [];
merge_sort_parallel_8([X]) -> [X];
merge_sort_parallel_8(List) ->
    {L1, L2} = split(List),
    {L3, L4} = split(L1),
    {L5, L6} = split(L2),
    {L7, L8} = split(L3),
    {L9, L10} = split(L4),
    {L11, L12} = split(L5),
    {L13, L14} = split(L6),
    Pid1 = spawn(main, run_sort, [] ),
    Pid2 = spawn(main, run_sort, [] ),
    Pid3 = spawn(main, run_sort, [] ),
    Pid4 = spawn(main, run_sort, [] ),
    Pid5 = spawn(main, run_sort, [] ),
    Pid6 = spawn(main, run_sort, [] ),
    Pid7 = spawn(main, run_sort, [] ),
    Pid8 = spawn(main, run_sort, [] ),
    Pid1 ! { self(), L7 },
    Pid2 ! { self(), L8 },
    Pid3 ! { self(), L9 },
    Pid4 ! { self(), L10 },
    Pid5 ! { self(), L11 },
    Pid6 ! { self(), L12 },
    Pid7 ! { self(), L13 },
    Pid8 ! { self(), L14 },
    receive A -> Sorted1 = A end,
    receive B -> Sorted2 = B end,
    receive C -> Sorted3 = C end,
    receive D -> Sorted4 = D end,
    receive W -> Sorted5 = W end,
    receive X -> Sorted6 = X end,
    receive Y -> Sorted7 = Y end,
    receive Z -> Sorted8 = Z end,
    MergedList1 = merge( Sorted1, Sorted2 ),
    MergedList2 = merge( Sorted3, Sorted4 ),  
    MergedList3 = merge( Sorted5, Sorted6 ),  
    MergedList4 = merge( Sorted7, Sorted8 ),  
    FinalList1 = merge(MergedList1, MergedList2),
    FinalList2 = merge(MergedList3, MergedList4),
    merge(FinalList1, FinalList2).


% ----------------------------------
% Test with a different length lists:
createTestList(0) -> [];
createTestList(Length) -> [rand:uniform(100) | createTestList(Length - 1)].

sortList(List) ->  
  lists:sort(List).

testSort(Length) ->
  List = createTestList(Length),
  {Time, _} = timer:tc( main, sortList, [List] ),
io:format("Time taken by the function is: ~p seconds, on a random list of length: ~p~n", [Time / 1000000, Length]).
