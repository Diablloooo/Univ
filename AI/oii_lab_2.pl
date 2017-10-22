:- dynamic object/4.
:- dynamic subject/1.
:- dynamic type/1.
:- dynamic marked/1.

subject(s1).
subject(s2).
subject(s3).
subject(s4).
%object(o1).
%object(o2).
%object(o3).
%object(o4).
link(r1).
link(r2).
link(r3).
link(r4).
link(r5).
link(r6).

type(regedit).
type(subkey).

object(r1,regedit,[[s2,r,w],[s1,r]],o1).
object(r2,regedit,[[s3,r]],o1).
object(r3,regedit,[[s1,r,w]],r1).

object(r4,regedit,[[s4,r]],r5).
object(r5,regedit,[[s3,w][s1,w],r4).



menu:-
    write('1) Subject rights for all objects'),nl,
    write('2) Subject rights for object'),nl,
    write('3) Rights of list of Subjects for current object'),nl,
    read(Number),menuFunction(Number).

menuFunction(Number):-
    Number = 1, nl, showAllSubjectRights, nl, menu;
    Number = 2, nl, showRightsForCurrentObject, nl, menu;
    Number = 3, nl, showSubjectsRightsToObject, nl, menu;
    Number = 4, nl, test, nl ,menu.


test(X,Y,Z):-
	write(X),write(Y),write(Z).
/*test:-
    write('Type Subject name: '),
    read(Subject),                       %WORKS FOR 2nd.
    %subject(Subject),
    nonvar(Subject),
    write('Type Object name: '),
    read(Object),
    nonvar(Object),
    testShow(Object,Subject).

testShow(Object,[]):-true.
testShow(Object,[H|T]):-
    object(Object,_,List,File),
    not(link(File)),
    forall(member(Subject,[H|T]),
    checkNextList(Object,Subject,List)),
    fail;
    testShow(File,T).*/


showSubjectsRightsToObject:-
    write('Type Subject list: '),
    read(Subjects),
    nonvar(Subjects),
    write('Type Object name: '),
    read(Object),
    nonvar(Object),
    showListOfRights(Subjects,Object).

%showListOfRights([],Object):-!.
showListOfRights([H|T],Object):-
    showRights(Object,H),
    showListOfRights(T,Object);
    true.


showRightsForCurrentObject:-
    write('Type Subject name: '),
    read(Subject),
    subject(Subject),
    nonvar(Subject),
    write('Type Object name: '),
    read(Object),
    nonvar(Object),
    showRights(Object,Subject).

showRights(Object,Subject):-
    forall(object(Object,_,List,File),(
               link(File),
               not(marked(Object)),
               assert(marked(Object)),
               showRights(File,Subject);
               not(link(File)),
               checkNextList(Object,Subject,List))),
               retractall(marked(_));

               true.


/*showRightsStart(Subject,Permission):-
    forall(object(Object,_,List,File),
         (not(File = Permission),
          %not(marked(Object)),
          %assert(marked(Object)),
          showRights(Permission,File,Subject);
          File = Permission,
          checkNextList(Object,Subject,List))).
          %retractall(marked(_)).

showRights(Permission,Object,Subject):-
    forall(object(Object,_,List,File),
         (not(File = Permission),
          %not(marked(Object)),
          %assert(marked(Object)),
          showRights(Permission,File,Subject);
          File = Permission,
          %not(marked(Object)),
          %retractall(marked(_)),
          write(Object),write(' - '),nl,write(' - rights for'),write(Permission);
          checkNextList(Object,Subject,List);
          true)).*/


showAllSubjectRights:-
   write('Type Subject name: '),
   read(Subject),
   nonvar(Subject),
   subject(Subject),
   forall(object(Object,T,[Head|Tail],File),
         (member(Subject,Head),
          write(Object),write(' - '),write(Head),write(File),nl;
          checkNextList(Object,Subject,Tail);
          true)).

checkNextList(Object,Subject,[]):-!.

checkNextList(Object,Subject,[Head|Tail]):-
    member(Subject,Head),
    write(Object),write(' - '),write(Head),nl;
    %checkNextList(Object,Subject,Tail);
    checkNextList(Object,Subject,Tail).

