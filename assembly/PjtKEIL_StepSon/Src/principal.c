

#include "DriverJeuLaser.h"
#define TE 0.000091 //période du son 
#define RCC_FREQ 72000000
extern void CallbackSon(void);
extern void StartSon(void);

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();
Timer_1234_Init_ff( TIM4, TE*RCC_FREQ);
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
PWM_Init_ff( TIM3, 3, 720); // 100KHz
Active_IT_Debordement_Timer( TIM4, 2, CallbackSon );

StartSon();
	

//============================================================================	
	
	
while	(1)
	{
		
		
	}
}

