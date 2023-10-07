#include "includes/headers.p4"
#include "includes/metadata.p4"
#include "includes/parser.p4"
#include "includes/actions.p4"
#include "includes/tofino.p4"

#include "l2_switch.p4"
#include "rnn.p4"
#include "tustate.p4"
//#include "fmax.p4"

action a_do_recirc() {
    recirculate(68);
}

table t_recirc {
    actions {
	a_do_recirc;
    }
    default_action : a_do_recirc;
}

control ingress {

    //if (valid(tcp) or valid(udp)) {
    //    
    //} else {
    //    apply(l2_forward);
    //}

    do_flow_cnt();

    if (ig_intr_md.ingress_port == 68) {
	    if (rstate.overflow > 1) {
		    do_merge_result_2();		
		    if (m11.r1 < 0x80) {
			    apply(t_set_decision_one);
		    } else {
			    apply(t_set_decision_two);
		    }
		    apply(t_update_decision);
		    apply(dc_l2_forward);
	    } else {
		    // follow decision
		    apply(t_take_decision);
		    apply(dc_l2_forward);
	    }
    } else {
	    if (rstate.overflow > 1) {
		    //update state and update decision

		    do_onehot_pktlen();

		    do_calc_mat();
		    do_tanh_and_update_state();
		    //do_merge_result();		
		    do_merge_result_1();		
		
	 	    apply(t_touch_tbl); 	
	    }
	    //recirculate
	    apply(t_recirc);
    }

    // do_flow_cnt();
    //if (rstate.overflow > 1) {
    //    //update state and update decision

    //    do_onehot_pktlen();

    //    do_calc_mat();
    //    do_tanh_and_update_state();
    //    do_merge_result();		

    //    // m11.r1 vs. m21.r1
    //    // find max	
    //    if (m11.r1 < 0x80) {
    //        apply(t_set_decision_one);
    //    } else {
    //        apply(t_set_decision_two);
    //    }
    //    apply(t_update_decision);
    //    apply(dc_l2_forward);
    //} else {
    //	// follow decision
    //    apply(t_take_decision);
    //    apply(dc_l2_forward);
    //}


    //old one
    //do_ids();
}

control egress {
}

