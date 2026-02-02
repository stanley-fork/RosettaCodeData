#!/bin/python3
def SieveSundaramKDNMH105(n=100059960):
	"""
	Sieve of Sundaram,
	parameter n: upper limit of the domain to be sieved for prime numbers
	returns: list of prime numbers <= n
	
	This Sieve of Sundaram has been enhanced to have vastly fewer culls and vastly less checking for primes at harvest time.
	Improvements include:
		Limiting the upper limit of the multiplier i to the square root of the upper limit of the domain.
		Corrected comment: Only mark with multipliers i which have not been already culled. This means that (2*i+1) is a prime number.
		Starting from i^2.
		Conceptually arrange the numbers as a 2D array with 15 or 105 columns. About half the columns would always be entirely marked. Knowing that, and which ones, they can be ignored at harvest time, and so also can be ignored at culling time.

	When finding primes up to 100 million, not culling or harvesting the all-composite columns provides about 1.5x the performance rate.
	
	# Do not mark nor harvest 57 of 105 columns, listed below
	# Do mark and harvest from the remaining columns
	
	# enhancements by David A, Kra extend and improve upon:
	#   https://www.geeksforgeeks.org/sieve-sundaram-print-primes-smaller-n/
	#   and https://en.wikipedia.org/wiki/Sieve_of_Sundaram
	#   see also https://iq.opengenus.org/sieve-of-sundaram/
	"""
	# local constants
	C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15=list(range(16))
	C105=105
	T:bool=True
	F:bool=False
	
	# These are for the 15 column version:
	# (These are well known.)
	#DMHF15=[C0, C3, C5, C6, C8, C9, C11, C14] # Do Mark and Harvest From these columns
	#DNMHFset=set([C1, C2, C4, C7, C10, C12, C13]) # Do Not Mark or Harvest From these columns
	
	# for the 105 column version:
	# Do Not Mark or Harvest From these columns:
	# These were discovered experimentally.
	DNMHFset=set([ 1, 2, 3, 4, 7, 10, 12, 13, 16, 17, 19, 22, 24, 25, 27, 28, 31, 32, 34, 37, 38, 40, 42, 43, 45, 46, 47, 49, 52, 55, 57, 58, 59, 61, 62, 64, 66, 67, 70, 72, 73, 76, 77, 79, 80, 82, 85, 87, 88, 91, 92, 94, 97, 100, 101, 102, 103])
	#Do Mark and Harvest From these columns:
	DMHF=[i for i in range(105) if i not in DNMHFset]
	nNew:int = int((n - C1) / C2)

	###	MARK aka CULL
	marked=bytearray(1)
	marked[0]=T
	marked*=(nNew+C1)
	marked[C0]=F  # 1 is not prime
	
	stop:int=nNew+C1
	maxi:int=C2+int(nNew**0.5)

	for i in range(C3,maxi):
	# faster than
	#	for rowstart in range(C0,len(marked)-C15,C15):
	#		for col in DMHF:
	#			i=rowstart+col
		if i%C105 in DNMHFset: continue # skip entries in the Do Not Mark & Harvest set
		if not marked[i]: continue  # only mark with primes
		# use a slice instead of a loop
		start:int= i+i+C2*i*i # starts with j=i
		step:int= C1+i+i # (1+2*i) is (i+(j+1)+2i(j+1)) and (i+j+2ij)
		lenslice:int  = (stop - start + step - C1 ) // step
		marked[start:stop:step]= [F]* lenslice
				
	### HARVEST
	r=[C2, C3, C5]
	marked.extend([F]*C105) #lazy solution to out of bounds error
	for rowstart in range(C0,len(marked)-C105,C105):
		rowstartx2p1=rowstart+rowstart+C1
		r.extend([rowstartx2p1+j+j for j in DMHF if marked[rowstart+j] ])
	return r

# USAGE
primes=SieveSundaramKDNMH105((n:=1000))
print(n,len(primes),primes)
