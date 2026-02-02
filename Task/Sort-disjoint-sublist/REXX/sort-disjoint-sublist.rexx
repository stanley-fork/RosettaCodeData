-- 21 Jan 2026
include Setting

say 'SORT DISJOINT SUBLIST'
say version
say
call Prepare
say 'INPUT'
call Stemshow 'vals. inds.idx.',3
-- Order by index, sync value
call Stemsort 'inds.idx.','inds.val.'
-- Order by value, don't sync index
call Stemsort 'inds.val.'
-- Put ordered values back in list
call Update
say 'OUTPUT'
call Stemshow 'vals.',3
exit

Prepare:
procedure expose vals. inds.
-- Save values
values=7 6 5 4 3 2 1 0; n=Words(values)
do i=1 to n
   vals.i=Word(values,i)
end
vals.0=n
-- Save 1-based indices and their values
indices=7 2 8; n=Words(indices)
do i=1 to n
   index=Word(indices,i); inds.val.i=vals.index; inds.idx.i=index
end
inds.0=n
return

Update:
procedure expose vals. inds.
-- Restore sorted values
do i=1 to inds.0
   index=inds.idx.i; vals.index=inds.val.i
end
return

-- Stemshow Stemsort
include Math
