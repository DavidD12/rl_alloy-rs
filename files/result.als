module skillset_verif

// ==================== Resouces ====================

enum CustomRobot_Battery {CustomRobot_Normal, CustomRobot_Low, CustomRobot_Critical}
var one sig custom_robot_battery in CustomRobot_Battery {}

fact CustomRobot_Battery_initial_state {custom_robot_battery = CustomRobot_Normal}

enum CustomRobot_Motion {CustomRobot_On, CustomRobot_Off}
var one sig custom_robot_motion in CustomRobot_Motion {}

fact CustomRobot_Motion_initial_state {custom_robot_motion = CustomRobot_On}

// ==================== Validates ====================

pred custom_robot_goto_validate {}

pred custom_robot_retoho_validate {}

pred custom_robot_recharge_validate {}

// ==================== Skillset ====================

enum CustomRobot_states {CustomRobot_free, CustomRobot_lock}
var one sig custom_robot_state in CustomRobot_states {}

fact custom_robot_initial_state {custom_robot_state = CustomRobot_free}

pred Check_custom_robot_goto_in_movement {custom_robot_state = CustomRobot_lock and custom_robot_goto_state = CustomRobot_running and !(custom_robot_motion = CustomRobot_On) and custom_robot_goto_state' = CustomRobot_idle and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}
pred Check_custom_robot_goto_battery_not_critical {custom_robot_state = CustomRobot_lock and custom_robot_goto_state = CustomRobot_running and (custom_robot_motion = CustomRobot_On) and !(custom_robot_battery != CustomRobot_Critical) and custom_robot_motion' = CustomRobot_Off and custom_robot_goto_state' = CustomRobot_idle and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery}
pred Check_custom_robot_retoho_in_movement {custom_robot_state = CustomRobot_lock and custom_robot_retoho_state = CustomRobot_running and !(custom_robot_motion = CustomRobot_On) and custom_robot_retoho_state' = CustomRobot_idle and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}
pred Check_custom_robot_recharge_not_in_movement {custom_robot_state = CustomRobot_lock and custom_robot_recharge_state = CustomRobot_running and !(custom_robot_motion = CustomRobot_Off) and custom_robot_recharge_state' = CustomRobot_idle and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_state' = custom_robot_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}
pred custom_robot_goto_inva_false_while_run {custom_robot_goto_state = CustomRobot_running and (!(custom_robot_motion = CustomRobot_On) or !(custom_robot_battery != CustomRobot_Critical))}
pred custom_robot_retoho_inva_false_while_run {custom_robot_retoho_state = CustomRobot_running and (!(custom_robot_motion = CustomRobot_On))}
pred custom_robot_recharge_inva_false_while_run {custom_robot_recharge_state = CustomRobot_running and (!(custom_robot_motion = CustomRobot_Off))}

fact custom_robot_inva_check_order {always(((custom_robot_state = CustomRobot_lock and custom_robot_goto_inva_false_while_run) implies (custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state)) and ((custom_robot_state = CustomRobot_lock and !custom_robot_goto_inva_false_while_run and custom_robot_retoho_inva_false_while_run) implies (custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state)) and ((custom_robot_state = CustomRobot_lock and !custom_robot_goto_inva_false_while_run and !custom_robot_retoho_inva_false_while_run and custom_robot_recharge_inva_false_while_run) implies (custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state)))}
pred custom_robot_lock_to_free {custom_robot_state = CustomRobot_lock and !custom_robot_goto_inva_false_while_run and !custom_robot_retoho_inva_false_while_run and !custom_robot_recharge_inva_false_while_run and custom_robot_state' = CustomRobot_free and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

// ==================== Events ====================
pred custom_robot_from_normal_to_low {custom_robot_state = CustomRobot_free and custom_robot_battery' = CustomRobot_Low and custom_robot_state' = CustomRobot_lock and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_motion' = custom_robot_motion}

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
(!(custom_robot_battery = CustomRobot_Normal) or !(custom_robot_motion = CustomRobot_Off) or !custom_robot_goto_validate) and 
custom_robot_goto_state' = CustomRobot_idle and custom_robot_state' = custom_robot_state and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and 
custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_goto_idle_to_runn {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_idle and 
(custom_robot_battery = CustomRobot_Normal) and (custom_robot_motion = CustomRobot_Off) and custom_robot_goto_validate and 
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

pred custom_robot_goto_inte_to_idle {custom_robot_state = CustomRobot_free and custom_robot_goto_state = CustomRobot_interr and 
custom_robot_motion' = CustomRobot_Off and custom_robot_battery' = CustomRobot_Low and custom_robot_goto_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state}

pred custom_robot_retoho_idle_to_idle {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_idle and 
(!(custom_robot_motion = CustomRobot_Off) or !custom_robot_retoho_validate) and 
custom_robot_retoho_state' = CustomRobot_idle and custom_robot_state' = custom_robot_state and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and 
custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_retoho_idle_to_runn {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_idle and 
(custom_robot_motion = CustomRobot_Off) and custom_robot_retoho_validate and 
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

pred custom_robot_retoho_inte_to_idle {custom_robot_state = CustomRobot_free and custom_robot_retoho_state = CustomRobot_interr and 
custom_robot_motion' = CustomRobot_Off and custom_robot_retoho_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and custom_robot_battery' = custom_robot_battery}

pred custom_robot_recharge_idle_to_idle {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_idle and 
(!(custom_robot_battery != CustomRobot_Normal) or !(custom_robot_motion = CustomRobot_Off) or !custom_robot_recharge_validate) and 
custom_robot_recharge_state' = CustomRobot_idle and custom_robot_state' = custom_robot_state and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and 
custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}

pred custom_robot_recharge_idle_to_runn {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_idle and 
(custom_robot_battery != CustomRobot_Normal) and (custom_robot_motion = CustomRobot_Off) and custom_robot_recharge_validate and 
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

pred custom_robot_recharge_inte_to_idle {custom_robot_state = CustomRobot_free and custom_robot_recharge_state = CustomRobot_interr and 
custom_robot_recharge_state' = CustomRobot_idle and custom_robot_state' = CustomRobot_lock and 
custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_battery' = custom_robot_battery and custom_robot_motion' = custom_robot_motion}


// ==================== Running constraint ====================

// ==================== Fairness hypotheses ====================
