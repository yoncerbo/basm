
; void (void)
flush_print_buf:
  movzx rdx, word [print_buf_pos]
  test rdx, rdx
  jz .ret
  sys_write STDOUT, print_buf, rdx
  xor rax, rax
  mov word [print_buf_pos], ax
.ret:
  ret

; void (char ch)
putc:
  movzx rcx, word [print_buf_pos]
  cmp rcx, PRINT_BUF_SIZE
  jl .less
  call flush_print_buf
.less:
  mov byte [rcx + print_buf], dil
  inc rcx
  mov word [print_buf_pos], cx
  cmp rdi, 10
  jne .ret
  call flush_print_buf
.ret:
  ret

; void (const char *str)
print_str:
  push rbx

  mov rbx, rdi
.loop:
  movzx rdi, byte [rbx]
  test rdi, rdi
  jz .ret
  call putc
  inc rbx
  jmp .loop

.ret:
  pop rbx
  ret

print_int:
  push rbx ; number
  push r12 ; divisor
  push r13 ; 10

  mov rbx, rdi
  mov r13, 10

  ; rbx: number
  xor rcx, rcx
  cmp rbx, rcx
  jge .number
  mov rdi, '-'
  call putc
  neg rbx
.number:
  
  mov rax, 1
.loop:
  cmp rbx, rax
  jl .end_loop
  mul r13
  jmp .loop
.end_loop:

  xor rdx, rdx
  div r13
  mov r12, rax
.loop_ch:
  ; rax: number
  ; rcx: divisor
  xor rdx, rdx
  mov rax, rbx
  div r12 ; number / divisor
  mov rbx, rdx ; number %= divisor

  lea rdi, [rax + '0']
  call putc

  xor rdx, rdx
  mov rax, r12
  div r13
  test rax, rax
  jz .loop_ch_end
  mov r12, rax
  jmp .loop_ch
.loop_ch_end:

.ret:
  pop r13
  pop r12
  pop rbx
  ret

printi:
  push rbx
  mov rbx, rsi

  call print_str
  mov rdi, rbx
  call print_int
  mov rdi, 10
  call putc

  pop rbx
  ret

