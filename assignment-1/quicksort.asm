.quicksort:
		cmp r2,r4         @ start < end
		beq .return
		bgt .return
		sub sp, sp, 16    @ create space for start,end,return address and pivot
		st r2, [sp]       @ store start address in the stack
		st r4, 4[sp]      @ store end address in the stack
		st ra, 8[sp]      @ store return address in the stack
		call .partition   @ returns value in r3
		st r3, 12[sp]     @  store pivot in the stack
		sub r4, r3, 4     @ new end = pivot-4
		call .quicksort   
		ld r2, 0[sp]      @ load start address
		ld r4, 4[sp]      @ load end address
		ld r3, 12[sp]     @ load pivot address
		add r2,r3,4       @ new start = pivot + 4
		call .quicksort
		ld ra, 8[sp]      @ load return address
		add sp, sp, 16    @ delete activation block
		ret
		
		

			
.partition:
		@ args are r2(start),r4(end)
		ld r5, 0[r4]       @ choose last element as pivot
		sub r6,r2,4        @ i = start - 4
		mov r7,r2          @ j = start
		.loop:
			cmp r7, r4     @ compare i and end address
			beq .break
			ld r8,0[r7]    @ load arr[j]
			cmp r8, r5     @ compare arr[j] and arr[pivot]
			add r7, r7, 4  @ j + 4 for loop indexing
			bgt .loop
			beq .loop
			add r6, r6, 4  @ i + 4
			sub r11,r7,4   @ j
			ld r9,0[r6]    @ swapping arr[i+4] and arr[j]
			ld r10,0[r11]
			st r10,0[r6]
			st r9,0[r11]
			b .loop
		.break:
			add r6, r6, 4  @ i + 4
			ld r9,0[r6]    @ swap [i+4] and [high]
			ld r10,0[r4]
			st r9,0[r4]
			st r10,0[r6]
			mov r3,r6      @ return pivot address in r3
			ret

		

.return:
        ret
.main:

	@ Loading the values as an array into the registers
	mov r0, 0    
	mov r1, 12	@ replace 12 with the number to be sorted
	st r1, 0[r0]
	mov r1, 3	@ replace 7 with the number to be sorted
	st r1, 4[r0]
	mov r1, 1      @ replace 11 with the number to be sorted
	st r1, 8[r0]
	mov r1, 0       @ replace 9 with the number to be sorted
	st r1, 12[r0]
	mov r1, 12       @ replace 3 with the number to be sorted
	st r1, 16[r0]
	mov r1, 6      @ replace 15 with the number to be sorted
	st r1, 20[r0]
	@ EXTEND ON SIMILAR LINES FOR MORE NUMBERS

	mov r2, 0       @ Starting address of the array
	
	@ Retreive the end address of the array
	mov r3, 5	@ REPLACE 5 WITH N-1, where, N is the number of numbers being sorted
	mul r3, r3, 4		
	add r4, r2, r3  @ end address of the array
	
	
	@ ADD YOUR CODE HERE 
		
	call .quicksort

	@ ADD YOUR CODE HERE 

	@ Print statements for the result
        mov r3, 5      @ REPLACE 5 WITH N-1, where, N is the number of numbers being sorted 
        mov r2, 0      @ Starting address of the array
        .printLoop:
           ld r1, 0[r2]
           .print r1
           add r2,r2,4  @ Incrementing address value
           cmp r3, 0    @ r3 contains number of elements in array
           sub r3,r3,1  
	   bgt .printLoop



