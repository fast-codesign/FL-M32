/*
 * Copyright 2020 ETH Zurich
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author: Robert Balas <balasr@iis.ee.ethz.ch>
 */

#include "include/firmware.h"


volatile uint32_t irq_processed           = 1;
volatile uint32_t irq_id                  = 0;
volatile uint64_t irq_pending             = 0;
volatile uint32_t irq_pending32_std       = 0;
volatile uint32_t irq_to_test32_std       = 0;
volatile uint64_t prev_irq_pending        = 0;
volatile uint32_t prev_irq_pending32_std  = 0;
volatile uint32_t first_irq_pending32_std = 0;
volatile uint32_t ie_mask32_std           = 0;
volatile uint32_t mmstatus                = 0;
volatile uint32_t bit_to_set              = 0;
volatile uint32_t irq_mode                = 0;

void mstatus_enable(uint32_t bit_enabled)
{
    asm volatile("csrr %0, mstatus": "=r" (mmstatus));
    mmstatus |= (1 << bit_enabled);
    asm volatile("csrw mstatus, %[mmstatus]" : : [mmstatus] "r" (mmstatus));
}

void mstatus_disable(uint32_t bit_disabled)
{
    asm volatile("csrr %0, mstatus": "=r" (mmstatus));
    mmstatus &= (~(1 << bit_disabled));
    asm volatile("csrw mstatus, %[mmstatus]" : : [mmstatus] "r" (mmstatus));
}

int main(int argc, char *argv[])
{
#ifdef RANDOM_MEM_STALL
    activate_random_stall();
#endif

    // Enable all mie (need to store)
    ie_mask32_std = 0xFFFFFFFF;

    asm volatile("csrw 0x304, %[ie_mask32_std]"
                  : : [ie_mask32_std] "r" (ie_mask32_std));
    // disable mstatues.mie
    mstatus_disable(MSTATUS_MIE_BIT);
    // enable mstatus.mie
    mstatus_enable(MSTATUS_MIE_BIT);

    /* write something to stdout */
    printf("hello world!\n\r");
    while(1);

    return EXIT_SUCCESS;
}
