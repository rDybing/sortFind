/*********************************
 * sortFind with type-array demo *
 *                               *
 * Made in App Game Kit 2        *
 *                               *
 * CC-BY Roy Dybing 2018         *
 *                               * 
 * github: rDybing               *
 * slack: rdybing                *
 *********************************/

SetErrorMode(2)

SetWindowTitle("sortFind")
SetWindowSize(1280, 1024, 0)
SetWindowAllowResize(1)
SetVirtualResolution(1280, 1024)
SetOrientationAllowed(1, 1, 1, 1)
SetSyncRate(30, 0)
SetScissor(0,0,0,0)
UseNewDefaultFonts(1)
SetPrintSize(12)

#constant false = 0
#constant true = 1
#constant nil = -1
#constant maxArray = 9999

type myTypeT
	myNumber as integer
	myString as string
endType

type numSortedT
	myNumber as integer
	index as integer
endType

type strSortedT
	myString as string
	index as integer
endType

type stateT
	index as integer
	toFindNum as integer
	toFindStr as string
	choice as integer
endType

main()

function main()
	
	myType as myTypeT[]
	numSort as numSortedT[]
	strSort as strSortedT[]
	state as stateT
	
	myType = populateMyType()
	
	do
		repeat
			print("myType filled with random gibberish")
			print("Click to continue")
			sync()
		until GetPointerPressed()	
		
		getSortedArrays(myType, numSort, strSort)
		selectToFind(numSort, strSort, state)
		
		sleep(500)
		
		if state.index <> nil
			repeat
				print("Found it! Index is: " + str(state.index))
				if state.choice = 1
					print("For number: " + str(state.toFindNum))
				else
					print("For string: " + state.toFindStr)
				endif
				print("myType contents at that index is:")
				print("myNumber: " + str(myType[state.index].myNumber))
				print("myString: " + myType[state.index].myString)
				print("click to continue...")
				sync()
			until GetPointerPressed()
		else
			repeat
				if state.choice = 1
					Print("Did not find " + str(state.toFindNum))
				else
					Print("Did not find " + state.toFindStr)
				endif
				print("click to continue...")
				sync()
			until GetPointerPressed()
		endif
	loop

endFunction

function populateMyType()
	SetRandomSeed(GetUnixTime())
	mt as myTypeT[]
	mtTemp as myTypeT
	
	for i = 0 to maxArray
		mtTemp.myNumber = random(0, 65535)
		mtTemp.myString = sha1(str(mtTemp.myNumber))
		mt.insert(mtTemp)
	next i	
	
endFunction mt

function getSortedArrays(mt as myTypeT[], ns ref as numSortedT[], ss ref as strSortedT[])
	
	nst as numSortedT
	sst as strSortedT
	ns.length = nil
	ss.length = nil
	
	for i = 0 to mt.length
		nst.myNumber = mt[i].myNumber
		nst.index = i
		sst.myString = mt[i].myString
		sst.index = i
		ns.insert(nst)
		ss.insert(sst)		
	next
	
	ns.sort()
	ss.sort()
	
	repeat
		print("Arrays Sorted")
		print("click to continue...")
		sync()
	until GetPointerPressed()
	
endFunction

function selectToFind(ns as numSortedT[], ss as strSortedT[], state ref as stateT)
	
	index as integer
	ok as integer	
	choice as integer
	
	state.toFindNum = ns[random(0, maxArray)].myNumber
	state.toFindStr = ss[random(0, maxArray)].myString
	
	repeat
		print("1: Find Number")
		print("2: Find String")
		if GetRawKeyPressed(49)
			state.choice = 1
			ok = true
		endif
		if GetRawKeyPressed(50)
			state.choice = 2
			ok = true
		endif
		sync()
	until ok 
	
	select state.choice
	case 1
		repeat
			print("will try to find index containing number: " + str(state.toFindNum))
			print("click to continue...")
			sync()
		until GetPointerPressed()
	endCase
	case 2
		repeat
			print("will try to find index containing string: " + state.toFindStr)
			print("click to continue...")
			sync()
		until GetPointerPressed()
	endCase
	endSelect
	findIndex(ns, ss, state)
	
endFunction state

function findIndex(ns as numSortedT[], ss as strSortedT[], state ref as stateT)
	
	rightMost as integer
	leftMost as integer
	middle as integer
	iterations as integer
	max as integer
	
	leftMost = -1
	rightMost = ns.length
	
	
	if state.choice = 1
		while rightMost > leftMost + 1
			middle = (leftMost + rightMost) / 2
			if ns[middle].myNumber >= state.toFindNum
				rightMost = middle
			else
				leftMost = middle
			endif
			inc iterations
		endWhile
		
		if rightMost < ns.length and ns[rightMost].myNumber = state.toFindNum
			state.index = ns[rightMost].index
		else
			state.index = nil
		endif
	else
		while rightMost > leftMost + 1
			middle = (leftMost + rightMost) / 2
			if ss[middle].myString >= state.toFindStr
				rightMost = middle
			else
				leftMost = middle
			endif
			inc iterations
		endWhile
		
		if rightMost < ss.length and ss[rightMost].myString = state.toFindStr
			state.index = ss[rightMost].index
		else
			state.index = nil
		endif		
	endif
	
	repeat
		Print("Got result in " + str(iterations) + " iterations with an array length of " + str(ns.length))
		print("click to continue...")
		sync()
	until getPointerPressed()
	
endFunction
