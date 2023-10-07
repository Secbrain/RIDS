#ifndef _NN_H_
#define _NN_H_

// turn packet length to one-hot encoding
//header_type pktlen_t {
//    fields {
//	length : 16;
//    }
//}
//metadata pktlen_t pktlen;

header_type pktlen_onehot_t {
    fields {
	p1 : 2;
	p2 : 2;
	p3 : 2;
	p4 : 2;
	//p5 : 1;
	//p6 : 1;
	//p7 : 1;
	//p8 : 1;
    }
}
metadata pktlen_onehot_t pktlen_onehot;

action a_onehot_pktlen(p1, p2, p3, p4) {
    modify_field(pktlen_onehot.p1, p1);
    modify_field(pktlen_onehot.p2, p2);
    modify_field(pktlen_onehot.p3, p3);
    modify_field(pktlen_onehot.p4, p4);
}

table t_onehot_pktlen {
    reads {
	ipv4.total_len : range;
    }
    actions {
	a_onehot_pktlen;		
    }
}

control do_onehot_pktlen {
    //if (valid(tcp) or valid(udp)) {
	apply(t_onehot_pktlen);
    //}
}

// multiple with w1, w2, 4x4
#include "mblock.p4"

//control do_calc_mat {
//    apply(t_mb_s1);
//    apply(t_mb_s2);
//}

// conditional filter
#include "cfilter.p4"

// per flow states
#include "rstate.p4"

// merge result
#include "mresult.p4"

// find max
#include "fmax.p4"

// test table
table t_touch_tbl {
    reads {
	//pktlen_onehot.p1 : exact;
	//m11.r1 : exact;
	//rstate.hash_key : exact;
	//s1.m1 : exact;
	//m11.r2 :exact;
	m11.r1 :exact;
	m12.r1 :exact;
	m13.r1 :exact;
	m14.r1 :exact;
	m21.r1 :exact;
	m22.r1 :exact;
	m23.r1 :exact;
	m24.r1 :exact;
	//m21.r2 :exact;
    }
    actions {
	nop; _drop;
    }
}

control do_ids {
    do_onehot_pktlen();

    do_calc_mat();
    do_cond_filter();
    do_rnn_calc();
    //do_merge_result();


    apply(t_touch_tbl);
}

#endif
