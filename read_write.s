@Author: 	Aung Naing Oo (N92)
@Description: 	An ARM32 based program that reads the user input from the keyboard and appends to a file (outfile.txt)
@License:	Creative Commons BY-Attribution ShareAlike 3.0 
	
.global _start

_start:
	MOV R7, #3		@ SYSCALL, 3 is for read
	MOV R0, #0		@ 0 is stdin
	MOV R2, #100		@ read in 100 chars
	LDR R1, =string 	@ load the register with the address of string 
	SWI 0			@ make the call

moveon:
	@create/ and -or open file to write to
	LDR R0, =outputFile
	MOV R1, #(o_create+o_append+o_rdwr)	@append mode requires the file to be read and written to as well
	MOV R2, #s_rdwr		@ file access rights
	MOV R7, #sys_open	@ load syscall
	SWI 0			@ make the call
	BPL write		@ jump to write function
	MOV R0, #1		@ 1 is monitor
	LDR R1, =error		@ load error message
	MOV R2, #18		@ length of error message
	MOV R7, #4		@ SYSCALL for write message
	SWI 0			@ make the call 
	B finish		@ terminate the program

write:
	LDR R1, =string		@address of string
	MOV R2, #100		@length of string to write
	MOV R7, #sys_write	@write the content of string to file
	SWI 0
	
	@flush and close outfile	
	MOV R0, R9
	MOV R7, #sys_fsync
	SWI 0
	MOV R0, R9
	MOV R7, #sys_close
	SWI 0

finish:
	MOV R0, #0		@ use 0 as return code
	MOV R7, #1		@ exit through syscall
	SWI 0

.equ 	sys_open, 5
.equ 	sys_read, 3
.equ 	sys_write, 4
.equ 	sys_close, 6
.equ	sys_fsync, 118
.equ 	s_rdwr, 0666
.equ 	o_rdwr, 2
.equ 	o_rdonly, 0
.equ	o_wronly, 1
.equ	o_append, 02000
.equ	o_create, 0100

.data
	outputFile: .asciz "outfile.txt"
	error: .asciz "Output File error \n"
	string: .asciz ""
