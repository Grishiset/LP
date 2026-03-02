% ----------------------------------------------------------------------
% File: tests.pl
% ----------------------------------------------------------------------
% This is a separate file: tests for the family.pl KB.
% Contains: commented example queries (20) and runnable unit tests (plunit)
:- [family].
% -- Example queries with expected results (comments) --
% 1. Parents of Jon Snow
% ?- parent(X, jon_snow).
%    X = lyanna_stark ; X = rhaegar_targaryen.

% 2. Children of Eddard Stark
% ?- parent(eddard_stark, X).
%    X = robb_stark ; X = sansa_stark ; X = arya_stark ; X = bran_stark ; X = rickon_stark.

% 3. Is Lyanna mother of Jon?
% ?- мать(lyanna_stark, jon_snow).  % true

% 4. Grandfathers of Jon Snow
% ?- дедушка(X, jon_snow).
%    X = rickard_stark ; X = aerys_targaryen.

% 5. Grandmothers of Jon Snow
% ?- бабушка(X, jon_snow).
%    X = lyarra_stark ; X = rhaella_targaryen.

% 6. Brothers of Arya Stark
% ?- брат(X, arya_stark).
%    X = robb_stark ; X = bran_stark ; X = rickon_stark.

% 7. Sisters of Arya Stark
% ?- сестра(X, arya_stark).
%    X = sansa_stark.

% 8. Uncles of Arya Stark
% ?- дядя(X, arya_stark).
%    X = brandon_stark ; X = benjen_stark ; X = edmure_tully.

% 9. Aunts of Arya Stark
% ?- тётя(X, arya_stark).
%    X = lyanna_stark.

% 10. First cousins (male) of Jon Snow
% ?- двоюродный_брат(X, jon_snow).
%     X = robb_stark ; X = bran_stark ; X = rickon_stark.

% 11. First cousins (female) of Jon Snow
% ?- двоюродная_сестра(X, jon_snow).
%     X = sansa_stark ; X = arya_stark.

% 12. Second cousins (should be none in this tree)
% ?- second_cousins(X, Y).  % false

% 13. Ancestors of Arya
% ?- предок(X, arya_stark).
%    X = eddard_stark ; X = catelyn_tully ; X = rickard_stark ; ...

% 14. Descendants of Rickard Stark
% ?- потомок(X, rickard_stark).
%    X = brandon_stark ; eddard_stark ; benjen_stark ; lyanna_stark ; ...

% 15. Kinship degree between Jon and Arya (example)
% ?- kinship_degree(jon_snow, arya_stark, N).
%    N = 3 ; ...

% 16. Check if Brandon is an uncle of Robb
% ?- дядя(brandon_stark, robb_stark).  % true

% 17. List all siblings of Catelyn
% ?- брат(X, catelyn_tully) ; сестра(X, catelyn_tully).
%    X = edmure_tully.

% 18. Find all ancestors of Daenerys
% ?- предок(X, daenerys_targaryen).
%    X = aerys_targaryen ; X = rhaella_targaryen.

% 19. Find all descendants of Aerys Targaryen
% ?- потомок(X, aerys_targaryen).
%    X = rhaegar_targaryen ; viserys_targaryen ; daenerys_targaryen ; ...

% 20. Check if Rhaegar is father of Jon
% ?- отец(rhaegar_targaryen, jon_snow).  % true

% -- Runnable unit tests using plunit --
:- begin_tests(family).

test(parent_of_jon) :-
    setof(P, parent(P, jon_snow), Parents),
    Parents == [lyanna_stark, rhaegar_targaryen].

test(mother_lyanna) :-
    мать(lyanna_stark, jon_snow).

test(grandfathers_of_jon) :-
    setof(G, дедушка(G, jon_snow), Gs),
    sort(Gs, Sorted),
    member(rickard_stark, Sorted),
    member(aerys_targaryen, Sorted).

test(brothers_of_arya) :-
    findall(B, брат(B, arya_stark), Bs),
    sort(Bs, Sorted),
    Sorted == [bran_stark, robb_stark, rickon_stark].

test(first_cousins_of_jon) :-
    setof(C, двоюродный_брат(C, jon_snow), Cs),
    sort(Cs, Sorted),
    Sorted == [bran_stark, robb_stark, rickon_stark].

test(ancestor_pred) :-
    предок(rickard_stark, arya_stark).

test(kinship_degree_example) :-
    kinship_degree(jon_snow, arya_stark, N),
    N > 0.

test(father_rhaegar) :-
    отец(rhaegar_targaryen, jon_snow).

:- end_tests(family).

% End of tests.pl
% ----------------------------------------------------------------------
