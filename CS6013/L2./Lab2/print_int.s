;;		Samantha Pope
;;		01.29.2024
;;		Lab2:AssemblyPrintInteger


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


section .rodata ;read only data section

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text ; this says that we're about to write code (as opposed to data)
	global print_int
	global main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;start actual code

  ;; C++ equivalent void print_int(long x);
	;;     
	;;1234 => '1','2','3','4' => in last assignment we could print array 
	;;of chars one by one 
	;; 1234 / 10 => 123 remainder 4
	;; 123 / 10 => 12 remainder 3
	;; 12 / 10 => 1 remainder 2
	;; 1 / 10 => 0 remainder 1
	;; 0 means STOP 


print_int:
   ;;prolouge
	push rbp 	; save location of the base pointer (previous one)
	mov rbp, rsp 	; put the stack pointer into the spot of the base pointer

	;;largest long is 20 digits -> so we need to make room for 20 digits
	sub rsp, 20 	; save 20 bytes (characters) on stack for each digit

	mov rax, rdi 	; copy the passed in (1st) param (x) into AX reg to do the work there
	mov rbx, 1	; BX is the "iTH' location in digit array (index)

	mov byte [rsp+1], 10 	; move carriage return (ascii 10) into the 1st location of my digits array, have to deref rsp and then put a byte in


    ;;begin algorithm -> note:dividing is a label
dividing:
	cmp rax, 0	; compare rax with 0
	je prepare_print	; if the above condition is equal then we jump to print

	mov rdx, 0 	; have to initialize rdx to 0 -> if you don't then div crashes
	mov rcx, 10
	div rcx		; rax <= rax / rcx .. remainder is put into DX
	add rdx, 48	; turn the number 4 into the digit '4' (based on ascii values --> see chart)
	mov [rsp+rbx], rdx	; save the remain at rsp @ bx, how you say that is add it to the location
	inc rbx		; inc adds one, we want to increment this so we can keep saving the remainders 

	jmp dividing


;;i put this into it's own section because i was getting errors with it
prepare_print:
	dec rbx

print:
    mov rax, 1            ; syscall number for write
    mov rdi, 1            ; file descriptor 1 (stdout)
    lea rsi, [rsp+rbx]    ; load the address of rsi with where we want to START printing from, we go to
				; the end so that it will print
    mov rdx, 1            ; we want to print one character at a time


reverse_loop:
    cmp rbx, 0            ; check if rbx is 0, if it is, we're done
    jl done_printing      ; jump if rbx is less than 0 -> note: rbx is the digit counter

    ; print the current character
    syscall

    ; move to the previous character
    dec rsi               ; adjust the pointer to the previous character
    dec rbx               ; decrement the digit counter
    jmp reverse_loop      ; repeat the loop

done_printing:
    mov rax, 1		; syscall to write
    mov rdi, 1		; stdout because it is 1
    mov rdx, 1		; single byte will be written at a time to wherever we decide rdi should print
    lea rsi, [rsp]      ; pointer to where newline should be stored
    syscall		; call the system call
    jmp epilogue	; jump to the epilogue section to clean up the code


epilogue:
    mov rsp, rbp
    pop rbp
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


main:

	mov rdi, 1234 	; how we put parameters into assembly code
	call print_int

	mov rax, 60	;sys_exit system call
	mov rdi,0	;1st param: error code
	syscall

