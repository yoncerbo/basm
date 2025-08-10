format ELF64 executable

entry _start

PRINT_BUF_SIZE equ 64

segment readable executable

include "syscalls.asm"
include "print.asm"

; syscall args: rax, rdi, rsi, rdx, r10, r8, r9
; preserved registers: rbx, rsp, rbp, r12, r13, r14, r15
; scratch registers: rax, rdi, rsi, rdx, rcx, r8, r9, r10, r11

macro c1 fn*, arg* {
  mov rdi, arg
  call fn
}

macro c2 fn*, arg1*, arg2* {
  mov rdi, arg1
  mov rsi, arg2
  call fn
}

read_file:
  push rbx
  push r12

  mov rbx, rdi
  ; rbx: fd
  ; r12: size
  c1 print_str, hello

  sys_open rbx, O_RDONLY, 0

  test rax, rax
  js open_error
  mov rbx, rax

  sys_fstat rbx, stat_buf

  test rax, rax
  js stat_error
  movzx r12, word [stat_buf + ST_SIZE]

  c2 printi, size_msg, r12

  sys_mmap 0, r12, PROT_READ, MAP_PRIVATE, rbx, 0
  cmp rax, MAP_FAILED
  je map_error

  pop r12
  pop rbx
  ret

open_error:
  c2 printi, open_msg, rbx
  jmp exit

stat_error:
  c2 printi, stat_msg, rbx
  jmp exit

map_error:
  mov rax, mmap_msg
  call print_str
  jmp exit
  
exit:
  sys_exit 0

_start:
  c1 read_file, filename
  c1 print_str, rax

  jmp exit

segment readable writeable

hello db "Hello, World!",10,0
filename db "file.txt",0
size_msg db "Size of the file: ",0
open_msg db "ERROR: Open file: ",0
stat_msg db "ERROR: Stat file: ",0
mmap_msg db "ERROR: Failed to map the file",10,0

stat_buf rb ST_STRUCT_SIZE
print_buf rb PRINT_BUF_SIZE
print_buf_pos rw 1
