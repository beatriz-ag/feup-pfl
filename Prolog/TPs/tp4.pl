:-dynamic male/1, female/1, parent/2.

female(grace).
female(dede).
female(claire).
female(haley).
female(poppy).
female(alex).
female(poppy).
female(lily).

male(mitchell).
male(frank).
male(phil).
male(jay).
male(dylan).
male(george).
male(luke).
male(frank).

parent(grace, phil).
parent(frank, phil).

parent(dede, claire).
parent(jay, claire).

parent(dede, mitchell).
parent(jay, mitchell).

parent(mitchell, lily).

parent(phil, haley).
parent(claire, haley).

parent(phil, alex).
parent(claire, alex).

parent(phil, luke).
parent(claire, luke).

parent(dylan, poppy).
parent(haley, poppy).

parent(dylan, george).
parent(haley, george).

father(X,Y) :- parent(X, Y), male(X).
mother(X,Y) :- parent(X, Y), female(X).
grandfather(X,Y) :- parent(X,Z), parent(Z,Y), male(X).
grandmother(X,Y) :- parent(X,Z), parent(Z,Y), female(X).
siblings(X,Y) :- parent(Z,X), parent(W,X),W\==X, parent(Z,Y), parent(W,Y).
halfSiblings(X,Y) :- parent(P,X), parent(M,X), parent(W,Y), P\==M, P\==W, M\==P, M\==W.
uncle(X,Y) :- parent(Z,Y), siblings(X,Z).
cousins(X,Y) :- parent(Z,X), uncle(Z,Y).

marry(jay,dede,'1968').
marry(jay,gloria,'2008').
divorce(jay,dede,'2003').

married(X,Y) :- marry(X,Y,_), \+ divorce(X,Y,_).
divorced(X,Y) :- divorce(X,Y,_), \+ marry(X,Y,_).



%1a
create(1, Name) :- assert(male(Name)).
create(2, Name) :- assert(female(Name)).
create(_, Name) :- write('Invalid input.').

add_person :- write('1.male\n2.female\nR: '),
              read(Sex),nl,
              write('Name: '),
              read(Name),
              create(Sex, Name).


%1b
add_parents(Person) :- write('Insert 1st parent name: '),
                       read(Parent1), nl,
                       write('Insert 2nd parent name: '),
                       read(Parent2), nl,
                       assert(parent(Parent1,Person)),
                       assert(parent(Parent2, Person)).

%1c
remove_person :- write('Insert the persons name to remove: '),
                 read(Person),
                 retractall(female(Person)),
                 retractall(male(Person)),
                 retractall(parent(_, Person)),
                 retractall(parent(Person,_)).


flight(porto, lisbon, tap, tp1949, 1615, 60).
flight(lisbon, madrid, tap, tp1018, 1805, 75).
flight(lisbon, paris, tap, tp440, 1810, 150).
flight(lisbon, london, tap, tp1366, 1955, 165).
flight(london, lisbon, tap, tp1361, 1630, 160).
flight(porto, madrid, iberia, ib3095, 1640, 80).
flight(madrid, porto, iberia, ib3094, 1545, 80).
flight(madrid, lisbon, iberia, ib3106, 1945, 80).
flight(madrid, paris, iberia, ib3444, 1640, 125).
flight(madrid, london, iberia, ib3166, 1550, 145).
flight(london, madrid, iberia, ib3163, 1030, 140).
flight(porto, frankfurt, lufthansa, lh1177, 1230, 165).

%2a
get_all_nodes(ListOfAirports) :- findall(F, flight(F,D,C,CO,H,DU), Origin),
                                 findall(D, flight(F,D,C,CI,H,DU), Destination),
                                 append(Origin, Destination, Airports),
                                 sort(Airports, ListOfAirports).

get_all_nodes(ListOfAirports) :- setof(F, D,C,CO,H,DU^flight(F,D,C,CO,H,DU), ListOfAirports).
                                 

%2c
find_flights(Origin, Destination) :- find_flights(Origin, Destination, Flights).

find_flights(O, O, F).
find_flights(Origin, Destination, Flights ) :- flight(Origin, Destination, C, Code, H, D),
                                                     not( member(Code, Flights)),
                                                     flight(Origin, Next, C, CO, H, D),
                                                     find_flights(Next, Destination,Flights)).
                                              

%2d


%2h