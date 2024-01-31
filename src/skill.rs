use super::*;
use expression_converter::*;
use naming::*;

pub fn skills_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Skills ====================\n";

    // Enum
    out += &format!("\nenum {} {{", skill_enum(skillset));
    out += &format!(
        "{}, {}, {}}}\n\n",
        skill_state(skillset, "idle"),
        skill_state(skillset, "running"),
        skill_state(skillset, "inter")
    );

    // Var
    for skill in skillset.skills() {
        out += &format!(
            "var one sig {} in {} {{",
            skill_var(skillset, skill),
            skill_enum(skillset)
        );
        out += "}\n";
    }

    // Init
    out += &format!(
        "\nfact {}_skill_initial_state {{",
        skillset_fact_pred_name(skillset)
    );
    for skill in skillset.skills() {
        out += &format!(
            "{} = {} and ",
            skill_var(skillset, skill),
            skill_state(skillset, "idle")
        );
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "}\n\n";

    // Validate
    for skill in skillset.skills() {
        out += &format!(
            "pred {}_validate {{}}",
            skill_fact_pred_name(skillset, skill)
        );
        out += "\n\n";
    }

    // Idle to Idle
    for skill in skillset.skills() {
        out += &idle_to_idle_to_alloy(skillset, skill);
        out += &idle_to_runn_to_alloy(skillset, skill);
        out += &runn_to_inte_to_alloy(skillset, skill);
        out += &runn_to_succ_to_alloy(skillset, skill);
        out += &runn_to_fail_to_alloy(skillset, skill);
        out += &inte_to_idle_to_alloy(skillset, skill);
    }

    out
}

pub fn idle_to_idle_to_alloy(skillset: &Skillset, skill: &Skill) -> String {
    let mut out = "".to_string();

    out += &format!(
        "pred {}_idle_to_idle {{",
        skill_fact_pred_name(skillset, skill)
    );
    out += &format!(
        "{} = {} and {} = {} and \n",
        skillset_var(skillset),
        skillset_state(skillset, "free"),
        skill_var(skillset, skill),
        skill_state(skillset, "idle")
    );
    out += "(";
    for precondition in skill.preconditions() {
        out += &format!(
            "!({}) or ",
            get_alloy_formula(skillset, precondition.expr())
        );
    }
    out += &format!("!{}_validate", skill_fact_pred_name(skillset, skill));
    out += ") and \n";
    out += &format!(
        "{}' = {} and ",
        skill_var(skillset, skill),
        skill_state(skillset, "idle")
    );
    out += &format!(
        "{}' = {} and ",
        skillset_var(skillset),
        skillset_var(skillset)
    );
    for skill in skillset.skills() {
        out += &format!(
            "{}' = {} and ",
            skill_var(skillset, skill),
            skill_var(skillset, skill)
        );
    }
    out += "\n";
    for resource in skillset.resources() {
        out += &format!(
            "{}' = {} and ",
            resource_var(skillset, resource),
            resource_var(skillset, resource),
        );
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "}\n\n";

    out
}

pub fn idle_to_runn_to_alloy(skillset: &Skillset, skill: &Skill) -> String {
    let mut out = "".to_string();

    out += &format!(
        "pred {}_idle_to_runn {{",
        skill_fact_pred_name(skillset, skill)
    );
    out += &format!(
        "{} = {} and {} = {} and \n",
        skillset_var(skillset),
        skillset_state(skillset, "free"),
        skill_var(skillset, skill),
        skill_state(skillset, "idle")
    );
    for precondition in skill.preconditions() {
        out += &format!(
            "({}) and ",
            get_alloy_formula(skillset, precondition.expr())
        );
    }
    out += &format!("{}_validate and \n", skill_fact_pred_name(skillset, skill));
    let mut used_resources = Vec::new();
    for effect in skill.start() {
        let resource = skillset.get(effect.resource().resolved()).unwrap();
        let state = skillset.get(effect.state().resolved()).unwrap();
        out += &format!(
            "{}' = {} and ",
            resource_var(skillset, resource),
            resource_state(skillset, state)
        );
        used_resources.push(resource.name());
    }

    out += &format!(
        "{}' = {} and ",
        skill_var(skillset, skill),
        skill_state(skillset, "running")
    );
    out += &format!(
        "{}' = {} and \n",
        skillset_var(skillset),
        skillset_state(skillset, "lock")
    );
    for skill_2 in skillset.skills() {
        if skill.id() != skill_2.id() {
            out += &format!(
                "{}' = {} and ",
                skill_var(skillset, skill_2),
                skill_var(skillset, skill_2)
            );
        }
    }
    for resource in skillset.resources() {
        if !(used_resources.contains(&resource.name())) {
            out += &format!(
                "{}' = {} and ",
                resource_var(skillset, resource),
                resource_var(skillset, resource),
            );
        }
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "}\n\n";

    out
}

pub fn runn_to_inte_to_alloy(skillset: &Skillset, skill: &Skill) -> String {
    let mut out = "".to_string();

    out += &format!(
        "pred {}_runn_to_inte {{",
        skill_fact_pred_name(skillset, skill)
    );
    out += &format!(
        "{} = {} and {} = {} and \n",
        skillset_var(skillset),
        skillset_state(skillset, "free"),
        skill_var(skillset, skill),
        skill_state(skillset, "running")
    );
    out += &format!(
        "{}' = {} and ",
        skill_var(skillset, skill),
        skill_state(skillset, "inter")
    );
    out += &format!(
        "{}' = {} and \n",
        skillset_var(skillset),
        skillset_var(skillset)
    );
    for skill_2 in skillset.skills() {
        if skill.id() != skill_2.id() {
            out += &format!(
                "{}' = {} and ",
                skill_var(skillset, skill_2),
                skill_var(skillset, skill_2)
            );
        }
    }
    for resource in skillset.resources() {
        out += &format!(
            "{}' = {} and ",
            resource_var(skillset, resource),
            resource_var(skillset, resource),
        );
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "}\n\n";

    out
}

pub fn runn_to_succ_to_alloy(skillset: &Skillset, skill: &Skill) -> String {
    let mut out = "".to_string();

    for success in skill.successes() {
        out += &format!(
            "pred {}_runn_to_{} {{",
            skill_fact_pred_name(skillset, skill),
            success_pred_name(success)
        );
        out += &format!(
            "{} = {} and {} = {} and \n",
            skillset_var(skillset),
            skillset_state(skillset, "free"),
            skill_var(skillset, skill),
            skill_state(skillset, "running")
        );
        let mut used_resources = Vec::new();
        for effect in success.effects() {
            let resource = skillset.get(effect.resource().resolved()).unwrap();
            let state = skillset.get(effect.state().resolved()).unwrap();
            out += &format!(
                "{}' = {} and ",
                resource_var(skillset, resource),
                resource_state(skillset, state)
            );
            used_resources.push(resource.name());
        }
        out += &format!(
            "{}' = {} and ",
            skill_var(skillset, skill),
            skill_state(skillset, "idle")
        );
        out += &format!(
            "{}' = {} and \n",
            skillset_var(skillset),
            skillset_state(skillset, "lock")
        );
        for skill_2 in skillset.skills() {
            if skill.id() != skill_2.id() {
                out += &format!(
                    "{}' = {} and ",
                    skill_var(skillset, skill_2),
                    skill_var(skillset, skill_2)
                );
            }
        }
        for resource in skillset.resources() {
            if !(used_resources.contains(&resource.name())) {
                out += &format!(
                    "{}' = {} and ",
                    resource_var(skillset, resource),
                    resource_var(skillset, resource),
                );
            }
        }
        out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
        out += "}\n\n";
    }

    out
}

pub fn runn_to_fail_to_alloy(skillset: &Skillset, skill: &Skill) -> String {
    let mut out = "".to_string();

    for fail in skill.failures() {
        out += &format!(
            "pred {}_runn_to_{} {{",
            skill_fact_pred_name(skillset, skill),
            failure_pred_name(fail)
        );
        out += &format!(
            "{} = {} and {} = {} and \n",
            skillset_var(skillset),
            skillset_state(skillset, "free"),
            skill_var(skillset, skill),
            skill_state(skillset, "running")
        );
        let mut used_resources = Vec::new();
        for effect in fail.effects() {
            let resource = skillset.get(effect.resource().resolved()).unwrap();
            let state = skillset.get(effect.state().resolved()).unwrap();
            out += &format!(
                "{}' = {} and ",
                resource_var(skillset, resource),
                resource_state(skillset, state)
            );
            used_resources.push(resource.name());
        }
        out += &format!(
            "{}' = {} and ",
            skill_var(skillset, skill),
            skill_state(skillset, "idle")
        );
        out += &format!(
            "{}' = {} and \n",
            skillset_var(skillset),
            skillset_state(skillset, "lock")
        );
        for skill_2 in skillset.skills() {
            if skill.id() != skill_2.id() {
                out += &format!(
                    "{}' = {} and ",
                    skill_var(skillset, skill_2),
                    skill_var(skillset, skill_2)
                );
            }
        }
        for resource in skillset.resources() {
            if !(used_resources.contains(&resource.name())) {
                out += &format!(
                    "{}' = {} and ",
                    resource_var(skillset, resource),
                    resource_var(skillset, resource),
                );
            }
        }
        out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
        out += "}\n\n";
    }

    out
}

pub fn inte_to_idle_to_alloy(skillset: &Skillset, skill: &Skill) -> String {
    let mut out = "".to_string();

    out += &format!(
        "pred {}_inte_to_idle {{",
        skill_fact_pred_name(skillset, skill)
    );
    out += &format!(
        "{} = {} and {} = {} and \n",
        skillset_var(skillset),
        skillset_state(skillset, "free"),
        skill_var(skillset, skill),
        skill_state(skillset, "inter")
    );

    let mut used_resources = Vec::new();
    let res = skill.interrupt();
    match res {
        Option::Some(interruption) => {
            for effect in interruption.effects() {
                let resource = skillset.get(effect.resource().resolved()).unwrap();
                let state = skillset.get(effect.state().resolved()).unwrap();
                out += &format!(
                    "{}' = {} and ",
                    resource_var(skillset, resource),
                    resource_state(skillset, state)
                );
                used_resources.push(resource.name());
            }
        }
        Option::None => (),
    }

    out += &format!(
        "{}' = {} and ",
        skill_var(skillset, skill),
        skill_state(skillset, "idle")
    );
    out += &format!(
        "{}' = {} and \n",
        skillset_var(skillset),
        skillset_state(skillset, "lock")
    );
    for skill_2 in skillset.skills() {
        if skill.id() != skill_2.id() {
            out += &format!(
                "{}' = {} and ",
                skill_var(skillset, skill_2),
                skill_var(skillset, skill_2)
            );
        }
    }
    for resource in skillset.resources() {
        if !(used_resources.contains(&resource.name())) {
            out += &format!(
                "{}' = {} and ",
                resource_var(skillset, resource),
                resource_var(skillset, resource),
            );
        }
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "}\n\n";

    out
}
