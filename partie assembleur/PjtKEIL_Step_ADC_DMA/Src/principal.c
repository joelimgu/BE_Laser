

#include "DriverJeuLaser.h"
#define RCC_FREQ 72000000

extern int DFT(short int * Signal64ech, char k);
extern short int LeSignal[] ; 
/* si on note int * LeSignal 
il prend les premières cases de LeSignal et les transforme en (int *) => nul un peu */ 

// todo : tester!

// buffer dma en global pour que le callback puisse s'en servir pour les calculs
short dma_buf[64]; 
int dft[64];

void DMA_callback(){
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	for (int k = 0; k < 64; k++){
		dft[k]=DFT(dma_buf,k);
	}
}

int main(void){

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();


	
// sysTick 
Systick_Period_ff( 0.005*RCC_FREQ );
Systick_Prio_IT( 1, DMA_callback );
SysTick_On;
SysTick_Enable_IT;

// adc 
Init_TimingADC_ActiveADC_ff(ADC1,72);
Single_Channel_ADC(ADC1,2); 
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );

Init_ADC1_DMA1( 0, dma_buf );



//============================================================================	
	
	
while	(1)
	{

	}
}

