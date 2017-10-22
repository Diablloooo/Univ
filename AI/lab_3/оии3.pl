
/*start:-
		(loadlib;(format('Unable to load library.'),fail)),
		format('1. Добавить элемент.~n'),
		format('2. Отсортировать.~n'),
		format('3. Отсортировать (с шагами)~n'),
		format('4. Вывести содержимое.~n'),
		read(N), integer(N), menu(N).*/

menu:-
    (loadlib;(format('Unable to load library.'),fail)),
    write('1) Subject rights for all objects'),nl,
    write('2) Subject rights for object'),nl,
    write('3) Rights of list of Subjects for current object'),nl,
    read(Number),menuFunction(Number).

menuFunction(Number):-
    Number = 1, nl, ReadFile, nl, menu.
   % Number = 2, nl, showRightsForCurrentObject, nl, menu;
    %Number = 3, nl, showSubjectsRightsToObject, nl, menu;
   % Number = 4, nl, test, nl ,menu.

readFile:-
    write("Type the path of file"),nl,
    read(Path).

/*menu(N):-
		N=1, readFile.
		adduser(Name),nl,!,start;
		N=2, I is -1, sortjournal(I), nl,!,start;
		N=3,  format('Введите i.~n '),read(I),(integer(I);(format('Ошибка~n'),fail)), sortjournal(I), nl,!,start;
		N=4, viewjournal,nl,!,start;
		true,start.*/

loadlib:-
	load_foreign_library( 'PrologLib.dll' ).

exit:-
	unload_foreign_library( 'PrologLib.dll' ).
