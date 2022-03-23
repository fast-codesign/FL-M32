/*
 *  iCore_software -- Software for TimelyRV (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Date: 2022.03.22
 *  Description: basic processing of icore_software. 
 */

#include "riscvnetif.h"
#include "firmware.h"
#include "lwip/tcp.h"

// #include "ping.h"
// #include "lwip/udp.h"

#define V2_1_3 1

static struct netif server_netif;
struct netif *p_server_netif;
#ifdef V2_1_3
	struct ip4_addr ipaddr, netmask, gw;
#else
	struct ip_addr ipaddr, netmask, gw;
#endif

unsigned int timer_irq_count;

int main(){
	timer_irq_count = 0;

	//* open irq, irq is closed in default configuration;
	__irq_enable();	//* should comment Start.S's "#define CTRLIRQ_INSN 1" if do not define instr_ctlirq;

	//* test printf function, output by uart;
	int tail =0; //* TODO
	printf("Hello World!\r\n");

	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] =
	{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };
	/* initliaze IP addresses to be used */
	IP4_ADDR(&ipaddr,  192, 168,   1, 10);
	IP4_ADDR(&netmask, 255, 255, 255,  0);
	IP4_ADDR(&gw,      192, 168,   1,  1);

	lwip_init();

	p_server_netif = &server_netif;
	if (netif_add(p_server_netif, &ipaddr, &netmask, &gw,
						(void*)&tail,
						ethernetif_init,
						ethernet_input
						) == NULL)
	{
		printf("init error\r\n");
		return 0;
	}

	netif_set_default(p_server_netif);
	/* specify that the network if is up */
	if (netif_is_link_up(p_server_netif)) {
		/*When the netif is fully configured this function must be called */
		netif_set_up(p_server_netif);
	}
	else {
		/* When the netif link is down this function must be called */
		netif_set_down(p_server_netif);
	}
	// netif_set_up(p_server_netif);

	/* start the application (web server, rxtest, txtest, etc..) */
	// start_tcp_application();
	// start_udp_application();
	// udpecho_raw_init();

	printf("system boot finished\r\n");
	
	/* receive and process packets */
	echo_init();
	printf("tcp bind port 7\r\n");
	// ping_init();

	__set_timer_irq(1250000000); //* simulation is '50000'

	while (1) {
		if (timer_irq_count != 0){
			timer_irq_count = 0;
			tcp_tmr();
			printf("tcp_tmr\r\n");
		}
		else timer_irq_count = 0;
		ethernetif_input(p_server_netif);
	}
}