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
index dcw 0 
	
	EXPORT CallbackSon
	export SortieSon 
	export index 

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		

	

CallbackSon proc 
	ldr r1, =Son ; r1 = &Son 
	ldr r2, =index ; r2 = &index
	ldr r3,[r2] ; r3 = *(&index) 
	ldr r2, =LongueurSon 
	ldr r2, [r2]
	sub r2, #1
	mov r0, #2
	mul r2, r0 ; passer par registre avec mul ou div... 
	cmp r3,r2;(LongueurSon-1)*2 => fin du son 
	;ble jouer_son
	; mov r3,#0

jouer_son
	ldrh r1, [r1,r3] ; r1 = première case du tableau 
	add r3,#2 ; incrementer index
	strh r3, [r2] ; garder valeur index en memoire
	mov r2, #92 
	sdiv r1, r2 ; (32767*2) / 719 arrondi pour que ça rentre => shrink l'intervalle 
	add r1, #360 ; 720/2 => décalage de l'[] pour enlever les négatifs 
	ldr r0, =SortieSon 
	strh r1, [r0] ; SortieSon = valeur du son sur [0,719] 
	bx lr

	endp 
		
	END	