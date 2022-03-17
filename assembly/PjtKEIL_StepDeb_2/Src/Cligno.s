	PRESERVE8
	THUMB   
	

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		

	
; ===============================================================================================
FlagCligno dcd 0

	EXPORT timer_callback ; NE PAS OUBLIER 
	export FlagCligno 
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		

	include  ..\Driver\DriverJeuLaser.inc	

timer_callback proc
	ldr r1, =FlagCligno ; r1 = &FlagCligno
	ldr r2, [r1] ; r2 = *(&FlagCligno) 
	cmp r2, #1 
	bne sinon 
	mov r0, #0 
	str r0, [r1] ; FlagCligno = 0
	mov r0, #1 ; préparer args de GPIOB_Set
	push {lr} ; NE PAS OUBLIER 
	bl GPIOB_Set ; appel de fonction? 
	pop {pc} 
	 
	
sinon 
	mov r0, #1
	str r0, [r1] ; FlagCligno = 1
	mov r0, #1 ; préparer args de GPIOB_Clear
	push {lr} 
	bl GPIOB_Clear ; appel de fonction? 
	pop {pc} 
	
	endp 	
		
	END	