
#include "Affichage_Valise.h"
#include "DriverJeuLaser.h"
#include "GestionSon.h"
#define RCC_FREQ 72000000

// step son 
#define TE 0.000091 //période du son 
#define RCC_FREQ 72000000
extern void CallbackSon(void);
extern void StartSon(void);


#define joueur1 17 // 85kHz
#define joueur2 19 // 95kHz
#define joueur3 20 // 100khz
#define joueur4 24 // 120kHz


extern int DFT(short int * Signal64ech, char k);
extern short int LeSignal[] ; 
/* si on note int * LeSignal 
il prend les premières cases de LeSignal et les transforme en (int *) => nul un peu */ 

// les scores s'implémentent n'importe comment 
typedef struct {
	int freq; 
	int score;
	int amplitude_min;
}joueur; 

joueur joueurs[4]={{joueur1,0,100},{joueur2,0,100},{joueur3,0,150},{joueur4,0,150}};



// buffer dma en global pour que le callback puisse s'en servir pour les calculs
short dma_buf[64]; 
int dft[64];
char last_touched = 0;

void DMA_callback(){
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	for (int k = 0; k < 64; k++){
		dft[k]=DFT(dma_buf,k);
	}
 
	char touche = 0;
	for (int i = 0; i<4; i++) {
		// partie entière de la dft des fréquences correspondant aux joueurs 
		if ((dft[joueurs[i].freq]&0xFFC00000>>22) > joueurs[i].amplitude_min) {
			if (last_touched == 0) {
				joueurs[i].score += 1;
			}
			touche = 1;
		}
	}
	// jouer le son si un des joueurs a touché 
	if (touche == 1) {
		StartSon(); 
		last_touched = 1;
	} else {
		last_touched = 0;
	}
}




void setup(void){
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
	
	
	// setup son 
	Timer_1234_Init_ff( TIM4, TE*RCC_FREQ);
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	PWM_Init_ff( TIM3, 3, 720); // 100KHz
	Active_IT_Debordement_Timer( TIM4, 2, CallbackSon );
	
	
	
}

int main(void){


setup(); 

	
while	(1)
	{
		Mise_A_Jour_Afficheurs_LED();
	}
}

