:-dynamic object/1.
:-dynamic subject/1.
:-dynamic right/1.
:-dynamic access/3.
:-dynamic accessRights/3.

object(o2).
object(o4).
object(o6).
object(o8).
object(s1).
object(s3).
object(s5).
object(s7).
object(s9).

subject(s1).
subject(s3).
subject(s5).
subject(s7).
subject(s9).
right(r).
right(w).

access(s1, o8, w).
access(s1, o2, r).
access(s1, o6, r).
access(s3, o2, w).
access(s5, o4, w).
access(s7, o6, r).
access(s7, o8, w).
access(s9, o6, w).
access(s9, o8, r).


menu:-
    write('1) Subjects list'),nl,
    write('2) Objects list'),nl,
    write('3) Rigths list'),nl,
    write('4) Current subject rights'),nl,
    write('5) Subjects that are able to read/write current object'),nl,
    write('6) Create new subject'),nl,
    write('7) Create new object'),nl,
    write('8) Delete subject'),nl,
    write('9) Delete object'),nl,
    write('10) Add right'),nl,
    write('11) Delete right'),nl,
    write('12) Check right'),nl,
    write('13) Check trojan'),nl,
    read(Number),
    menuFunction(Number).



menuFunction(Number):-
    Number = 1, nl, subjectsList, nl, menu;
    Number = 2, nl, objectsList, nl, menu;
    Number = 3, nl, accessRights, nl, menu;
    Number = 4, nl, subjectRights, nl, menu;
    Number = 5, nl, objectDependencies, nl, menu;
    Number = 6, nl, createSubject, nl, menu;
    Number = 7, nl, createObject, nl, menu;
    Number = 8, nl, deleteSubject, nl, menu;
    Number = 9, nl, deleteObject, nl, menu;
    Number = 10, nl, giveRight, nl, menu;
    Number = 11, nl, eraseRight, nl, menu;
    Number = 12, nl, checkRight, nl, menu;
    Number = 13, nl, checkTrojan, nl, menu.

%checkTrojan:-
 %   access(Subject,Object,Right);

checkRight:-
    write('Subject name:'),
    read(Subject),
    nonvar(Subject),
    write('Object name:'),
    read(Object),
    nonvar(Object),
    write('Right:'),
    read(Right),
    right(Right),
    checkRight_pred(Subject,Object,Right).

checkRight_pred(Subject,Object,Right):-
    access(Subject,Object,Right),
    write('Access allowed!'),nl;
    write('Access denied!'),nl.


giveRight:-
    write('Type subject name:'),
    read(Subject),
    write('Type object name:'),
    read(Object),
    write('Type right:'),
    read(Right),
    subject(Subject),
    object(Object),
    right(Right),
    assert(access(Subject,Object,Right)),
    write(Subject),write(' got new rights');
    write('WRONG PARAMS'),nl,
    menu.

eraseRight:-
    write('Type subject name:'),
    read(Subject),
    write('Type object name:'),
    read(Object),
    write('Type right:'),
    read(Right),
    subject(Subject),
    object(Object),
    right(Right),
    retract(access(Subject,Object,Right)),
    write(Subject),write(' lost a right');
    write('WRONG PARAMS'),nl,
    menu.



deleteSubject:-
    write('Type subject name:'),
    read(Subject),
    subject(Subject),
    nonvar(Subject),
    retract(subject(Subject)),
    retractall(access(Subject,_,_)),
    write(Subject),write(' deleted'),nl.

deleteObject:-
    write('Type object name:'),
    read(Object),
    object(Object),
    nonvar(Object),
    retract(object(Object)),
    retractall(access(_,Object,_)),
    write(Object),write(' deleted'),nl.


createSubject:-
    write('Type subject name:'),
    read(Subject),
    not(subject(Subject)),
    nonvar(Subject),
    assert(subject(Subject)),
    assert(object(Subject)),
    write(Subject),write(' created'),nl.

createObject:-
    write('Type object name:'),
    read(Object),
    not(subject(Object)),
    nonvar(Object),
    assert(object(Object)),
    write(Object),write(' created'),nl.


objectDependencies:-
    write('Type object name:'),
    read(Object),
    object(Object),
    forall(access(Subject,Object,Right),
    (write(Subject),write('-'),
    write(Object),write('-'),write(Right),nl)).


accessRights:-
    forall(subject(Subject),
    forall(access(Subject,Object,Right),
    (write(Subject),write('-'),
    write(Object),write('-'),write(Right),nl))).


subjectRights:-
    write('Type subject name:'),
    read(Subject),
    subject(Subject),
    forall(access(Subject,Object,Right),
    (write(Subject),write('-'),
    write(Object),write('-'),write(Right),nl)).


subjectsList:-
    forall(subject(Subject),(write(Subject),nl)).

objectsList:-
    forall(object(Object),(write(Object),nl)).

checkTrojan:-
	subject(Subject),
	object(SecObject),
	not(access(Subject,SecObject,r)),
        access(Subject,Object,r),
	subject(SecSubject),
	object(Object),
	access(SecSubject,Object,w),
	access(SecSubject,SecObject,r),
	write("Subject "),write(SecSubject),write(" can write to "),write(Object),write(" from "), write(SecObject),nl,
        write("Subject "), write(Subject), write(" then can read information from "), write(Object),nl.


