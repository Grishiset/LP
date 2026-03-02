% ----------------------------------------------------------------------
% family.pl  +  tests.pl
% Объединённый документ: два файла представлены в одном документе
% ---------------------------------------------------------------
% File: family.pl
% ----------------------------------------------------------------------
% -*- encoding: utf-8 -*-
% Genealogy knowledge base (Game of Thrones sample)
% Поддержка русских имён предикатов (мать, отец, брат и т.д.) и
% дополнительные отношения (двоюродный_брат, двоюродная_сестра,
% троюродная_сестра). Файл готов для загрузки в SWI-Prolog.

% ------ FACTS (PERSONS) ------
 
% --- Male characters ---
male(rickard_stark).
male(brandon_stark).
male(eddard_stark).
male(benjen_stark).
male(hoster_tully).
male(edmure_tully).
male(robb_stark).
male(bran_stark).
male(rickon_stark).
male(jon_snow).
male(rhaegar_targaryen).
male(aerys_targaryen).
male(aegon_targaryen).
male(viserys_targaryen).

% --- Female characters ---
female(lyarra_stark).
female(lyanna_stark).
female(catelyn_tully).
female(minisa_tully).
female(sansa_stark).
female(arya_stark).
female(rhaella_targaryen).
female(eliah_martell).
female(daenerys_targaryen).
female(rhaenys_targaryen).

% --- Parent relations (parent/2) ---
% Generation 1 -> Generation 2
parent(rickard_stark, brandon_stark).
parent(rickard_stark, eddard_stark).
parent(rickard_stark, benjen_stark).
parent(rickard_stark, lyanna_stark).
parent(lyarra_stark, brandon_stark).
parent(lyarra_stark, eddard_stark).
parent(lyarra_stark, benjen_stark).
parent(lyarra_stark, lyanna_stark).

parent(hoster_tully, catelyn_tully).
parent(hoster_tully, edmure_tully).
parent(minisa_tully, catelyn_tully).
parent(minisa_tully, edmure_tully).

parent(aerys_targaryen, rhaegar_targaryen).
parent(aerys_targaryen, viserys_targaryen).
parent(aerys_targaryen, daenerys_targaryen).
parent(rhaella_targaryen, rhaegar_targaryen).
parent(rhaella_targaryen, viserys_targaryen).
parent(rhaella_targaryen, daenerys_targaryen).

% Generation 2 -> Generation 3
parent(eddard_stark, robb_stark).
parent(eddard_stark, sansa_stark).
parent(eddard_stark, arya_stark).
parent(eddard_stark, bran_stark).
parent(eddard_stark, rickon_stark).
parent(catelyn_tully, robb_stark).
parent(catelyn_tully, sansa_stark).
parent(catelyn_tully, arya_stark).
parent(catelyn_tully, bran_stark).
parent(catelyn_tully, rickon_stark).

parent(lyanna_stark, jon_snow).
parent(rhaegar_targaryen, jon_snow).

parent(rhaegar_targaryen, rhaenys_targaryen).
parent(rhaegar_targaryen, aegon_targaryen).
parent(eliah_martell, rhaenys_targaryen).
parent(eliah_martell, aegon_targaryen).

% ----------------------------------------------------------------------
% DERIVED PREDICATES (BASIC RELATIONS)
% ----------------------------------------------------------------------

mother(X, Y) :- parent(X, Y), female(X).
father(X, Y) :- parent(X, Y), male(X).

grandmother(X, Y) :- parent(X, Z), parent(Z, Y), female(X).
grandfather(X, Y) :- parent(X, Z), parent(Z, Y), male(X).

brother(X, Y) :-
    male(X),
    parent(P, X),
    parent(P, Y),
    X \= Y.
sister(X, Y) :-
    female(X),
    parent(P, X),
    parent(P, Y),
    X \= Y.

uncle(X, Y) :-
    male(X),
    parent(P, Y),
    brother(X, P).
aunt(X, Y) :-
    female(X),
    parent(P, Y),
    sister(X, P).

% ----------------------------------------------------------------------
% COMPLEX RELATIONS (COUSINS)
% ----------------------------------------------------------------------

% siblings (shared parent)
siblings(X, Y) :-
    parent(Z, X),
    parent(Z, Y),
    X \= Y.

% first cousins: parents are siblings
first_cousins(X, Y) :-
    parent(Px, X),
    parent(Py, Y),
    siblings(Px, Py),
    X \= Y.

% second cousins: parents are first cousins
second_cousins(X, Y) :-
    parent(Px, X),
    parent(Py, Y),
    first_cousins(Px, Py),
    X \= Y.

% generic: degree-k cousins could be implemented recursively; for level-1 and level-2
% we provide concrete predicates above.

% двоюродный брат/сестра (первое поколение кузенов)
dвоюродный_брат(X, Y) :-
    male(X),
    first_cousins(X, Y).

двоюродная_сестра(X, Y) :-
    female(X),
    first_cousins(X, Y).

% троюродная_сестра: упрощённое определение — родители относятся как вторые кузены
% (т.е. их родители — братья/сестры на уровне выше)
% Мы используем second_cousins для определения троюродности в упрощённой форме.
троюродная_сестра(X, Y) :-
    female(X),
    second_cousins(X, Y).

% ----------------------------------------------------------------------
% RECURSIVE PREDICATES (ANCESTOR / DESCENDANT)
% ----------------------------------------------------------------------

ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

descendant(X, Y) :- ancestor(Y, X).

% Русские алиасы для предков/потомков
предок(X, Y) :- ancestor(X, Y).
потомок(X, Y) :- descendant(X, Y).

% ----------------------------------------------------------------------
% ADDITIONAL USEFUL PREDICATES
% ----------------------------------------------------------------------

% Roots (oldest known)
root(rickard_stark).
root(lyarra_stark).
root(hoster_tully).
root(minisa_tully).
root(aerys_targaryen).
root(rhaella_targaryen).

% Generation number (0 for roots)
generation(X, 0) :- root(X).
generation(X, N) :-
    parent(Y, X),
    generation(Y, N1),
    N is N1 + 1.

% Undirected link for kinship degree calculation: parent-child or siblings
link(X, Y) :- parent(X, Y).
link(X, Y) :- parent(Y, X).
link(X, Y) :- siblings(X, Y).

% Kinship degree (shortest path length) — naive BFS-like recursion (may enumerate many paths)
kinship_degree(X, Y, 0) :- X = Y.
kinship_degree(X, Y, 1) :- link(X, Y).
kinship_degree(X, Y, N) :-
    link(X, Z),
    kinship_degree(Z, Y, N1),
    N is N1 + 1,
    X \= Y.

% ----------------------------------------------------------------------
% Helpful: make Russian aliases for basic predicates
% ----------------------------------------------------------------------
мать(X, Y) :- mother(X, Y).
отец(X, Y) :- father(X, Y).
бабушка(X, Y) :- grandmother(X, Y).
дедушка(X, Y) :- grandfather(X, Y).
брат(X, Y) :- brother(X, Y).
сестра(X, Y) :- sister(X, Y).
тётя(X, Y) :- aunt(X, Y).
дядя(X, Y) :- uncle(X, Y).

% Aliases for cousin predicates (русские имена)
двоюродный_брат(X, Y) :- двоюродный_брат(X, Y).
двоюродная_сестра(X, Y) :- двоюродная_сестра(X, Y).
троюродная_сестра(X, Y) :- троюродная_сестра(X, Y).

% ----------------------------------------------------------------------
% End of family.pl
% ----------------------------------------------------------------------
