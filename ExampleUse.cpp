#include <iostream>
#include <stdio.h>

extern "C" uintptr_t __fastcall GetModuleBaseAddress(uintptr_t name);

int main()
{
	const char* file_name = "ntdll.dll";
	printf("0x%p\n", file_name);
	uintptr_t address = GetModuleBaseAddress((uintptr_t)file_name);
	std::cout << std::hex << address << std::endl;
	return 0;
}
