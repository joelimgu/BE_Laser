	PRESERVE8
	THUMB   
	

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		

	
; ===============================================================================================
FlagCligno dcd 0


		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici		

	include  ..\Driver\DriverJeuLaser.inc	

timer_callback proc
	

	
	endp 	
		
	END	