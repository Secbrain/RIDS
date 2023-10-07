#ifndef _MBLOCK_H_
#define _MBLOCK_H_

header_type mb_result1_t {
    fields {
        r1 : 8;
    }
}

header_type mb_result_t {
    fields {
        r1 : 8;
        r2 : 8;
        //r3 : 8;
        //r4 : 8;
        //r5 : 8;
        //r6 : 8;
        //r7 : 8;
        //r8 : 8;
    }
}

//metadata mb_result_t m11;
//metadata mb_result_t m12;
//metadata mb_result_t m13;
//metadata mb_result_t m14;
//metadata mb_result_t m1_2;
metadata mb_result1_t m11;
metadata mb_result1_t m12;
metadata mb_result1_t m13;
metadata mb_result1_t m14;

metadata mb_result_t m21;
metadata mb_result_t m22;
metadata mb_result_t m23;
metadata mb_result_t m24;
//metadata mb_result_t m2_2;

action a_mb_s1_11() {
    subtract(m11.r1, pktlen_onehot.p1, pktlen_onehot.p2);

    subtract(m12.r1, pktlen_onehot.p1, pktlen_onehot.p2);

    subtract(m13.r1, pktlen_onehot.p1, pktlen_onehot.p2);

    subtract(m14.r1, pktlen_onehot.p1, pktlen_onehot.p2);
}

table t_mb_s1_11 {
    actions {
        a_mb_s1_11;
    }
    default_action : a_mb_s1_11;
    size : 1;
}

action a_mb_s1_12() {
    add_to_field(m11.r1, pktlen_onehot.p3);
    add_to_field(m12.r1, pktlen_onehot.p3);
    add_to_field(m13.r1, pktlen_onehot.p3);
    subtract_from_field(m14.r1, pktlen_onehot.p3);
}

table t_mb_s1_12 {
    actions {
        a_mb_s1_12;
    }
    default_action : a_mb_s1_12;
    size : 1;
}
action a_mb_s1_13() {
    add_to_field(m11.r1, pktlen_onehot.p4);
    add_to_field(m12.r1, pktlen_onehot.p4);
    add_to_field(m13.r1, pktlen_onehot.p4);
    subtract_from_field(m14.r1, pktlen_onehot.p4);
}

table t_mb_s1_13 {
    actions {
        a_mb_s1_13;
    }
    default_action : a_mb_s1_13;
    size : 1;
}

action a_mb_s1_2() {
    //add(m21.r1, pktlen_onehot.p1, pktlen_onehot.p2);
    subtract(m21.r1, pktlen_onehot.p2, pktlen_onehot.p1);
    subtract(m21.r2, pktlen_onehot.p3, pktlen_onehot.p4);

    //add(m22.r1, pktlen_onehot.p1, pktlen_onehot.p2);
    subtract(m22.r1, 0, pktlen_onehot.p1);
    add(m22.r2, pktlen_onehot.p3, pktlen_onehot.p4);

    add(m23.r1, pktlen_onehot.p1, pktlen_onehot.p2);
    add(m23.r2, pktlen_onehot.p3, pktlen_onehot.p4);

    subtract(m24.r1, pktlen_onehot.p1, pktlen_onehot.p2);
    add(m24.r2, pktlen_onehot.p3, pktlen_onehot.p4);
}

table t_mb_s1_2 {
    actions {
        a_mb_s1_2;
    }
    default_action : a_mb_s1_2;
    size : 1;
}

action a_mb_s2_2() {
    add_to_field(m21.r1, m21.r2);
    subtract_from_field(m22.r1, m22.r2);
    add_to_field(m23.r1, m23.r2);
    add_to_field(m24.r1, m24.r2);
}

table t_mb_s2_2 {
    actions {
        a_mb_s2_2;
    }
    default_action : a_mb_s2_2;
    size : 1;
}

control do_calc_mat {
    apply(t_mb_s1_11);
    apply(t_mb_s1_12);
    apply(t_mb_s1_13);

    apply(t_mb_s1_2);
    apply(t_mb_s2_2);
}

#endif
