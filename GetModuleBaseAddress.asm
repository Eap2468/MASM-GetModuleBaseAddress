.code

GetModuleBaseAddress proc arg:qword
	xor rsi, rsi

	xor rax, rax
	xor r8, r8
	mov rax, qword ptr gs:[60h]		;Gets the PEB

	mov rax, [rax + 18h]			;LDR in the PEB
	mov rax, [rax + 20h]			;start of the LDR list

	mov r8, [rax + 8h]				;Stores the address of the last entry
	mov rax, [rax]					;First entry
	jmp NextEntry

NextEntry:
	cmp rax, r8
	je Fail			;List is at the end

	xor rdi, rdi
	mov rdi, rax
	add rdi, 48h	;FullDLLName _UNICODE_STRING
	add rdi, 8h		;_UNICODE_STRING buffer
	mov rdi, [rdi]	;Name of current module
	
	xor rsi, rsi
	xor rbx, rbx
	mov r9, rcx		;Saves the input string to another register to prevent the address being messed up when doing the comparison
	jmp Compare

NextEntryPrep:
	mov rax, [rax]	;InLoadOrderLinks
	mov rax, [rax]	;Address of the next module
	jmp NextEntry

Compare:
	mov sil, [rdi]		;Loads the current character of the current module
	mov bl, [r9]		;Loads the current character of the input string

	cmp sil, bl			;Compare the current characters
	jne NextEntryPrep

	cmp sil, 0			;Loop has reached null terminating character so the strings match
	je Found

	add rdi, 2			;Characters in the buffer are seperated by a space so you have to increment by two bytes
	inc r9				;Increment to the next character

Found:
	mov rax, [rax + 20h]	;InInitializationOrderLinks
	jmp Exit				;First address is base address of module

Fail:
	xor rax, rax
	jmp Exit

Exit:
	ret

GetModuleBaseAddress endp
end
