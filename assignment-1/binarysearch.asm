.binarysearch:
		cmp r5,r6      @ r5-left,r6-right
		bgt .return
		add r7,r5,r6   @ index-1 + index-2
		lsr r7,r7,1    @ mid index = (index-1 + index-2)/2
		lsl r7,r7,2    @ address of mid index = mid-index * 4
		ld r8,0[r7]    @ value of mid index
		lsr r7,r7,2    @ index = address / 4
		cmp r8,r0    
		beq .found
		bgt .greater
		b .lesser
		.found:
			   mov r1,1             @ output = 1 when found
			   b .return
		.greater:
			   sub r6, r7, 1        @ new-right = mid - 1 
			   b .binarysearch
		.lesser:
			   add r5, r7, 1        @ new-left = mid + 1
			   b .binarysearch

.sort:                                       @ bubble sort
		mov r10,0                    @ index-1
		.loop1:
			cmp r10,r4           @ index-1 < last address 
			bgt .return
			add r10,r10,4
			mov r11,4            @ index-2
			.loop2:
				cmp r11,r4    @index-2 < last address
				bgt .loop1
				sub r12,r11,4 @ index2 -4
				ld r13,0[r12] @ load value at index2 - 4
				ld r14,0[r11] @ load value at index2
				cmp r13,r14   @ A[index2-4],A[index2]
				bgt .swap
				add r11,r11,4 @increment address+4
				b .loop2
		.swap:
			st r13,0[r11]       @ swap values at index2-4 and index2
			st r14,0[r12]
			add r11,r11,4       @increment address+4
			b .loop2
                      
.return:
        ret
.main:

	@ Loading the values as an array into the registers
	mov r0, 0    
	mov r1, 12	@ replace 12 with the number to be sorted
	st r1, 0[r0]
	mov r1, 7	@ replace 7 with the number to be sorted
	st r1, 4[r0]
	mov r1, 11      @ replace 11 with the number to be sorted
	st r1, 8[r0]
	mov r1, 9   	@ replace 9 with the number to be sorted
	st r1, 12[r0]
	mov r1, 3   	@ replace 3 with the number to be sorted
	st r1, 16[r0]
	mov r1, 15  	@ replace 15 with the number to be sorted
	st r1, 20[r0]
	@ EXTEND ON SIMILAR LINES FOR MORE NUMBERS
	
	@ Store the Element to be searched in r0
	mov r0,7
	
	@Flag for storing the boolean result
	mov r1, 0
	
	mov r2, 0       @ Starting address of the array
	
	@ Retreive the end address of the array
	mov r3, 6	@ REPLACE 6 WITH N, where, N is the number of numbers being sorted
	
	@ ADD YOUR CODE HERE
	sub r4,r3,1
	mul r4,r4,4  @ending address
    call .sort
	mov r5,0       @starting index
	sub r6,r3,1    @ending index
	call .binarysearch
	
	@ ADD YOUR CODE HERE

	@ Print statement for the result 
	@ Boolean result is stored in r1
	.print r1
    
