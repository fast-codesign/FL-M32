/*
 * Copyright (c) 2001, Swedish Institute of Computer Science.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the Institute nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * Author: Adam Dunkels <adam@sics.se>
 * Ported by Junnan Li <lijunnan@nudt.edu.cn>
 *
 * $Id: tapdev.c,v 1.8 2006/06/07 08:39:58 adam Exp $
 */



#if 1

#include "tapdev.h"
#include "uip.h"
#include "uip_arp.h"

//* mac address;
struct uip_eth_addr uip_mac;
static unsigned char ethernet_mac[6] = 
  { 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

//* zero_buffer used to pad ARP packet;
u32_t zero_buffer[8] ={0,0,0,0,0,0,0,0};

void tapdev_init(void) {
    for (uint8_t i = 0; i < 6; i++)
    {
        uip_mac.addr[i] = ethernet_mac[i];
    }
    uip_setethaddr(uip_mac); /* 设定uip mac地址*/
}

uint16_t tapdev_read(void) {
  u16_t len;
  //* read length;
  len = *((volatile uint32_t *) (ADDR_RECV_LEN));
  //* point to current data's addr;
  // uint32_t addr_recv = ADDR_RECV_PKT;
  memcpy(uip_buf, (void*) ADDR_RECV_PKT, len);
  //* finish copying;
  *((volatile uint32_t*)ADDR_RECV_TAG) = 2;
  //* print recv packet's info;
  printf("recv len is %d\r\n",len);
  // for(int i=0; i<len; i++){
  //   printf("%02x_",*((u8_t*) (ADDR_RECV_PKT)+i));
  // }

  return len;
}

void tapdev_send(void) {

  uint32_t addr_send = ADDR_SEND_PKT;

  //* write length, if len < 60B, then padding to 60B;
  u16_t len = p->tot_len; //* current length;
  u16_t len_pad = 0;      //* length need to pad;
  if(len < 60){
    len_pad = 60 - len;
    len = 60;
  }
  *((volatile uint32_t*)ADDR_SEND_LEN) = len;
  //* copy to sending buffer in NIC;
  memcpy((void*) ADDR_SEND_PKT, uip_buf, uip_len);
  //* print current pbuf's length and data;
  // printf("\r\ncur_send_len: %d\r\n",q->len);
  // for(int i=0; i<q->len; i++){
  //   printf("%02x_",*((u8_t*) (q->payload)+i));
  // }
  addr_send += uip_len;

  //* pad ARP to 60B;
  memcpy((void*) addr_send, (void*) zero_buffer, len_pad);

  //* print recv info;
  printf("tot_send_len: %d\r\n",len);
  // for(int i=0; i<len; i++){
  //   printf("%02x_",*((u8_t*) (ADDR_SEND_PKT)+i));
  // }

  //* write sending tag;
  *((volatile uint32_t*)ADDR_SEND_TAG) = 1;
  //* wait finishing sending packet;
  while(*((volatile uint32_t *) ADDR_SEND_TAG) == 1);

}


#else

#define UIP_DRIPADDR0   192
#define UIP_DRIPADDR1   168
#define UIP_DRIPADDR2   0
#define UIP_DRIPADDR3   1

#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/uio.h>
#include <sys/socket.h>

#ifdef linux
#include <sys/ioctl.h>
#include <linux/if.h>
#include <linux/if_tun.h>
#define DEVTAP "/dev/net/tun"
#else  /* linux */
#define DEVTAP "/dev/tap0"
#endif /* linux */

#include "uip.h"

static int drop = 0;
static int fd;


/*---------------------------------------------------------------------------*/
void
tapdev_init(void)
{
  char buf[1024];
  
  fd = open(DEVTAP, O_RDWR);
  if(fd == -1) {
    perror("tapdev: tapdev_init: open");
    exit(1);
  }

#ifdef linux
  {
    struct ifreq ifr;
    memset(&ifr, 0, sizeof(ifr));
    ifr.ifr_flags = IFF_TAP|IFF_NO_PI;
    if (ioctl(fd, TUNSETIFF, (void *) &ifr) < 0) {
      perror(buf);
      exit(1);
    }
  }
#endif /* Linux */

  snprintf(buf, sizeof(buf), "ifconfig tap0 inet %d.%d.%d.%d",
	   UIP_DRIPADDR0, UIP_DRIPADDR1, UIP_DRIPADDR2, UIP_DRIPADDR3);
  system(buf);

}
/*---------------------------------------------------------------------------*/
unsigned int
tapdev_read(void)
{
  fd_set fdset;
  struct timeval tv, now;
  int ret;
  
  tv.tv_sec = 0;
  tv.tv_usec = 1000;


  FD_ZERO(&fdset);
  FD_SET(fd, &fdset);

  ret = select(fd + 1, &fdset, NULL, NULL, &tv);
  if(ret == 0) {
    return 0;
  }
  ret = read(fd, uip_buf, UIP_BUFSIZE);
  if(ret == -1) {
    perror("tap_dev: tapdev_read: read");
  }

  /*  printf("--- tap_dev: tapdev_read: read %d bytes\n", ret);*/
  /*  {
    int i;
    for(i = 0; i < 20; i++) {
      printf("%x ", uip_buf[i]);
    }
    printf("\n");
    }*/
  /*  check_checksum(uip_buf, ret);*/
  return ret;
}
/*---------------------------------------------------------------------------*/
void
tapdev_send(void)
{
  int ret;
  /*  printf("tapdev_send: sending %d bytes\n", size);*/
  /*  check_checksum(uip_buf, size);*/

  /*  drop++;
  if(drop % 8 == 7) {
    printf("Dropped a packet!\n");
    return;
    }*/
  ret = write(fd, uip_buf, uip_len);
  if(ret == -1) {
    perror("tap_dev: tapdev_send: writev");
    exit(1);
  }
}
/*---------------------------------------------------------------------------*/

#endif