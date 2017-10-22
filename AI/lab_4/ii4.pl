:- dynamic answers/1.

disk_in('n'):-
	not(answers('1')),
	assert(answers('1')).

disk_in('y'):-
	!.

disk_in(Y):-
	not(Y = 'y'),
	not(Y = 'n'),
	nl,
	write('Error! (y/n)'),
	read(X),
	disk_in(X).

disk_damaged('y'):-
	not(answers('2')),
	assert(answers('2')).

disk_damaged('n'):-
	!.

disk_damaged(Y):-
	not(Y = 'y'),
	not(Y = 'n'),
	nl,
	write('Error! (y/n)'),
	read(X),
	disk_damaged(X).

drive_damaged('n'):-
	!.

drive_damaged('y'):-
	not(answers('3')),
	assert(answers('3')).

drive_damaged(Y):-
	not(Y = 'y'),
	not(Y = 'n'),
	nl,
	write('Error! (y/n)'),
	read(X),
	drive_damaged(X).

driver_install('y'):-
	!.

driver_install('n'):-
	not(answers('4')),
	assert(answers('4')).

driver_install(Y):-
	not(Y = 'y'),
	not(Y = 'n'),
	nl,
	write('Error! (y/n)'),
	read(X),
	driver_install(X).

format_correct('y'):-
	!.

format_correct('n'):-
	not(answers('5')),
	assert(answers('5')).

format_correct(Y):-
	not(Y = 'y'),
	not(Y = 'n'),
	nl,
	write('Error! (y/n)'),
	read(X),
	format_correct(X).

%menu(X,Y):-
%	X = 1, disk_in(Y);
%	X = 2, disk_damaged(Y);
%	X = 3, drive_damaged(Y);
%	X = 4, driver_install(Y); 
%	X = 5, format_correct(Y).

result:-
	answers('1'), nl, write('Insert disk correctly'),fail;
	answers('2'), nl, write('Cange disk'),fail;
	answers('3'), nl, write('Chenge the drive'),fail;
	answers('4'), nl, write('Install driver'),fail;
	answers('5'), nl, write('Format disk correctly');
	nl, write('OK').

trace_start:-
	trace(disk_in).

