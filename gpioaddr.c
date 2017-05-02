#include <stdio.h>

int main() {
  int gpio_addr = (((0x3F200000) & 0x00FFFFFF) + (((0x3F200000) >> 4) & 0x0F000000) + 0xF0000000);
	printf("%x\n", gpio_addr);

  int test1 = (gpio_addr+ (4*(22/10)));
  int test2 = (1<<(((22)%10)*3));
  int test3 = (gpio_addr+ (4*(7 + (22/32))));
  int test4 = 1 << (22% 32);

  printf("%x %x %x %x\n", test1, test2, test3, test4);
}

/*
 * int gpio_addr = (((addr) & 0x00FFFFFF) + (((addr) >> 4) &0x0F000000) + 0xF0000000)
 * printf("%d\n", gpio_addr);
 * (gpio_addr+ (4*(GPIO_NR/10))) |= (1<<(((GPIO_NR)%10)*3));
 * (gpio_addr+ (4*(7 + (GPIO_NR/32)))) = 1 << (GPIO_NR% 32);
 *
 * GPIO_NR: OUTPUT 17,18,27,22 INPUT: 10, 9
 *
 * Rätt svar:
 * gpio_addr = 0xf3200000
 * 1. 0xf3200008
 * 2. 40
 * 3. 0xf320001c
 * 4. 400000
 */
