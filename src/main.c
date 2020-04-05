#include <stm32f4xx.h>

int main (void)
{
	//	GPIOD portuna clock sinyali veriyoruz GPIOD AHB1 clock bus ına bağlıdır @reference_manual:65
	RCC->AHB1ENR |= 0x8; 

	// D portunun 12, 13, 14, 15. pinlerine kart üzerinde bulunan ledler bağlıdır @user_manual:31
	//	PD15. pinini Mode Register dan output olarak set edilmesi @reference_manual:281
	GPIOD->MODER = (1 << 30);

	while (1)
	{
		//	PD15 pininin Output Data Registerına toogle işlemi uygulanması @reference_manual:283
		GPIOD->ODR ^= (1 << 15);
		//	Rastgele bir bekleme süresi
		for(int i=0; i<=10000000; i++);
	}
}
