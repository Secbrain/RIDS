#ifndef _TS_H_
#define _TS_H_

blackbox stateful_alu s1_state1_activate_alu {
    reg : r_s1_state1;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m11.r1;
}
action a_s1_state1_activate() {
    s1_state1_activate_alu.execute_stateful_alu(rstate.hash_index);
}
blackbox stateful_alu s1_state1_deactivate_alu {
    reg : r_s1_state1;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m11.r1;
}
action a_s1_state1_deactivate() {
    s1_state1_deactivate_alu.execute_stateful_alu(rstate.hash_index);
}
table t_s1_state1_c {
    reads {
	m11.r1 : range;
    }
    actions {
	a_s1_state1_activate;
	a_s1_state1_deactivate;
    }
    size : 2;
}

blackbox stateful_alu s1_state2_activate_alu {
    reg : r_s1_state2;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m12.r1;
}
action a_s1_state2_activate() {
    s1_state2_activate_alu.execute_stateful_alu(rstate.hash_index);
}
blackbox stateful_alu s1_state2_deactivate_alu {
    reg : r_s1_state2;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m12.r1;
}
action a_s1_state2_deactivate() {
    s1_state2_deactivate_alu.execute_stateful_alu(rstate.hash_index);
}
table t_s1_state2_c {
    reads {
	m12.r1 : range;
    }
    actions {
	a_s1_state2_activate;
	a_s1_state2_deactivate;
    }
    size : 2;
}


blackbox stateful_alu s1_state3_activate_alu {
    reg : r_s1_state3;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m13.r1;
}
action a_s1_state3_activate() {
    s1_state3_activate_alu.execute_stateful_alu(rstate.hash_index);
}
blackbox stateful_alu s1_state3_deactivate_alu {
    reg : r_s1_state3;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m13.r1;
}
action a_s1_state3_deactivate() {
    s1_state3_deactivate_alu.execute_stateful_alu(rstate.hash_index);
}
table t_s1_state3_c {
    reads {
	m13.r1 : range;
    }
    actions {
	a_s1_state3_activate;
	a_s1_state3_deactivate;
    }
    size : 2;
}


blackbox stateful_alu s1_state4_activate_alu {
    reg : r_s1_state4;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m14.r1;
}
action a_s1_state4_activate() {
    s1_state4_activate_alu.execute_stateful_alu(rstate.hash_index);
}
blackbox stateful_alu s1_state4_deactivate_alu {
    reg : r_s1_state4;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m14.r1;
}
action a_s1_state4_deactivate() {
    s1_state4_deactivate_alu.execute_stateful_alu(rstate.hash_index);
}
table t_s1_state4_c {
    reads {
	m14.r1 : range;
    }
    actions {
	a_s1_state4_activate;
	a_s1_state4_deactivate;
    }
    size : 2;
}

control do_update_state1 {
    apply(t_s1_state1_c);
    apply(t_s1_state2_c);
    apply(t_s1_state3_c);
    apply(t_s1_state4_c);
}


blackbox stateful_alu s2_state1_activate_alu {
    reg : r_s2_state1;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m21.r2;
}
action a_s2_state1_activate() {
    s2_state1_activate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m21.r1, 1);
}
blackbox stateful_alu s2_state1_deactivate_alu {
    reg : r_s2_state1;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m21.r2;
}
action a_s2_state1_deactivate() {
    s2_state1_deactivate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m21.r1, -1);
}
table t_s2_state1_c {
    reads {
	m21.r1 : range;
    }
    actions {
	a_s2_state1_activate;
	a_s2_state1_deactivate;
    }
    size : 2;
}


blackbox stateful_alu s2_state2_activate_alu {
    reg : r_s2_state2;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m22.r2;
}
action a_s2_state2_activate() {
    s2_state2_activate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m22.r1, 1);
}
blackbox stateful_alu s2_state2_deactivate_alu {
    reg : r_s2_state2;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m22.r2;
}
action a_s2_state2_deactivate() {
    s2_state2_deactivate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m22.r1, -1);
}
table t_s2_state2_c {
    reads {
	m22.r1 : range;
    }
    actions {
	a_s2_state2_activate;
	a_s2_state2_deactivate;
    }
    size : 2;
}


blackbox stateful_alu s2_state3_activate_alu {
    reg : r_s2_state3;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m23.r2;
}
action a_s2_state3_activate() {
    s2_state3_activate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m23.r1, 1);
}
blackbox stateful_alu s2_state3_deactivate_alu {
    reg : r_s2_state3;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m23.r2;
}
action a_s2_state3_deactivate() {
    s2_state3_deactivate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m23.r1, -1);
}
table t_s2_state3_c {
    reads {
	m23.r1 : range;
    }
    actions {
	a_s2_state3_activate;
	a_s2_state3_deactivate;
    }
    size : 2;
}


blackbox stateful_alu s2_state4_activate_alu {
    reg : r_s2_state4;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : m24.r2;
}
action a_s2_state4_activate() {
    s2_state4_activate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m24.r1, 1);
}
blackbox stateful_alu s2_state4_deactivate_alu {
    reg : r_s2_state4;
	
    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : -1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo - 1;

    output_value : alu_lo;
    output_dst : m24.r2;
}
action a_s2_state4_deactivate() {
    s2_state4_deactivate_alu.execute_stateful_alu(rstate.hash_index);
    modify_field(m24.r1, -1);
}
table t_s2_state4_c {
    reads {
	m24.r1 : range;
    }
    actions {
	a_s2_state4_activate;
	a_s2_state4_deactivate;
    }
    size : 2;
}

control do_update_state2 {
    apply(t_s2_state1_c);
    apply(t_s2_state2_c);
    apply(t_s2_state3_c);
    apply(t_s2_state4_c);
}

control do_tanh_and_update_state {
    do_update_state1();
    do_update_state2();
}

#endif
