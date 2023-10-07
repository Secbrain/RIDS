#ifndef _FMAX_H_
#define _FMAX_H_

header_type fres_t {
    fields {
	decision : 8;
    }
}
metadata fres_t fr;

action a_set_decision_one() {
    modify_field(fr.decision, 1);
}

table t_set_decision_one {
    actions {
	a_set_decision_one;
    }
    default_action : a_set_decision_one;
}

action a_set_decision_two() {
    modify_field(fr.decision, 2);
}

table t_set_decision_two {
    actions {
	a_set_decision_two;
    }
    default_action : a_set_decision_two;
}

register r_decision {
    width : 16;
    instance_count : 65536;
}

blackbox stateful_alu reg_update_decision_alu {
    reg : r_decision;
    
    //condition_lo : rstate.is_collision == 1;
    //condition_hi : rstate.flow_cnt == 16;
    condition_lo : rstate.overflow == 1;
    condition_hi : rstate.overflow == 2; // pkt_cnt == 16
    
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 0;
    update_lo_2_predicate : condition_hi;
    update_lo_2_value : fr.decision;
}

action a_update_decision() {
    reg_update_decision_alu.execute_stateful_alu(rstate.hash_index);
}

@pragma stage 8
table t_update_decision {
    actions {
	a_update_decision;
    }
    default_action : a_update_decision;
}

blackbox stateful_alu reg_take_decision_alu {
    reg : r_decision;

    output_value : register_lo;
    output_dst : fr.decision;
}
    //condition_lo : rstate.is_collision == 1;
    //condition_hi : rstate.overflow == 2;
    
    //update_lo_1_predicate : condition_lo;
    //update_lo_1_value : 0;
    //update_lo_2_predicate : not condition_lo;
    //update_lo_2_value : register_lo;

    //output_value : alu_lo; 

action a_take_decision() {
    reg_take_decision_alu.execute_stateful_alu(rstate.hash_index);
}

@pragma stage 8
table t_take_decision {
    actions {
	a_take_decision;
    }
    default_action : a_take_decision;
}





#endif
