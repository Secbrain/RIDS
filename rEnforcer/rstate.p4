#ifndef _RS_H_
#define _RS_H_

field_list flow_keys {
    ipv4.src_ip;
    ipv4.dst_ip;
    ipv4.proto;
}

field_list tcp_flow_keys {
    ipv4.src_ip;
    ipv4.dst_ip;
    ipv4.proto;
    tcp.src_port;
    tcp.dst_port;
}

field_list udp_flow_keys {
    ipv4.src_ip;
    ipv4.dst_ip;
    ipv4.proto;
    udp.src_port;
    udp.dst_port;
}

header_type rnn_state_t {
    fields {
	overflow : 2;
	is_collision : 1;
	flow_cnt : 20; //32;
	hash_key : 16; //32;
	old_key : 16; //32;
	hash_index : 16;
    }
}
metadata rnn_state_t rstate;

// store per-flow states

/* Supported hash function are:
crc16, crc32, crc32_extend, crc32_lsb, crc32_msb, crc_16, crc_16_buypass, crc_16_dds_110, crc_16_dect, crc_16_dnp, crc_16_en_13757, crc_16_genibus, crc_16_maxim, crc_16_mcrf4xx, crc_16_riello, crc_16_t10_dif, crc_16_teledisk, crc_16_usb, crc_32, crc_32_bzip2, crc_32_mpeg, crc_32c, crc_32d, crc_32q, crc_64, crc_64_jones, crc_64_we, crc_8, crc_8_darc, crc_8_i_code, crc_8_itu, crc_8_maxim, crc_8_rohc, crc_8_wcdma, crc_aug_ccitt, crc_ccitt_false, identity, identity_extend, identity_lsb, identity_msb, jamcrc, kermit, modbus, posix, random, x_25, xfer, xmodem */

field_list_calculation flow_hash_key {
    input {
        flow_keys;
    }
    algorithm : crc32;
    output_width : 16; //32;
}

field_list_calculation flow_hash_index {
    input {
        flow_keys;
    }
    algorithm : crc_16_dect;
    output_width : 16;
}

action a_calc_hash() {
    // dest, base, flc, size. (base + (hash_value % size))
    //modify_field_with_hash_based_offset(rstate.hash_key, 0, flow_hash_key, 2147483648);
    modify_field_with_hash_based_offset(rstate.hash_key, 0, flow_hash_key, 65536);
    //modify_field_with_hash_based_offset(rstate.hash_key, 0, flow_hash_key, 65536);
    modify_field_with_hash_based_offset(rstate.hash_index, 0, flow_hash_index, 65536);
}

table t_calc_hash {
    actions {
        a_calc_hash;
    }
    default_action : a_calc_hash;
}

// flow key
register r_flow_hash_key {
    //width : 32;
    width : 16;
    instance_count : 65536;
}

//blackbox stateful_alu reg_dt_index_db_alu2 {
//        reg : dt_index_db2;
//
//        condition_lo : register_lo == 0;
//        update_lo_1_predicate : condition_lo;
//        update_lo_1_value : dt_md.dt_digest;
//
//        condition_hi : dt_md.dt_digest == register_lo;
//        update_hi_1_predicate : not condition_lo and condition_hi;
//        update_hi_1_value : 0;
//        update_hi_2_predicate : condition_lo or not condition_hi;
//        update_hi_2_value : 1;
//
//        output_value : alu_hi;
//        output_dst : dt_md.is_distinct;
//}

blackbox stateful_alu fkey_alu {
    reg : r_flow_hash_key;
    
    condition_lo : rstate.hash_key != register_lo;

    update_lo_1_value : rstate.hash_key;
  
    //output_value : register_lo;
    //output_value : condition_lo;
    output_value : combined_predicate;
	
    //output_dst : rstate.old_key;
    output_dst : rstate.is_collision;
}

action a_check_and_update_fkey() {
    fkey_alu.execute_stateful_alu(rstate.hash_index);
}

@pragma stage 1
table t_check_and_update_fkey {
    actions {
	a_check_and_update_fkey;
    }
    default_action : a_check_and_update_fkey;
}

action a_mark_collision() {
    modify_field(rstate.is_collision, 1);
}

table t_mark_collision {
    actions {
	a_mark_collision;
    }
    default_action : a_mark_collision;
}

// flow cnt

register r_flow_cnt {
    width : 32;
    instance_count : 65536;
}

blackbox stateful_alu fcnt_alu {
    reg : r_flow_cnt;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : 1;
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + 1;

    output_value : alu_lo;
    output_dst : rstate.flow_cnt;
}

action a_update_flow_counter() {
    fcnt_alu.execute_stateful_alu(rstate.hash_index);
}

@pragma stage 2
table t_update_flow_counter {
    actions {
	a_update_flow_counter;
    }
    default_action : a_update_flow_counter;
}

// m after s
header_type ms_result_t {
    fields {
        m1 : 8;
        m2 : 8;
        m3 : 8;
        m4 : 8;
    }
}

//metadata ms_result_t s1;
//metadata ms_result_t s2;
    
// s1
register r_s1_state1 {
    width : 8;
    instance_count : 65536;
}
register r_s1_state2 {
    width : 8;
    instance_count : 65536;
}
register r_s1_state3 {
    width : 8;
    instance_count : 65536;
}
register r_s1_state4 {
    width : 8;
    instance_count : 65536;
}

blackbox stateful_alu s1_state1_alu {
    reg : r_s1_state1;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m11.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m11.r1;

    output_value : alu_lo;
    //output_dst : s1.m1;
    //output_dst : m11.r2;
    output_dst : m11.r1;
}

action a_s1_state1() {
    s1_state1_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s1_state1 {
    actions {
	a_s1_state1;
    }
    default_action : a_s1_state1;
}

blackbox stateful_alu s1_state2_alu {
    reg : r_s1_state2;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m12.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m12.r1;

    output_value : alu_lo;
    //output_dst : s1.m2;
    //output_dst : m12.r2;
    output_dst : m12.r1;
}

action a_s1_state2() {
    s1_state2_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s1_state2 {
    actions {
	a_s1_state2;
    }
    default_action : a_s1_state2;
}

blackbox stateful_alu s1_state3_alu {
    reg : r_s1_state3;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m13.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m13.r1;

    output_value : alu_lo;
    //output_dst : s1.m3;
    //output_dst : m13.r2;
    output_dst : m13.r1;
}

action a_s1_state3() {
    s1_state3_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s1_state3 {
    actions {
	a_s1_state3;
    }
    default_action : a_s1_state3;
}

blackbox stateful_alu s1_state4_alu {
    reg : r_s1_state4;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m14.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m14.r1;

    output_value : alu_lo;
    //output_dst : s1.m4;
    //output_dst : m14.r2;
    output_dst : m14.r1;
}

action a_s1_state4() {
    s1_state4_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s1_state4 {
    actions {
	a_s1_state4;
    }
    default_action : a_s1_state4;
}

// s2
register r_s2_state1 {
    width : 8;
    instance_count : 65536;
}
register r_s2_state2 {
    width : 8;
    instance_count : 65536;
}
register r_s2_state3 {
    width : 8;
    instance_count : 65536;
}
register r_s2_state4 {
    width : 8;
    instance_count : 65536;
}

blackbox stateful_alu s2_state1_alu {
    reg : r_s2_state1;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m21.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m21.r1;

    output_value : alu_lo;
    //output_dst : s2.m1;
    output_dst : m21.r2;
}

action a_s2_state1() {
    s2_state1_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s2_state1 {
    actions {
	a_s2_state1;
    }
    default_action : a_s2_state1;
}

blackbox stateful_alu s2_state2_alu {
    reg : r_s2_state2;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m22.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m22.r1;

    output_value : alu_lo;
    //output_dst : s2.m2;
    output_dst : m22.r2;
}

action a_s2_state2() {
    s2_state2_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s2_state2 {
    actions {
	a_s2_state2;
    }
    default_action : a_s2_state2;
}

blackbox stateful_alu s2_state3_alu {
    reg : r_s2_state3;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m23.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m23.r1;

    output_value : alu_lo;
    //output_dst : s2.m3;
    output_dst : m23.r2;
}

action a_s2_state3() {
    s2_state3_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s2_state3 {
    actions {
	a_s2_state3;
    }
    default_action : a_s2_state3;
}

blackbox stateful_alu s2_state4_alu {
    reg : r_s2_state4;

    condition_lo : rstate.is_collision == 1;
    update_lo_1_predicate : condition_lo;
    update_lo_1_value : m24.r1; //0; // or other initial value
    update_lo_2_predicate : not condition_lo;
    update_lo_2_value : register_lo + m24.r1;

    output_value : alu_lo;
    //output_dst : s2.m4;
    output_dst : m24.r2;
}

action a_s2_state4() {
    s2_state4_alu.execute_stateful_alu(rstate.hash_index);
}

table t_s2_state4 {
    actions {
	a_s2_state4;
    }
    default_action : a_s2_state4;
}

control do_rnn_calc {
    apply(t_calc_hash);
    apply(t_check_and_update_fkey);
    if (rstate.hash_key != rstate.old_key){
	apply(t_mark_collision);
    } 
    apply(t_update_flow_counter);

    //state 
    apply(t_s1_state1);
    apply(t_s1_state2);
    apply(t_s1_state3);
    apply(t_s1_state4);

    apply(t_s2_state1);
    apply(t_s2_state2);
    apply(t_s2_state3);
    apply(t_s2_state4);
}

// used in main

action a_hit_thold() {
    modify_field(rstate.overflow, 2);
}
action a_less_than_thold() {
    modify_field(rstate.overflow, 1);
}
action a_larger_than_thold() {
    modify_field(rstate.overflow, 0);
}

@pragma stage 3
table t_check_cnt_thold {
    reads {
	rstate.flow_cnt : range;
    }
    actions {
	a_hit_thold;
	a_less_than_thold;
	a_larger_than_thold;
    }
}

control do_flow_cnt {
    apply(t_calc_hash);
    apply(t_check_and_update_fkey);
    //if (rstate.hash_key != rstate.old_key){
    //    apply(t_mark_collision);
    //} 
    apply(t_update_flow_counter);
    apply(t_check_cnt_thold);
}

control do_update_state {
    //state 
    apply(t_s1_state1);
    apply(t_s1_state2);
    apply(t_s1_state3);
    apply(t_s1_state4);

    apply(t_s2_state1);
    apply(t_s2_state2);
    apply(t_s2_state3);
    apply(t_s2_state4);
}


#endif
