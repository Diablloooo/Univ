:-dynamic object/1.
:-dynamic subject/1.
:-dynamic right/1.
:-dynamic access/3.
:-dynamic accessRights/3.
:-dynamic subjectType/2.
:-dynamic objectType/2.
:-dynamic owner/2.
:-dynamic canCopy/1.

type(t1).
type(t2).
type(t3).

%subjectType(s1,t1).
%subjectType(s3,t1).
%subjectType(s5,t2).
%subjectType(s7,t3).
%subjectType(s9,t3).

%objectType(o2,t1).
%objectType(o4,t2).
%objectType(o6,t3).
%objectType(o8,t3).

validType(t1,t1).
validType(t1,t2).
validType(t1,t3).
validType(t2,t2).
validType(t2,t3).
validType(t3,t3).

%object(o2).
%object(o4).
%object(o6).
%object(o8).
%object(s1).
%object(s3).
%object(s5).
%object(s7).
%object(s9).

%subject(s1).
%subject(s3).
%subject(s5).
%subject(s7).
%subject(s9).
right(r).
right(w).

%access(s1, o8, w).
%access(s1, o2, r).
%access(s1, o6, r).
%access(s3, o2, w).
%access(s5, o6, w).
%access(s5, o4, w).
%access(s7, o6, r).
%access(s7, o8, w).
%access(s9, o6, w).
%access(s9, o8, r).

%owner(s1,o1).
%canCopy(o2).

check_object(Object):-
    object(Object),true;
    write("Wrong object name"),nl,false.

check_subject(Subject):-
    subject(Subject),true;
    write("Wrong subject name"),nl,false.

check_type(Type):-
    type(Type),true;
    write("Wrong type"),nl,false.

check_right(Right):-
    right(Right),true;
    write("Wrong type"),nl,false.


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
    write('13) Create child subject'),nl,
    write('14) Copy object'),nl,
    write('15) Enable copy for object'),nl,
    write('16) Disable copy for object'),nl,
    read(Number),
    integer(Number),
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
    Number = 13, nl, createChildSubj, nl, menu;
    Number = 14, nl, copyObject_m, nl, menu;
    Number = 15, nl, allowCopy_m, nl, menu;
    Number = 16, nl, disableCopy_m, nl, menu.

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
    check_subject(Subject),
    check_object(Object),
    check_right(Right),
    subjectType(Subject,SubjType),
    objectType(Object,ObjType),
    validType(SubjType,ObjType),
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
    addRight(Subject,Object,Right),nl,
    menu.
%2 - lab
addRight(Subject,Object,Right):-
    check_subject(Subject),
    check_object(Object),
    check_right(Right),
    subjectType(Subject,TypeSubj),
    objectType(Object,TypeObj),
    validType(TypeSubj,TypeObj),
    assert(access(Subject,Object,Right)),
    write(Subject),write(' got new rights');
    write("Wrong params"),nl,fail.

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
    check_subject(Subject),
    nonvar(Subject),
    retractall(subjectType(Subject,_)),
    retract(subject(Subject)),
    retract(object(Subject)),
    retractall(access(Subject,_,_)),
    write(Subject),write(' deleted'),nl.

deleteObject:-
    write('Type object name:'),
    read(Object),
    check_object(Object),
    nonvar(Object),
    retractall(objectType(Object,_)),
    retract(object(Object)),
    retractall(access(_,Object,_)),
    write(Object),write(' deleted'),nl.

deleteObject(Subject,Object):-
    %write('Type object name:'),
    %read(Object),
    check_subject(Subject),
    owner(Subject,Object),
    check_object(Object),
    %nonvar(Object),
    retractall(objectType(Object,_)),
    retract(object(Object)),
    retractall(access(_,Object,_)),
    retract(owner(Subject,Object)),
    write(Object),write(' deleted'),nl.



createSubject:-
    write('Enter subject name:'),
    read(Subject),
    write('Enter subject type:'),
    read(Type),
    check_type(Type),
    not(subject(Subject)),
    nonvar(Subject),
    assert(subject(Subject)),
    assert(object(Subject)),
    assert(subjectType(Subject,Type)),
    write(Subject),write(" with type "),write(Type),write(' created'),nl.

newSubject(Subject,Type):-
    check_type(Type),
    not(subject(Subject)),
    nonvar(Subject),
    assert(subject(Subject)),
    assert(object(Subject)),
    assert(subjectType(Subject,Type)),
    write(Subject),write(" with type "),write(Type),write(' created'),nl.

createObject:-
    write('Enter object name:'),
    read(Object),
    write('Enter object type:'),
    read(Type),
    check_type(Type),
    not(object(Object)),
    nonvar(Object),
    assert(object(Object)),
    assert(objectType(Object,Type)),
    write(Object),write(" with type "),write(Type),write(' created'),nl.

newObject(Object,Type):-
    check_type(Type),
    not(object(Object)),
    nonvar(Object),
    assert(object(Object)),
    assert(objectType(Object,Type)),
    write(Object),write(" with type "),write(Type),write(' created'),nl.


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

createChildSubj:-
    write("Parent subject name:"),
    read(SubjectParent),
    write("Child subject name:"),
    read(SubjectChild),
    write("Type:"),
    read(Type),
    type(Type),
    not(subject(SubjectChild)),
    nonvar(SubjectChild),
    check_subject(SubjectParent),
    createChild(SubjectParent,SubjectChild,Type);
    write("Wrong params").

createChild(SubjectParent,SubjectChild,Type):-
	check_subject(SubjectParent),
        check_type(Type),
        newSubject(SubjectChild,Type);
	write("Wrong params"),nl,false.

createChildSecure(SubjectParent,SubjectChild,Type):-
	check_subject(SubjectParent),
        check_type(Type),
        subjectType(SubjectParent,ParType),
        validType(ParType,Type),
        newSubject(SubjectChild,Type);
	write("Wrong Params"),nl,false.


copyObject_m:-
    write("Subject:"),
    read(Subject),
    write("From object:"),
    read(From),
    write("To object:"),
    read(To),
    write("New type:"),
    read(Type),
    copyObject(Subject,From,To,Type).

copyObject(Subject,From,To,Type):-
    %owner(Subject,From),
    check_subject(Subject),
    check_object(From),
    check_type(Type),
    canCopy(From),
    checkRight_pred(Subject,From,r),
    newObject(To,Type),
    assert(access(Subject,To,r)),
    assert(access(Subject,To,w)),
    assert(owner(Subject,To));
    write("Wrong params"),fail.

allowCopy_m:-
    write("Subject:"),
    read(Subject),
    write("From object:"),
    read(Object),
    allowCopy(Subject,Object).

disableCopy_m:-
    write("Subject:"),
    read(Subject),
    write("From object:"),
    read(Object),
    disableCopy(Subject,Object).

allowCopy(Subject,Object):-
	check_subject(Subject),
        check_object(Object),
        owner(Subject,Object),
        assert(canCopy(Object)),
        write("Copy for this object allowed");
	write("Wrond params"),nl,false.

allowRight(Subject,ToSubject,Object,Right):-
	owner(Subject,Object),
	check_subject(Subject),
	check_subject(Subject),
	check_object(Object),
	check_right(Right),
	addRight(ToSubject,Object,Right);
	write("Wrong params"),nl,fail.


createObjectAndOwn(Subject,Object,Type):-
	not(object(Object)),
	check_subject(Subject),
	assert(owner(Subject,Object)),
	newObject(Object,Type),
        assert(access(Subject,Object,r)),
        assert(access(Subject,Object,w));
	write("Wrong params in createObjectAndOwn"),nl,fail.


disableCopy(Subject,Object):-
	check_subject(Subject),
        check_object(Object),
        owner(Subject,Object),
        retract(canCopy(Object)),
        write("Copy for this object disabled");
	write("Wrond params"),nl,false.

