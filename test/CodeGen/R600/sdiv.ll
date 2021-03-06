; RUN: llc < %s -march=r600 -mcpu=redwood | FileCheck %s

; The code generated by sdiv is long and complex and may frequently change.
; The goal of this test is to make sure the ISel doesn't fail.
;
; This program was previously failing to compile when one of the selectcc
; opcodes generated by the sdiv lowering was being legalized and optimized to:
; selectcc Remainder -1, 0, -1, SETGT
; This was fixed by adding an additional pattern in R600Instructions.td to
; match this pattern with a CNDGE_INT.

; CHECK: RETURN

define void @test(i32 addrspace(1)* %out, i32 addrspace(1)* %in) {
  %den_ptr = getelementptr i32 addrspace(1)* %in, i32 1
  %num = load i32 addrspace(1) * %in
  %den = load i32 addrspace(1) * %den_ptr
  %result = sdiv i32 %num, %den
  store i32 %result, i32 addrspace(1)* %out
  ret void
}
