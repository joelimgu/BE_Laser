
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
#define SEUIL 5000000
#define FIN_SON 11024

extern int DFT(short int * Signal64ech, char k);
extern short int LeSignal[] ; 
extern int GetIndex(void); 

/* si on note int * LeSignal 
il prend les premières cases de LeSignal et les transforme en (int *) => nul un peu */ 


typedef struct {
	int freq; 
	int score;
	int amplitude_min;
}joueur; 

joueur joueurs[4]={{joueur1,0,SEUIL},{joueur2,0,SEUIL},{joueur3,0,SEUIL},{joueur4,0,SEUIL}};

char cible_active=1; 


// buffer dma en global pour que le callback puisse s'en servir pour les calculs
short dma_buf[64]; 
int dft[64];
char last_touched = 0;
int dfttest; 

void DMA_callback(){
	// si le son est en train de se jouer, on ne fait rien pour éviter que le son soit moche à cause de l'interrupt 
	if (GetIndex() !=FIN_SON) return ;
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	for (int k = 0; k < 64; k++){
		dft[k]=DFT(dma_buf,k);
	}
 
	char touche = 0;
	for (char i = 0; i<4; i++) {
		
		if ((dft[joueurs[i].freq]) > joueurs[i].amplitude_min) {
			if (last_touched == 0) {
				joueurs[i].score += 1;
				Prepare_Afficheur(i+1,joueurs[i].score); 
				StartSon();
				Prepare_Clear_LED(cible_active-1); 
				cible_active=(cible_active%4)+1; 
 
				Choix_Capteur(cible_active); 
				Prepare_Set_LED(cible_active-1); 
			}
			touche = 1;
		}
	}
	
	
	if (touche == 1) {
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
	// quand son et systick ont la même prio, RIEN NE MARCHE (T_T)
	Systick_Prio_IT( 1, DMA_callback );
	SysTick_On;
	SysTick_Enable_IT;

	// adc 
	Init_TimingADC_ActiveADC_ff(ADC1,72);
	Single_Channel_ADC(ADC1,2); 
	Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );

	Init_ADC1_DMA1( 0, dma_buf );
	
	
	// setup son 
	PWM_Init_ff( TIM3, 3, 720); // 100KHz
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	Timer_1234_Init_ff( TIM4,6552 ); // TE*RCC_FREQ 
	Active_IT_Debordement_Timer( TIM4, 2, CallbackSon ); 
	
	Init_Affichage(); 
	Prepare_Set_LED(cible_active-1); 
	Choix_Capteur(cible_active); 

}

int main(void){


setup(); 

 
while	(1)
	{
		
		Mise_A_Jour_Afficheurs_LED();
	}
}

