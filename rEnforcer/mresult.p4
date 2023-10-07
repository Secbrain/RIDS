#ifndef _MRES_H_
#define _MRES_H_

// calc s2_ori*fu + s2_new*(1-fu)

action a_set_m21() {
    modify_field(m21.r1, m21.r2);
}
table t_set_m21 {
    //reads {
    //    m11.r1 : range;
    //}
    actions {
	a_set_m21; nop;
    }
    default_action : nop;
}

action a_set_m22() {
    modify_field(m22.r1, m22.r2);
}
table t_set_m22 {
    //reads {
    //    m12.r1 : range;
    //}
    actions {
	a_set_m22; nop;
    }
    default_action : nop;
}

action a_set_m23() {
    modify_field(m23.r1, m23.r2);
}
table t_set_m23 {
    //reads {
    //    m13.r1 : range;
    //}
    actions {
	a_set_m23; nop;
    }
    default_action : nop;
}

action a_set_m24() {
    modify_field(m24.r1, m24.r2);
}
table t_set_m24 {
    //reads {
    //    m14.r1 : range;
    //}
    actions {
	a_set_m24; nop;
    }
    default_action : nop;
}


// final mat, 4x6, reuse m1x.r1 + m2x.r2

action a_fm_s1() {
    subtract_from_field(m11.r1, m12.r1);
    add_to_field(m13.r1, m14.r1);

    subtract(m21.r1, m24.r1, m21.r1);
}

table t_fm_s1 {
    actions {
        a_fm_s1;
    }
    default_action : a_fm_s1;
    size : 1;
}

action a_fm_s2() {
    subtract_from_field(m11.r1, m13.r1);
}

table t_fm_s2 {
    actions {
        a_fm_s2;
    }
    default_action : a_fm_s2;
    size : 1;
}

action a_fm_s3() {
    subtract_from_field(m11.r1, m21.r1);
    //add_to_field(m21.r1, 0x80);
}

table t_fm_s3 {
    actions {
        a_fm_s3;
    }
    default_action : a_fm_s3;
    size : 1;
}

//@pragma stage 6 // can only be put in front of table
control do_merge_result_1 {
    if (m11.r1 < 0x80){
        apply(t_set_m21);
    }
    if (m12.r1 < 0x80){
        apply(t_set_m22);
    }
    if (m13.r1 < 0x80){
        apply(t_set_m23);
    }
    if (m14.r1 < 0x80){
        apply(t_set_m24);
    }
    //apply(t_set_m21);
    //apply(t_set_m22);
    //apply(t_set_m23);
    //apply(t_set_m24);
}

control do_merge_result_2 {
    apply(t_fm_s1);
    apply(t_fm_s2);
    apply(t_fm_s3);
}





#endif
