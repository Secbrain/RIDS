#ifndef _CF_H_
#define _CF_H_

action a_activate_m11() {
    modify_field(m11.r1, 1);
}

action a_deactivate_m11() {
    modify_field(m11.r1, 0);
}

table t_activate_m11 {
    actions {
	a_activate_m11;
    }
    default_action : a_activate_m11;
}
table t_deactivate_m11 {
    actions {
	a_deactivate_m11;
    }
    default_action : a_deactivate_m11;
}

action a_activate_m12() {
    modify_field(m12.r1, 1);
}

action a_deactivate_m12() {
    modify_field(m12.r1, 0xf);
}

table t_activate_m12 {
    actions {
	a_activate_m12;
    }
    default_action : a_activate_m12;
}
table t_deactivate_m12 {
    actions {
	a_deactivate_m12;
    }
    default_action : a_deactivate_m12;
}

action a_activate_m13() {
    modify_field(m13.r1, 1);
}

action a_deactivate_m13() {
    modify_field(m13.r1, 0xf);
}

table t_activate_m13 {
    actions {
	a_activate_m13;
    }
    default_action : a_activate_m13;
}
table t_deactivate_m13 {
    actions {
	a_deactivate_m13;
    }
    default_action : a_deactivate_m13;
}

action a_activate_m14() {
    modify_field(m14.r1, 1);
}

action a_deactivate_m14() {
    modify_field(m14.r1, 0xf);
}

table t_activate_m14 {
    actions {
	a_activate_m14;
    }
    default_action : a_activate_m14;
}
table t_deactivate_m14 {
    actions {
	a_deactivate_m14;
    }
    default_action : a_deactivate_m14;
}

control do_cond_filter_1 {
    if (m11.r1 >= 0){
	apply(t_activate_m11);
    } else {
	apply(t_deactivate_m11);
    }  

    if (m12.r1 >= 0){
	apply(t_activate_m12);
    } else {
	apply(t_deactivate_m12);
    }  

    if (m13.r1 >= 0){
	apply(t_activate_m13);
    } else {
	apply(t_deactivate_m13);
    }  

    if (m14.r1 >= 0){
	apply(t_activate_m14);
    } else {
	apply(t_deactivate_m14);
    }  

}

action a_activate_m21() {
    modify_field(m21.r1, 1);
}

action a_deactivate_m21() {
    modify_field(m21.r1, 0xf);
}

table t_activate_m21 {
    actions {
	a_activate_m21;
    }
    default_action : a_activate_m21;
}
table t_deactivate_m21 {
    actions {
	a_deactivate_m21;
    }
    default_action : a_deactivate_m21;
}

action a_activate_m22() {
    modify_field(m22.r1, 1);
}

action a_deactivate_m22() {
    modify_field(m22.r1, 0xf);
}

table t_activate_m22 {
    actions {
	a_activate_m22;
    }
    default_action : a_activate_m22;
}
table t_deactivate_m22 {
    actions {
	a_deactivate_m22;
    }
    default_action : a_deactivate_m22;
}

action a_activate_m23() {
    modify_field(m23.r1, 1);
}

action a_deactivate_m23() {
    modify_field(m23.r1, 0xf);
}

table t_activate_m23 {
    actions {
	a_activate_m23;
    }
    default_action : a_activate_m23;
}
table t_deactivate_m23 {
    actions {
	a_deactivate_m23;
    }
    default_action : a_deactivate_m23;
}

action a_activate_m24() {
    modify_field(m24.r1, 1);
}

action a_deactivate_m24() {
    modify_field(m24.r1, 0xf);
}

table t_activate_m24 {
    actions {
	a_activate_m24;
    }
    default_action : a_activate_m24;
}
table t_deactivate_m24 {
    actions {
	a_deactivate_m24;
    }
    default_action : a_deactivate_m24;
}

control do_cond_filter_2 {
    if (m21.r1 >= 0){
	apply(t_activate_m21);
    } else {
	apply(t_deactivate_m21);
    }  

    if (m22.r1 >= 0){
	apply(t_activate_m22);
    } else {
	apply(t_deactivate_m22);
    }  

    if (m23.r1 >= 0){
	apply(t_activate_m23);
    } else {
	apply(t_deactivate_m23);
    }  

    if (m24.r1 >= 0){
	apply(t_activate_m24);
    } else {
	apply(t_deactivate_m24);
    }  

}

control do_cond_filter {
    do_cond_filter_1();
    do_cond_filter_2();
}
#endif

