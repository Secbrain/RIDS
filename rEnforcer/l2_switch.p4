#ifndef _L2SW_H_
#define _L2SW_H_

table l2_forward {
    reads {
        ig_intr_md.ingress_port : exact;
	//decision_port : exact;
    }
    actions {
        set_egr; nop; _drop;
    }
}

table dc_l2_forward {
    reads {
        //ig_intr_md.ingress_port : exact;
	fr.decision : exact;
    }
    actions {
        set_egr; nop; _drop;
    }
}

#endif

