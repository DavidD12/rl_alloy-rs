module skillset_verif

// ==================== Resouces ====================

enum CustomRobot_Battery {CustomRobot_Normal, CustomRobot_Low, CustomRobot_Critical}
var one sig custom_robot_battery in CustomRobot_Battery {}

fact CustomRobot_Battery_initial_state {custom_robot_battery = CustomRobot_Normal}

enum CustomRobot_Motion {CustomRobot_Off, CustomRobot_On}
var one sig custom_robot_motion in CustomRobot_Motion {}

fact CustomRobot_Motion_initial_state {custom_robot_motion = CustomRobot_Off}

// ==================== Skillset ====================

enum CustomRobot_states {CustomRobot_free, CustomRobot_lock}
var one sig custom_robot_state in CustomRobot_states {}

fact custom_robot_initial_state {custom_robot_state = CustomRobot_free}

pred Check_custom_robot_goto_in_movement {custom_robot_state = CustomRobot_lock and custom_robot_goto_state = CustomRobot_running and !((custom_robot_motion = CustomRobot_On)) and custom_robot_goto_state' = CustomRobot_idle and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}
pred Check_custom_robot_goto_battery_not_critical {custom_robot_state = CustomRobot_lock and custom_robot_goto_state = CustomRobot_running and ((custom_robot_motion = CustomRobot_On)) and !((custom_robot_battery != CustomRobot_Critical)) and custom_robot_motion' = CustomRobot_Off and custom_robot_goto_state' = CustomRobot_idle and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery}
pred Check_custom_robot_retoho_in_movement {custom_robot_state = CustomRobot_lock and custom_robot_retoho_state = CustomRobot_running and !((custom_robot_motion = CustomRobot_On)) and custom_robot_retoho_state' = CustomRobot_idle and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}
pred Check_custom_robot_recharge_not_in_movement {custom_robot_state = CustomRobot_lock and custom_robot_recharge_state = CustomRobot_running and !((custom_robot_motion = CustomRobot_Off)) and custom_robot_recharge_state' = CustomRobot_idle and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_goto_inva_false_while_run {custom_robot_goto_state = CustomRobot_running and (!((custom_robot_motion = CustomRobot_On)) or !((custom_robot_battery != CustomRobot_Critical)))}
pred custom_robot_retoho_inva_false_while_run {custom_robot_retoho_state = CustomRobot_running and (!((custom_robot_motion = CustomRobot_On)))}
pred custom_robot_recharge_inva_false_while_run {custom_robot_recharge_state = CustomRobot_running and (!((custom_robot_motion = CustomRobot_Off)))}

fact custom_robot_inva_check_order {always(((custom_robot_state = CustomRobot_lock and custom_robot_goto_inva_false_while_run) implies (custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state)) and ((custom_robot_state = CustomRobot_lock and !custom_robot_goto_inva_false_while_run and custom_robot_retoho_inva_false_while_run) implies (custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state)) and ((custom_robot_state = CustomRobot_lock and !custom_robot_goto_inva_false_while_run and !custom_robot_retoho_inva_false_while_run and custom_robot_recharge_inva_false_while_run) implies (custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state)))}

pred custom_robot_lock_to_free {custom_robot_state = CustomRobot_lock and !custom_robot_goto_inva_false_while_run and !custom_robot_retoho_inva_false_while_run and !custom_robot_recharge_inva_false_while_run and custom_robot_state' = CustomRobot_free and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

// ==================== Events ====================

pred custom_robot_from_normal_to_low {custom_robot_state = CustomRobot_free and (custom_robot_battery = CustomRobot_Normal) and custom_robot_battery' = CustomRobot_Low and custom_robot_state' = CustomRobot_lock and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_motion' = custom_robot_motion}

// ==================== Skills ====================

enum CustomRobot_skill_states {CustomRobot_idle, CustomRobot_running, CustomRobot_inter}

var one sig custom_robot_goto_state in CustomRobot_skill_states {}
var one sig custom_robot_retoho_state in CustomRobot_skill_states {}
var one sig custom_robot_recharge_state in CustomRobot_skill_states {}

fact custom_robot_skill_initial_state {custom_robot_goto_state = CustomRobot_idle and custom_robot_retoho_state = CustomRobot_idle and custom_robot_recharge_state = CustomRobot_idle}

pred custom_robot_goto_validate {}

pred custom_robot_retoho_validate {}

pred custom_robot_recharge_validate {}

pred custom_robot_goto_idle_to_idle {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_idle and 
(!((custom_robot_battery = CustomRobot_Normal)) or !((custom_robot_motion = CustomRobot_Off)) or !custom_robot_goto_validate) and 
custom_robot_goto_state' = CustomRobot_idle and custom_robot_state' = custom_robot_state and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and 
custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_goto_idle_to_runn {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_idle and 
((custom_robot_battery = CustomRobot_Normal)) and ((custom_robot_motion = CustomRobot_Off)) and custom_robot_goto_validate and 
custom_robot_motion' = CustomRobot_On and custom_robot_goto_state' = CustomRobot_running and custom_robot_state' = CustomRobot_lock and 
custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery}

pred custom_robot_goto_runn_to_inte {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_running and 
custom_robot_goto_state' = CustomRobot_inter and custom_robot_state' = custom_robot_state and 
custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_goto_runn_to_success_arrived {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_running and 
custom_robot_motion' = CustomRobot_Off and custom_robot_battery' = CustomRobot_Low and custom_robot_goto_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state}

pred custom_robot_goto_runn_to_success_arrived_2 {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_running and 
custom_robot_motion' = CustomRobot_Off and custom_robot_battery' = CustomRobot_Critical and custom_robot_goto_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state}

pred custom_robot_goto_runn_to_failure_blocked {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_running and 
custom_robot_motion' = CustomRobot_Off and custom_robot_battery' = CustomRobot_Low and custom_robot_goto_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state}

pred custom_robot_goto_inte_to_idle {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_inter and 
custom_robot_motion' = CustomRobot_Off and custom_robot_battery' = CustomRobot_Low and custom_robot_goto_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state}

pred custom_robot_retoho_idle_to_idle {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_idle and 
(!((custom_robot_motion = CustomRobot_Off)) or !custom_robot_retoho_validate) and 
custom_robot_retoho_state' = CustomRobot_idle and custom_robot_state' = custom_robot_state and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and 
custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_retoho_idle_to_runn {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_idle and 
((custom_robot_motion = CustomRobot_Off)) and custom_robot_retoho_validate and 
custom_robot_motion' = CustomRobot_On and custom_robot_retoho_state' = CustomRobot_running and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery}

pred custom_robot_retoho_runn_to_inte {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_running and 
custom_robot_retoho_state' = CustomRobot_inter and custom_robot_state' = custom_robot_state and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_retoho_runn_to_success_arrived {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_running and 
custom_robot_motion' = CustomRobot_Off and custom_robot_retoho_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery}

pred custom_robot_retoho_runn_to_failure_blocked {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_running and 
custom_robot_motion' = CustomRobot_Off and custom_robot_retoho_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery}

pred custom_robot_retoho_inte_to_idle {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_inter and 
custom_robot_motion' = CustomRobot_Off and custom_robot_retoho_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery}

pred custom_robot_recharge_idle_to_idle {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_idle and 
(!((custom_robot_battery != CustomRobot_Normal)) or !((custom_robot_motion = CustomRobot_Off)) or !custom_robot_recharge_validate) and 
custom_robot_recharge_state' = CustomRobot_idle and custom_robot_state' = custom_robot_state and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and 
custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_recharge_idle_to_runn {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_idle and 
((custom_robot_battery != CustomRobot_Normal)) and ((custom_robot_motion = CustomRobot_Off)) and custom_robot_recharge_validate and 
custom_robot_recharge_state' = CustomRobot_running and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_recharge_runn_to_inte {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_running and 
custom_robot_recharge_state' = CustomRobot_inter and custom_robot_state' = custom_robot_state and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_recharge_runn_to_success_charged {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_running and 
custom_robot_battery' = CustomRobot_Normal and custom_robot_recharge_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_motion' = custom_robot_motion}

pred custom_robot_recharge_runn_to_failure_emergency {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_running and 
custom_robot_recharge_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_recharge_inte_to_idle {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_inter and 
custom_robot_recharge_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}


// ==================== Running constraint ====================

enum custom_robot_conc_event {
	custom_robot_lock_to_free_event,
	Check_custom_robot_goto_in_movement_event,
	Check_custom_robot_goto_battery_not_critical_event,
	Check_custom_robot_retoho_in_movement_event,
	Check_custom_robot_recharge_not_in_movement_event,
	custom_robot_from_normal_to_low_event,
	custom_robot_goto_idle_to_idle_event,
	custom_robot_goto_idle_to_runn_event,
	custom_robot_goto_runn_to_inte_event,
	custom_robot_goto_inte_to_idle_event,
	custom_robot_goto_runn_to_success_arrived_event,
	custom_robot_goto_runn_to_success_arrived_2_event,
	custom_robot_goto_runn_to_failure_blocked_event,
	custom_robot_retoho_idle_to_idle_event,
	custom_robot_retoho_idle_to_runn_event,
	custom_robot_retoho_runn_to_inte_event,
	custom_robot_retoho_inte_to_idle_event,
	custom_robot_retoho_runn_to_success_arrived_event,
	custom_robot_retoho_runn_to_failure_blocked_event,
	custom_robot_recharge_idle_to_idle_event,
	custom_robot_recharge_idle_to_runn_event,
	custom_robot_recharge_runn_to_inte_event,
	custom_robot_recharge_inte_to_idle_event,
	custom_robot_recharge_runn_to_success_charged_event,
	custom_robot_recharge_runn_to_failure_emergency_event
}

fun is_event_custom_robot_lock_to_free : set custom_robot_conc_event {
	custom_robot_lock_to_free implies {custom_robot_lock_to_free_event} else none
}
fun is_event_Check_custom_robot_goto_in_movement : set custom_robot_conc_event {
	Check_custom_robot_goto_in_movement implies {Check_custom_robot_goto_in_movement_event} else none
}
fun is_event_Check_custom_robot_goto_battery_not_critical : set custom_robot_conc_event {
	Check_custom_robot_goto_battery_not_critical implies {Check_custom_robot_goto_battery_not_critical_event} else none
}
fun is_event_Check_custom_robot_retoho_in_movement : set custom_robot_conc_event {
	Check_custom_robot_retoho_in_movement implies {Check_custom_robot_retoho_in_movement_event} else none
}
fun is_event_Check_custom_robot_recharge_not_in_movement : set custom_robot_conc_event {
	Check_custom_robot_recharge_not_in_movement implies {Check_custom_robot_recharge_not_in_movement_event} else none
}
fun is_event_custom_robot_from_normal_to_low : set custom_robot_conc_event {
	custom_robot_from_normal_to_low implies {custom_robot_from_normal_to_low_event} else none
}
fun is_event_custom_robot_goto_idle_to_idle : set custom_robot_conc_event {
	custom_robot_goto_idle_to_idle implies {custom_robot_goto_idle_to_idle_event} else none
}
fun is_event_custom_robot_goto_idle_to_runn : set custom_robot_conc_event {
	custom_robot_goto_idle_to_runn implies {custom_robot_goto_idle_to_runn_event} else none
}
fun is_event_custom_robot_goto_runn_to_inte : set custom_robot_conc_event {
	custom_robot_goto_runn_to_inte implies {custom_robot_goto_runn_to_inte_event} else none
}
fun is_event_custom_robot_goto_inte_to_idle : set custom_robot_conc_event {
	custom_robot_goto_inte_to_idle implies {custom_robot_goto_inte_to_idle_event} else none
}
fun is_event_custom_robot_goto_runn_to_success_arrived : set custom_robot_conc_event {
	custom_robot_goto_runn_to_success_arrived implies {custom_robot_goto_runn_to_success_arrived_event} else none
}
fun is_event_custom_robot_goto_runn_to_success_arrived_2 : set custom_robot_conc_event {
	custom_robot_goto_runn_to_success_arrived_2 implies {custom_robot_goto_runn_to_success_arrived_2_event} else none
}
fun is_event_custom_robot_goto_runn_to_failure_blocked : set custom_robot_conc_event {
	custom_robot_goto_runn_to_failure_blocked implies {custom_robot_goto_runn_to_failure_blocked_event} else none
}
fun is_event_custom_robot_retoho_idle_to_idle : set custom_robot_conc_event {
	custom_robot_retoho_idle_to_idle implies {custom_robot_retoho_idle_to_idle_event} else none
}
fun is_event_custom_robot_retoho_idle_to_runn : set custom_robot_conc_event {
	custom_robot_retoho_idle_to_runn implies {custom_robot_retoho_idle_to_runn_event} else none
}
fun is_event_custom_robot_retoho_runn_to_inte : set custom_robot_conc_event {
	custom_robot_retoho_runn_to_inte implies {custom_robot_retoho_runn_to_inte_event} else none
}
fun is_event_custom_robot_retoho_inte_to_idle : set custom_robot_conc_event {
	custom_robot_retoho_inte_to_idle implies {custom_robot_retoho_inte_to_idle_event} else none
}
fun is_event_custom_robot_retoho_runn_to_success_arrived : set custom_robot_conc_event {
	custom_robot_retoho_runn_to_success_arrived implies {custom_robot_retoho_runn_to_success_arrived_event} else none
}
fun is_event_custom_robot_retoho_runn_to_failure_blocked : set custom_robot_conc_event {
	custom_robot_retoho_runn_to_failure_blocked implies {custom_robot_retoho_runn_to_failure_blocked_event} else none
}
fun is_event_custom_robot_recharge_idle_to_idle : set custom_robot_conc_event {
	custom_robot_recharge_idle_to_idle implies {custom_robot_recharge_idle_to_idle_event} else none
}
fun is_event_custom_robot_recharge_idle_to_runn : set custom_robot_conc_event {
	custom_robot_recharge_idle_to_runn implies {custom_robot_recharge_idle_to_runn_event} else none
}
fun is_event_custom_robot_recharge_runn_to_inte : set custom_robot_conc_event {
	custom_robot_recharge_runn_to_inte implies {custom_robot_recharge_runn_to_inte_event} else none
}
fun is_event_custom_robot_recharge_inte_to_idle : set custom_robot_conc_event {
	custom_robot_recharge_inte_to_idle implies {custom_robot_recharge_inte_to_idle_event} else none
}
fun is_event_custom_robot_recharge_runn_to_success_charged : set custom_robot_conc_event {
	custom_robot_recharge_runn_to_success_charged implies {custom_robot_recharge_runn_to_success_charged_event} else none
}
fun is_event_custom_robot_recharge_runn_to_failure_emergency : set custom_robot_conc_event {
	custom_robot_recharge_runn_to_failure_emergency implies {custom_robot_recharge_runn_to_failure_emergency_event} else none
}

fun custom_robot_event_union : set custom_robot_conc_event {
	is_event_custom_robot_lock_to_free +
	is_event_Check_custom_robot_goto_in_movement +
	is_event_Check_custom_robot_goto_battery_not_critical +
	is_event_Check_custom_robot_retoho_in_movement +
	is_event_Check_custom_robot_recharge_not_in_movement +
	is_event_custom_robot_from_normal_to_low +
	is_event_custom_robot_goto_idle_to_idle +
	is_event_custom_robot_goto_idle_to_runn +
	is_event_custom_robot_goto_runn_to_inte +
	is_event_custom_robot_goto_inte_to_idle +
	is_event_custom_robot_goto_runn_to_success_arrived +
	is_event_custom_robot_goto_runn_to_success_arrived_2 +
	is_event_custom_robot_goto_runn_to_failure_blocked +
	is_event_custom_robot_retoho_idle_to_idle +
	is_event_custom_robot_retoho_idle_to_runn +
	is_event_custom_robot_retoho_runn_to_inte +
	is_event_custom_robot_retoho_inte_to_idle +
	is_event_custom_robot_retoho_runn_to_success_arrived +
	is_event_custom_robot_retoho_runn_to_failure_blocked +
	is_event_custom_robot_recharge_idle_to_idle +
	is_event_custom_robot_recharge_idle_to_runn +
	is_event_custom_robot_recharge_runn_to_inte +
	is_event_custom_robot_recharge_inte_to_idle +
	is_event_custom_robot_recharge_runn_to_success_charged +
	is_event_custom_robot_recharge_runn_to_failure_emergency
}


fact custom_robot_always_some_event { always some custom_robot_event_union }

// ==================== Fairness hypotheses ====================

pred custom_robot_goto_running_fairness { always ( custom_robot_goto_state = CustomRobot_running implies eventually custom_robot_goto_state != CustomRobot_running ) }
pred custom_robot_retoho_running_fairness { always ( custom_robot_retoho_state = CustomRobot_running implies eventually custom_robot_retoho_state != CustomRobot_running ) }
pred custom_robot_recharge_running_fairness { always ( custom_robot_recharge_state = CustomRobot_running implies eventually custom_robot_recharge_state != CustomRobot_running ) }

fact custom_robot_running_fairness { always (
	custom_robot_goto_running_fairness and 
	custom_robot_retoho_running_fairness and 
	custom_robot_recharge_running_fairness 
)}

pred custom_robot_goto_interruption_fairness { always ( custom_robot_goto_state = CustomRobot_inter implies eventually custom_robot_goto_state != CustomRobot_inter ) }
pred custom_robot_retoho_interruption_fairness { always ( custom_robot_retoho_state = CustomRobot_inter implies eventually custom_robot_retoho_state != CustomRobot_inter ) }
pred custom_robot_recharge_interruption_fairness { always ( custom_robot_recharge_state = CustomRobot_inter implies eventually custom_robot_recharge_state != CustomRobot_inter ) }

fact custom_robot_interruption_fairness { always (
	custom_robot_goto_interruption_fairness and 
	custom_robot_retoho_interruption_fairness and 
	custom_robot_recharge_interruption_fairness 
)}

// ==================== Resouces ====================

enum MyNewRobot_Battery {MyNewRobot_Normal, MyNewRobot_Low, MyNewRobot_Critical}
var one sig my_new_robot_battery in MyNewRobot_Battery {}

fact MyNewRobot_Battery_initial_state {my_new_robot_battery = MyNewRobot_Normal}

enum MyNewRobot_Motion {MyNewRobot_Off, MyNewRobot_On}
var one sig my_new_robot_motion in MyNewRobot_Motion {}

fact MyNewRobot_Motion_initial_state {my_new_robot_motion = MyNewRobot_Off}

// ==================== Skillset ====================

enum MyNewRobot_states {MyNewRobot_free, MyNewRobot_lock}
var one sig my_new_robot_state in MyNewRobot_states {}

fact my_new_robot_initial_state {my_new_robot_state = MyNewRobot_free}

pred Check_my_new_robot_goto_in_movement {my_new_robot_state = MyNewRobot_lock and my_new_robot_goto_state = MyNewRobot_running and !((my_new_robot_motion = MyNewRobot_On)) and my_new_robot_goto_state' = MyNewRobot_idle and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_state' = my_new_robot_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}
pred Check_my_new_robot_goto_battery_not_critical {my_new_robot_state = MyNewRobot_lock and my_new_robot_goto_state = MyNewRobot_running and ((my_new_robot_motion = MyNewRobot_On)) and !((my_new_robot_battery != MyNewRobot_Critical)) and my_new_robot_motion' = MyNewRobot_Off and my_new_robot_goto_state' = MyNewRobot_idle and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_state' = my_new_robot_state and my_new_robot_battery' = my_new_robot_battery}
pred Check_my_new_robot_retoho_in_movement {my_new_robot_state = MyNewRobot_lock and my_new_robot_retoho_state = MyNewRobot_running and !((my_new_robot_motion = MyNewRobot_On)) and my_new_robot_retoho_state' = MyNewRobot_idle and my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_state' = my_new_robot_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}
pred Check_my_new_robot_recharge_not_in_movement {my_new_robot_state = MyNewRobot_lock and my_new_robot_recharge_state = MyNewRobot_running and !((my_new_robot_motion = MyNewRobot_Off)) and my_new_robot_recharge_state' = MyNewRobot_idle and my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_state' = my_new_robot_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_goto_inva_false_while_run {my_new_robot_goto_state = MyNewRobot_running and (!((my_new_robot_motion = MyNewRobot_On)) or !((my_new_robot_battery != MyNewRobot_Critical)))}
pred my_new_robot_retoho_inva_false_while_run {my_new_robot_retoho_state = MyNewRobot_running and (!((my_new_robot_motion = MyNewRobot_On)))}
pred my_new_robot_recharge_inva_false_while_run {my_new_robot_recharge_state = MyNewRobot_running and (!((my_new_robot_motion = MyNewRobot_Off)))}

fact my_new_robot_inva_check_order {always(((my_new_robot_state = MyNewRobot_lock and my_new_robot_goto_inva_false_while_run) implies (my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state)) and ((my_new_robot_state = MyNewRobot_lock and !my_new_robot_goto_inva_false_while_run and my_new_robot_retoho_inva_false_while_run) implies (my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_recharge_state' = my_new_robot_recharge_state)) and ((my_new_robot_state = MyNewRobot_lock and !my_new_robot_goto_inva_false_while_run and !my_new_robot_retoho_inva_false_while_run and my_new_robot_recharge_inva_false_while_run) implies (my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state)))}

pred my_new_robot_lock_to_free {my_new_robot_state = MyNewRobot_lock and !my_new_robot_goto_inva_false_while_run and !my_new_robot_retoho_inva_false_while_run and !my_new_robot_recharge_inva_false_while_run and my_new_robot_state' = MyNewRobot_free and my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

// ==================== Events ====================

pred my_new_robot_from_normal_to_low {my_new_robot_state = MyNewRobot_free and (my_new_robot_battery = MyNewRobot_Normal) and my_new_robot_battery' = MyNewRobot_Low and my_new_robot_state' = MyNewRobot_lock and my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_motion' = my_new_robot_motion}

// ==================== Skills ====================

enum MyNewRobot_skill_states {MyNewRobot_idle, MyNewRobot_running, MyNewRobot_inter}

var one sig my_new_robot_goto_state in MyNewRobot_skill_states {}
var one sig my_new_robot_retoho_state in MyNewRobot_skill_states {}
var one sig my_new_robot_recharge_state in MyNewRobot_skill_states {}

fact my_new_robot_skill_initial_state {my_new_robot_goto_state = MyNewRobot_idle and my_new_robot_retoho_state = MyNewRobot_idle and my_new_robot_recharge_state = MyNewRobot_idle}

pred my_new_robot_goto_validate {}

pred my_new_robot_retoho_validate {}

pred my_new_robot_recharge_validate {}

pred my_new_robot_goto_idle_to_idle {my_new_robot_state = MyNewRobot_free and my_new_robot_goto_state = MyNewRobot_idle and 
(!((my_new_robot_battery = MyNewRobot_Normal)) or !((my_new_robot_motion = MyNewRobot_Off)) or !my_new_robot_goto_validate) and 
my_new_robot_goto_state' = MyNewRobot_idle and my_new_robot_state' = my_new_robot_state and my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and 
my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_goto_idle_to_runn {my_new_robot_state = MyNewRobot_free and my_new_robot_goto_state = MyNewRobot_idle and 
((my_new_robot_battery = MyNewRobot_Normal)) and ((my_new_robot_motion = MyNewRobot_Off)) and my_new_robot_goto_validate and 
my_new_robot_motion' = MyNewRobot_On and my_new_robot_goto_state' = MyNewRobot_running and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery}

pred my_new_robot_goto_runn_to_inte {my_new_robot_state = MyNewRobot_free and my_new_robot_goto_state = MyNewRobot_running and 
my_new_robot_goto_state' = MyNewRobot_inter and my_new_robot_state' = my_new_robot_state and 
my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_goto_runn_to_success_arrived {my_new_robot_state = MyNewRobot_free and my_new_robot_goto_state = MyNewRobot_running and 
my_new_robot_motion' = MyNewRobot_Off and my_new_robot_battery' = MyNewRobot_Low and my_new_robot_goto_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state}

pred my_new_robot_goto_runn_to_success_arrived_2 {my_new_robot_state = MyNewRobot_free and my_new_robot_goto_state = MyNewRobot_running and 
my_new_robot_motion' = MyNewRobot_Off and my_new_robot_battery' = MyNewRobot_Critical and my_new_robot_goto_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state}

pred my_new_robot_goto_runn_to_failure_blocked {my_new_robot_state = MyNewRobot_free and my_new_robot_goto_state = MyNewRobot_running and 
my_new_robot_motion' = MyNewRobot_Off and my_new_robot_battery' = MyNewRobot_Low and my_new_robot_goto_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state}

pred my_new_robot_goto_inte_to_idle {my_new_robot_state = MyNewRobot_free and my_new_robot_goto_state = MyNewRobot_inter and 
my_new_robot_motion' = MyNewRobot_Off and my_new_robot_battery' = MyNewRobot_Low and my_new_robot_goto_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state}

pred my_new_robot_retoho_idle_to_idle {my_new_robot_state = MyNewRobot_free and my_new_robot_retoho_state = MyNewRobot_idle and 
(!((my_new_robot_motion = MyNewRobot_Off)) or !my_new_robot_retoho_validate) and 
my_new_robot_retoho_state' = MyNewRobot_idle and my_new_robot_state' = my_new_robot_state and my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and 
my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_retoho_idle_to_runn {my_new_robot_state = MyNewRobot_free and my_new_robot_retoho_state = MyNewRobot_idle and 
((my_new_robot_motion = MyNewRobot_Off)) and my_new_robot_retoho_validate and 
my_new_robot_motion' = MyNewRobot_On and my_new_robot_retoho_state' = MyNewRobot_running and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery}

pred my_new_robot_retoho_runn_to_inte {my_new_robot_state = MyNewRobot_free and my_new_robot_retoho_state = MyNewRobot_running and 
my_new_robot_retoho_state' = MyNewRobot_inter and my_new_robot_state' = my_new_robot_state and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_retoho_runn_to_success_arrived {my_new_robot_state = MyNewRobot_free and my_new_robot_retoho_state = MyNewRobot_running and 
my_new_robot_motion' = MyNewRobot_Off and my_new_robot_retoho_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery}

pred my_new_robot_retoho_runn_to_failure_blocked {my_new_robot_state = MyNewRobot_free and my_new_robot_retoho_state = MyNewRobot_running and 
my_new_robot_motion' = MyNewRobot_Off and my_new_robot_retoho_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery}

pred my_new_robot_retoho_inte_to_idle {my_new_robot_state = MyNewRobot_free and my_new_robot_retoho_state = MyNewRobot_inter and 
my_new_robot_motion' = MyNewRobot_Off and my_new_robot_retoho_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and my_new_robot_battery' = my_new_robot_battery}

pred my_new_robot_recharge_idle_to_idle {my_new_robot_state = MyNewRobot_free and my_new_robot_recharge_state = MyNewRobot_idle and 
(!((my_new_robot_battery != MyNewRobot_Normal)) or !((my_new_robot_motion = MyNewRobot_Off)) or !my_new_robot_recharge_validate) and 
my_new_robot_recharge_state' = MyNewRobot_idle and my_new_robot_state' = my_new_robot_state and my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_recharge_state' = my_new_robot_recharge_state and 
my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_recharge_idle_to_runn {my_new_robot_state = MyNewRobot_free and my_new_robot_recharge_state = MyNewRobot_idle and 
((my_new_robot_battery != MyNewRobot_Normal)) and ((my_new_robot_motion = MyNewRobot_Off)) and my_new_robot_recharge_validate and 
my_new_robot_recharge_state' = MyNewRobot_running and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_recharge_runn_to_inte {my_new_robot_state = MyNewRobot_free and my_new_robot_recharge_state = MyNewRobot_running and 
my_new_robot_recharge_state' = MyNewRobot_inter and my_new_robot_state' = my_new_robot_state and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_recharge_runn_to_success_charged {my_new_robot_state = MyNewRobot_free and my_new_robot_recharge_state = MyNewRobot_running and 
my_new_robot_battery' = MyNewRobot_Normal and my_new_robot_recharge_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_recharge_runn_to_failure_emergency {my_new_robot_state = MyNewRobot_free and my_new_robot_recharge_state = MyNewRobot_running and 
my_new_robot_recharge_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}

pred my_new_robot_recharge_inte_to_idle {my_new_robot_state = MyNewRobot_free and my_new_robot_recharge_state = MyNewRobot_inter and 
my_new_robot_recharge_state' = MyNewRobot_idle and my_new_robot_state' = MyNewRobot_lock and 
my_new_robot_goto_state' = my_new_robot_goto_state and my_new_robot_retoho_state' = my_new_robot_retoho_state and my_new_robot_battery' = my_new_robot_battery and my_new_robot_motion' = my_new_robot_motion}


// ==================== Running constraint ====================

enum my_new_robot_conc_event {
	my_new_robot_lock_to_free_event,
	Check_my_new_robot_goto_in_movement_event,
	Check_my_new_robot_goto_battery_not_critical_event,
	Check_my_new_robot_retoho_in_movement_event,
	Check_my_new_robot_recharge_not_in_movement_event,
	my_new_robot_from_normal_to_low_event,
	my_new_robot_goto_idle_to_idle_event,
	my_new_robot_goto_idle_to_runn_event,
	my_new_robot_goto_runn_to_inte_event,
	my_new_robot_goto_inte_to_idle_event,
	my_new_robot_goto_runn_to_success_arrived_event,
	my_new_robot_goto_runn_to_success_arrived_2_event,
	my_new_robot_goto_runn_to_failure_blocked_event,
	my_new_robot_retoho_idle_to_idle_event,
	my_new_robot_retoho_idle_to_runn_event,
	my_new_robot_retoho_runn_to_inte_event,
	my_new_robot_retoho_inte_to_idle_event,
	my_new_robot_retoho_runn_to_success_arrived_event,
	my_new_robot_retoho_runn_to_failure_blocked_event,
	my_new_robot_recharge_idle_to_idle_event,
	my_new_robot_recharge_idle_to_runn_event,
	my_new_robot_recharge_runn_to_inte_event,
	my_new_robot_recharge_inte_to_idle_event,
	my_new_robot_recharge_runn_to_success_charged_event,
	my_new_robot_recharge_runn_to_failure_emergency_event
}

fun is_event_my_new_robot_lock_to_free : set my_new_robot_conc_event {
	my_new_robot_lock_to_free implies {my_new_robot_lock_to_free_event} else none
}
fun is_event_Check_my_new_robot_goto_in_movement : set my_new_robot_conc_event {
	Check_my_new_robot_goto_in_movement implies {Check_my_new_robot_goto_in_movement_event} else none
}
fun is_event_Check_my_new_robot_goto_battery_not_critical : set my_new_robot_conc_event {
	Check_my_new_robot_goto_battery_not_critical implies {Check_my_new_robot_goto_battery_not_critical_event} else none
}
fun is_event_Check_my_new_robot_retoho_in_movement : set my_new_robot_conc_event {
	Check_my_new_robot_retoho_in_movement implies {Check_my_new_robot_retoho_in_movement_event} else none
}
fun is_event_Check_my_new_robot_recharge_not_in_movement : set my_new_robot_conc_event {
	Check_my_new_robot_recharge_not_in_movement implies {Check_my_new_robot_recharge_not_in_movement_event} else none
}
fun is_event_my_new_robot_from_normal_to_low : set my_new_robot_conc_event {
	my_new_robot_from_normal_to_low implies {my_new_robot_from_normal_to_low_event} else none
}
fun is_event_my_new_robot_goto_idle_to_idle : set my_new_robot_conc_event {
	my_new_robot_goto_idle_to_idle implies {my_new_robot_goto_idle_to_idle_event} else none
}
fun is_event_my_new_robot_goto_idle_to_runn : set my_new_robot_conc_event {
	my_new_robot_goto_idle_to_runn implies {my_new_robot_goto_idle_to_runn_event} else none
}
fun is_event_my_new_robot_goto_runn_to_inte : set my_new_robot_conc_event {
	my_new_robot_goto_runn_to_inte implies {my_new_robot_goto_runn_to_inte_event} else none
}
fun is_event_my_new_robot_goto_inte_to_idle : set my_new_robot_conc_event {
	my_new_robot_goto_inte_to_idle implies {my_new_robot_goto_inte_to_idle_event} else none
}
fun is_event_my_new_robot_goto_runn_to_success_arrived : set my_new_robot_conc_event {
	my_new_robot_goto_runn_to_success_arrived implies {my_new_robot_goto_runn_to_success_arrived_event} else none
}
fun is_event_my_new_robot_goto_runn_to_success_arrived_2 : set my_new_robot_conc_event {
	my_new_robot_goto_runn_to_success_arrived_2 implies {my_new_robot_goto_runn_to_success_arrived_2_event} else none
}
fun is_event_my_new_robot_goto_runn_to_failure_blocked : set my_new_robot_conc_event {
	my_new_robot_goto_runn_to_failure_blocked implies {my_new_robot_goto_runn_to_failure_blocked_event} else none
}
fun is_event_my_new_robot_retoho_idle_to_idle : set my_new_robot_conc_event {
	my_new_robot_retoho_idle_to_idle implies {my_new_robot_retoho_idle_to_idle_event} else none
}
fun is_event_my_new_robot_retoho_idle_to_runn : set my_new_robot_conc_event {
	my_new_robot_retoho_idle_to_runn implies {my_new_robot_retoho_idle_to_runn_event} else none
}
fun is_event_my_new_robot_retoho_runn_to_inte : set my_new_robot_conc_event {
	my_new_robot_retoho_runn_to_inte implies {my_new_robot_retoho_runn_to_inte_event} else none
}
fun is_event_my_new_robot_retoho_inte_to_idle : set my_new_robot_conc_event {
	my_new_robot_retoho_inte_to_idle implies {my_new_robot_retoho_inte_to_idle_event} else none
}
fun is_event_my_new_robot_retoho_runn_to_success_arrived : set my_new_robot_conc_event {
	my_new_robot_retoho_runn_to_success_arrived implies {my_new_robot_retoho_runn_to_success_arrived_event} else none
}
fun is_event_my_new_robot_retoho_runn_to_failure_blocked : set my_new_robot_conc_event {
	my_new_robot_retoho_runn_to_failure_blocked implies {my_new_robot_retoho_runn_to_failure_blocked_event} else none
}
fun is_event_my_new_robot_recharge_idle_to_idle : set my_new_robot_conc_event {
	my_new_robot_recharge_idle_to_idle implies {my_new_robot_recharge_idle_to_idle_event} else none
}
fun is_event_my_new_robot_recharge_idle_to_runn : set my_new_robot_conc_event {
	my_new_robot_recharge_idle_to_runn implies {my_new_robot_recharge_idle_to_runn_event} else none
}
fun is_event_my_new_robot_recharge_runn_to_inte : set my_new_robot_conc_event {
	my_new_robot_recharge_runn_to_inte implies {my_new_robot_recharge_runn_to_inte_event} else none
}
fun is_event_my_new_robot_recharge_inte_to_idle : set my_new_robot_conc_event {
	my_new_robot_recharge_inte_to_idle implies {my_new_robot_recharge_inte_to_idle_event} else none
}
fun is_event_my_new_robot_recharge_runn_to_success_charged : set my_new_robot_conc_event {
	my_new_robot_recharge_runn_to_success_charged implies {my_new_robot_recharge_runn_to_success_charged_event} else none
}
fun is_event_my_new_robot_recharge_runn_to_failure_emergency : set my_new_robot_conc_event {
	my_new_robot_recharge_runn_to_failure_emergency implies {my_new_robot_recharge_runn_to_failure_emergency_event} else none
}

fun my_new_robot_event_union : set my_new_robot_conc_event {
	is_event_my_new_robot_lock_to_free +
	is_event_Check_my_new_robot_goto_in_movement +
	is_event_Check_my_new_robot_goto_battery_not_critical +
	is_event_Check_my_new_robot_retoho_in_movement +
	is_event_Check_my_new_robot_recharge_not_in_movement +
	is_event_my_new_robot_from_normal_to_low +
	is_event_my_new_robot_goto_idle_to_idle +
	is_event_my_new_robot_goto_idle_to_runn +
	is_event_my_new_robot_goto_runn_to_inte +
	is_event_my_new_robot_goto_inte_to_idle +
	is_event_my_new_robot_goto_runn_to_success_arrived +
	is_event_my_new_robot_goto_runn_to_success_arrived_2 +
	is_event_my_new_robot_goto_runn_to_failure_blocked +
	is_event_my_new_robot_retoho_idle_to_idle +
	is_event_my_new_robot_retoho_idle_to_runn +
	is_event_my_new_robot_retoho_runn_to_inte +
	is_event_my_new_robot_retoho_inte_to_idle +
	is_event_my_new_robot_retoho_runn_to_success_arrived +
	is_event_my_new_robot_retoho_runn_to_failure_blocked +
	is_event_my_new_robot_recharge_idle_to_idle +
	is_event_my_new_robot_recharge_idle_to_runn +
	is_event_my_new_robot_recharge_runn_to_inte +
	is_event_my_new_robot_recharge_inte_to_idle +
	is_event_my_new_robot_recharge_runn_to_success_charged +
	is_event_my_new_robot_recharge_runn_to_failure_emergency
}


fact my_new_robot_always_some_event { always some my_new_robot_event_union }

// ==================== Fairness hypotheses ====================

pred my_new_robot_goto_running_fairness { always ( my_new_robot_goto_state = MyNewRobot_running implies eventually my_new_robot_goto_state != MyNewRobot_running ) }
pred my_new_robot_retoho_running_fairness { always ( my_new_robot_retoho_state = MyNewRobot_running implies eventually my_new_robot_retoho_state != MyNewRobot_running ) }
pred my_new_robot_recharge_running_fairness { always ( my_new_robot_recharge_state = MyNewRobot_running implies eventually my_new_robot_recharge_state != MyNewRobot_running ) }

fact my_new_robot_running_fairness { always (
	my_new_robot_goto_running_fairness and 
	my_new_robot_retoho_running_fairness and 
	my_new_robot_recharge_running_fairness 
)}

pred my_new_robot_goto_interruption_fairness { always ( my_new_robot_goto_state = MyNewRobot_inter implies eventually my_new_robot_goto_state != MyNewRobot_inter ) }
pred my_new_robot_retoho_interruption_fairness { always ( my_new_robot_retoho_state = MyNewRobot_inter implies eventually my_new_robot_retoho_state != MyNewRobot_inter ) }
pred my_new_robot_recharge_interruption_fairness { always ( my_new_robot_recharge_state = MyNewRobot_inter implies eventually my_new_robot_recharge_state != MyNewRobot_inter ) }

fact my_new_robot_interruption_fairness { always (
	my_new_robot_goto_interruption_fairness and 
	my_new_robot_retoho_interruption_fairness and 
	my_new_robot_recharge_interruption_fairness 
)}
