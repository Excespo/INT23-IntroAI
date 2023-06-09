create_queue([]).

enqueue(Element, Queue, NewQueue) :-
    append(Queue, [Element], NewQueue).

dequeue(Element, [Element | RestQueue], RestQueue).

/*
?- create_queue(Q), enqueue(a, Q, Q1), enqueue(b, Q1, Q2), dequeue(X, Q2, Q3).
Q = [],
Q1 = [a],
Q2 = [a, b],
Q3 = [b],
X = a.
*/