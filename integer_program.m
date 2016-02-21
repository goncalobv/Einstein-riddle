% Solving Einstein's "find the fish" puzzle using linear programming

% @requires Yalmip linear program solver for Matlab

% @author   goncalobv
% @version  1.0
% @date     25 January 2016

clc;
clear all;
addpath(genpath('./yalmip'))


wall_color = {'red', 'blue', 'white', 'green', 'yellow'};
nationality = {'german', 'british', 'norwegian', 'danish', 'swedish'};
cigar = {'blends', 'dunhill', 'prince', 'pall mall', 'bluemaster'};
beverage = {'water', 'beer', 'coffee', 'tea', 'milk'};
animal = {'fish', 'horse', 'cat', 'dog', 'bird'};

% each variable will have a value from 1 to 5 corresponding to the house
% number. If w(1) is 3, that means the 3rd house has red walls.

% wall color
w = intvar(5,1);
% nationality
n = intvar(5,1);
% cigar
c = intvar(5,1);
% beverage
b = intvar(5,1);
% animal
a = intvar(5,1);

constraints = [];

% british has red walls
constraints = [constraints, n(2) == w(1)];

% swedish has a dog
constraints = [constraints, n(5) == a(4)];

% danish drinks tea
constraints = [constraints, n(4) == b(4)];

% coffee in the green house
constraints = [constraints, b(3) == w(4)];

% white house on the right of the green house
constraints = [constraints, w(3) == w(4) + 1];

% dunhill in yellow house
constraints = [constraints, c(2) == w(5)];

% pall mall and bird in same house
constraints = [constraints, c(4) == a(5)];

% german smokes prince
constraints = [constraints, c(3) == n(1)];

% bluemaster and beer in same house
constraints = [constraints, c(5) == b(2)];

% guy that smokes blends lives next to the guy with a cat
constraints = [constraints, a(3) + 1 >= c(1) >= a(3) - 1];
constraints = [constraints, a(3) ~= c(1)];

% guy that has horse lives next to guy that smokes dunhill
constraints = [constraints, c(2) + 1 >= a(2) >= c(2) - 1];
constraints = [constraints, c(2) ~= a(2)];

% guy that smokes blends lives next to guy that drinks water
constraints = [constraints, b(1) + 1 >= c(1) >= b(1) - 1];
constraints = [constraints, b(1) ~= c(1)];

% norwegian lives next to blue house
constraints = [constraints, n(3) + 1 >= w(2) >= n(3) - 1];
constraints = [constraints, n(3) ~= w(2)];

% milk in the middle house
constraints = [constraints, b(5) == 3];

% norwegian lives in first house
constraints = [constraints, n(3) == 1];

% all decision variables must be positive and integers {1,2,3,4,5}
all_vars = [w, n, c, b, a];
constraints = [constraints, 5 >= all_vars >= 1];

% define that all variables must be different in each category
constraints = [constraints, alldifferent(w), alldifferent(n), alldifferent(c), alldifferent(b), alldifferent(a)];

% define objective (in this case we want the only solution)
% so optimization problem is not considered
objective = 0;

% run solver using branch and bound (slower)
% ops = sdpsettings('solver','bnb','verbose',1, 'bnb.maxiter', 1000); % solves in 696 iterations
% diagnosis = optimize(constraints, objective, ops)

% run solver with default parameters
diagnosis = optimize(constraints)

% convert results to integers
w = int8(value(w));
n = int8(value(n));
c = int8(value(c));
b = int8(value(b));
a = int8(value(a));

% print results
for i=1:5
    string = ['In house ', num2str(i), ',',...
    ' the one which has ', wall_color(find(w == i)), ' walls,',...
    ' lives the ', nationality(find(n == i)),...
    ', who smokes ', cigar(find(c == i)),...
    ', drinks ', beverage(find(b == i)),...
    ' and has a ', animal(find(a == i)), '.'];
    disp(strjoin(string, ''));
end
