

#include "DriverJeuLaser.h"

extern int Xr(short int * Signal64ech, char k);
extern int Xi(short int * Signal64ech, char k);
extern int DFT(short int * Signal64ech, char k);
extern short int LeSignal[] ; 
/* si on note int * LeSignal 
il prend les premi�res cases de LeSignal et les transforme en (int *) => nul un peu */ 


int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Apr�s ex�cution : le coeur CPU est clock� � 72MHz ainsi que tous les timers
CLOCK_Configure();


for (int i = 0; i < 64; i++){
	DFT(LeSignal,i); 
}

//============================================================================	
	
	
while	(1)
	{

	}
}

