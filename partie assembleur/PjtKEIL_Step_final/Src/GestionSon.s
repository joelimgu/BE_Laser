	PRESERVE8
	THUMB   
	extern Son 
	extern LongueurSon

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		

	
; ===============================================================================================
SortieSon dcw 0
index dcd 0 
	
	EXPORT CallbackSon
	export SortieSon 
	export index 
	export StartSon
	export GetIndex
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		
	include  ..\Driver\DriverJeuLaser.inc
	

CallbackSon proc 

	ldr r2, =index ; r2 = &index
	ldr r3,[r2] ; r3 = *(&index) 
	ldr r2, =LongueurSon 
	ldr r2, [r2] ; r2 = LongueurSon 
	sub r2, #1
	mov r0, #2
	mul r2, r0 ; passer par registre avec mul ou div... 
	cmp r3,r2;(LongueurSon-1)*2 => fin du son 
	ble jouer_son
	; on a joue une fois le son
	; mov r3,#0
	mov r0, #0
	bl PWM_Set_Value_TIM3_Ch3;
	bx lr


jouer_son
	ldr r1, =Son ; r1 = &Son 
	ldrsh r1, [r1,r3] ; r1 = première case du tableau 
	add r3,#2 ; incrementer index
	ldr r2, =index  ; r2 = &index
	str r3, [r2] ; garder valeur index en memoire
	mov r2, #92 ; 92 = (32767*2) / 719 arrondi pour que ça rentre => shrink l'intervalle 
	sdiv r1, r2 ;
	mov r2, #360
	add r1, r2 ; 720/2 => décalage de l'[] pour enlever les négatifs 
	ldr r0, =SortieSon 
	strh r1, [r0] ; SortieSon = valeur du son sur [0,719]
	push {lr}
	mov r0, r1
	bl PWM_Set_Value_TIM3_Ch3;
	pop {pc}
	;bx lr

	endp 
		
		
		
		

StartSon proc 
	ldr r2, =index ; r2 = &index
	mov r0,#0
	str r0,[r2]
	bx lr
	endp
		
		
				

GetIndex proc 
	ldr r2, =index ; r2 = &index
	ldr r0,[r2]
	bx lr
	endp
		
		
	END