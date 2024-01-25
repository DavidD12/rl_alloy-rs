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

enum CustomRobot_states {Free, Lock}
var one sig custom_robot_state in CustomRobot_states {}

fact custom_robot_initial_state {custom_robot_state = Free}

pred Check_custom_robot_goto_in_movement {custom_robot_state = Lock and custom_robot_goto_state = Running and ! TODO  and custom_robot_goto_state' = Idle and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and }
pred Check_custom_robot_goto_battery_not_critical {custom_robot_state = Lock and custom_robot_goto_state = Running and  TODO  and ! TODO  and motion' = Off and custom_robot_goto_state' = Idle and custom_robot_retoho_state' = custom_robot_retoho_state and custom_robot_recharge_state' = custom_robot_recharge_state and }
pred Check_custom_robot_retoho_in_movement {custom_robot_state = Lock and custom_robot_retoho_state = Running and ! TODO  and custom_robot_retoho_state' = Idle and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_recharge_state' = custom_robot_recharge_state and }
pred Check_custom_robot_recharge_not_in_movement {custom_robot_state = Lock and custom_robot_recharge_state = Running and ! TODO  and custom_robot_recharge_state' = Idle and custom_robot_goto_state' = custom_robot_goto_state and custom_robot_retoho_state' = custom_robot_retoho_state and }
