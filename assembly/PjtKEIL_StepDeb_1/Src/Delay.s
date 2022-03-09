	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
VarTime	dcd 0 ;VarTime=0 (var de 32bits) 
	
; ===============================================================================================
	
;constantes (�quivalent du #define en C)
TimeValue	equ 900000


	EXPORT Delay_100ms ; la fonction Delay_100ms est rendue publique donc utilisable par d'autres modules.
	export VarTime

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		


; REMARQUE IMPORTANTE 
; Cette mani�re de cr�er une temporisation n'est clairement pas la bonne mani�re de proc�der :
; - elle est peu pr�cise
; - la fonction prend tout le temps CPU pour... ne rien faire...
;
; Pour autant, la fonction montre :
; - les boucles en ASM
; - l'acc�s �cr/lec de variable en RAM
; - le m�canisme d'appel / retour sous programme
;
; et donc poss�de un int�r�t pour d�buter en ASM pur

Delay_100ms proc ; ~ d�claration de fonction Delay_100ms
	
		ldr r0,=VarTime ; r0= &VarTime 		  
						  
		ldr r1,=TimeValue ; r1= 900000
		str r1,[r0] ; VarTime= 900000 
		
BoucleTempo	
		ldr r1,[r0] ; r1= 900000    				
						
		subs r1,#1 ; r1-=1 
		str  r1,[r0] ; VarTime= 899999
		bne	 BoucleTempo ; refait un tour de boucle si VarTime (r�sultat soustraction) /= 0 
			
		bx lr ; ~retour de fonction (retour de la prise en main � la fonction qui a appel� delay)
		endp ; end fonction 
		
		
	END	; fin programme  