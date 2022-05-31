#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    if (!head) {
        return 0;
    }

    node *tortoise = head;
    node *hare = head;

    do {
        hare = hare->next;
        if (hare) {
            hare = hare->next;
        }

        tortoise = tortoise->next;
    }while (hare != tortoise && hare);

    if(tortoise == hare) return 1;

    return 0;
}
