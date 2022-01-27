% 1.c 
fibonacci(0,0).
fibonacci(1,1).

fibonacci(N,F) :- N >= 0,
                  N1 is N-1,
                  N2 is N-2,
                  fibonacci(N1, Fib1),
                  fibonacci(N2, Fib2),
                  F is Fib1 + Fib2.
% 1.d
isPrime(X) :-  X1 is X-1,
               isPrime(X, X1).

isPrime(X,1).
isPrime(X,N) :- N > 1,
                   M is X mod N,
                   M \== 0,
                   N1 is N-1,
                   isPrime(X, N1).

% 3
cargo(tecnico, eleuterio).
cargo(tecnico, juvenaldo).
cargo(analista, leonilde).
cargo(analista, marciliano).
cargo(engenheiro, osvaldo).
cargo(engenheiro, porfirio).
cargo(engenheiro, reginaldo).
cargo(supervisor, sisnando).
cargo(supervisor_chefe, gertrudes).
cargo(secretaria_exec, felismina).
cargo(diretor, asdrubal).
chefiado_por(tecnico, engenheiro).
chefiado_por(engenheiro, supervisor).
chefiado_por(analista, supervisor).
chefiado_por(supervisor, supervisor_chefe).
chefiado_por(supervisor_chefe, diretor).
chefiado_por(secretaria_exec, diretor).

cargosuperior(C1,C2) :- chefiado_por(C2, C1);
                      chefiado_por(C3,C1), cargosuperior(C3,C2).

superior(X,Y) :- cargo(C1,X), cargo(C2,Y),
                 chefiado_por(C2,C1).
superior(X,Y) :- cargo(C1,X), cargo(C2,Y), chefiado_por(C3,C1), cargosuperior(C3,C2).
/* 4
a - yes
b - no
c - yes
d - H = pfl T = [lbaw, redes, ltw]
e - H = lbaw T = [ltw]
f - H = leic T = []
g - no
h - H = leic T = [[pfl,ltw,lbaw,redes]]    
i - H = leic T = [Two]
j - Inst = gram, LEIC = feup?
k - One = 1, Two = 2, Tail= [3,4] ?
l - One = leic, Rest = [Two | Tail] ?
*/

% 5.d
inner_product([ ],[ ],0).
inner_product([X | L1],[Y |L2],R) :- L3 is X * Y,
                                     inner_product(L1,L2, R1),
                                     R is L3 + R1.
% 5.e
% 6.b
% 6.c
% 6.d

