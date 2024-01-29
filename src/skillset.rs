use super::*;
use expression_converter::*;
use naming::*;

pub fn skillsets_to_alloy(model: &Model) -> String {
    let mut out = "".to_string();

    for skillset in model.skillsets() {
        out += &skillset_to_alloy(skillset);
    }

    out
}

pub fn skillset_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += &resources_to_alloy(skillset);
    out += &validates_to_alloy(skillset);
    out += &skillset_content_to_alloy(skillset);
    out += &events_to_alloy(skillset);
    out += &skills_to_alloy(skillset);
    out += &running_constraint_to_alloy(skillset);
    out += &fairness_hypotheses_to_alloy(skillset);

    out
}

pub fn skillset_content_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Skillset ====================\n";

    // Enum
    out += &format!("\nenum {} {{", skillset_enum(skillset));
    out += &format!(
        "{}, {}}}\n",
        skillset_state(skillset, "free"),
        skillset_state(skillset, "lock")
    );

    // Var
    out += &format!(
        "var one sig {} in {} {{",
        skillset_var(skillset),
        skillset_enum(skillset)
    );
    out += "}\n";

    // Init
    out += &format!(
        "\nfact {}_initial_state {{",
        skillset_fact_pred_name(skillset)
    );
    out += &format!(
        "{} = {}",
        skillset_var(skillset),
        skillset_state(skillset, "free")
    );
    out += "}\n\n";

    // Trans
    for skill in skillset.skills() {
        let invariants = skill.invariants();
        for ind in 0..invariants.len() {
            let invariant = &invariants[ind];
            out += &format!(
                "pred Check_{}_{} {{",
                skill_fact_pred_name(skillset, skill),
                invariant.name()
            );
            out += &format!(
                "{} = {} and {} = {} and ",
                skillset_var(skillset),
                skillset_state(skillset, "lock"),
                skill_var(skillset, skill),
                skill_state(skillset, "running")
            );
            for ind_2 in 0..ind {
                out += &format!(
                    "({}) and ",
                    get_alloy_formula(skillset, invariants[ind_2].guard())
                );
            }
            out += &format!(
                "!({}) and ",
                get_alloy_formula(skillset, invariants[ind].guard())
            );
            let mut used_resources = Vec::new();
            for effect in invariants[ind].effects() {
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
            for skill_2 in skillset.skills() {
                if skill.id() != skill_2.id() {
                    out += &format!(
                        "{}' = {} and ",
                        skill_var(skillset, skill_2),
                        skill_var(skillset, skill_2)
                    );
                }
            }
            out += &format!(
                "{}' = {} and ",
                skillset_var(skillset),
                skillset_var(skillset)
            );
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
            out += "}\n";
        }
    }
    for skill in skillset.skills() {
        out += &format!(
            "pred {}_inva_false_while_run {{",
            skill_fact_pred_name(skillset, skill),
        );
        out += &format!(
            "{} = {} and (",
            skill_var(skillset, skill),
            skill_state(skillset, "running")
        );
        for inv in skill.invariants() {
            out += &format!("!({}) or ", get_alloy_formula(skillset, inv.guard()));
        }
        out.truncate(out.len() - " or ".len()); // To remove the last "or" statement
        out += ")}\n";
    }
    out += &format!(
        "\nfact {}_inva_check_order {{always(",
        skillset_fact_pred_name(skillset)
    );
    for skill in skillset.skills() {
        out += &format!(
            "(({} = {} and ",
            skillset_var(skillset),
            skillset_state(skillset, "lock")
        );
        for skill_2 in skillset.skills() {
            if skill.id() == skill_2.id() {
                break;
            } else {
                out += &format!(
                    "!{}_inva_false_while_run and ",
                    skill_fact_pred_name(skillset, skill_2),
                );
            }
        }
        out += &format!(
            "{}_inva_false_while_run and ",
            skill_fact_pred_name(skillset, skill),
        );
        out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
        out += ") implies (";
        for skill_2 in skillset.skills() {
            if skill.id() != skill_2.id() {
                out += &format!(
                    "{}' = {} and ",
                    skill_var(skillset, skill_2),
                    skill_var(skillset, skill_2)
                );
            }
        }
        out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
        out += ")) and ";
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += ")}\n";

    out += &format!("pred {}_lock_to_free {{", skillset_fact_pred_name(skillset));
    out += &format!(
        "{} = {} and ",
        skillset_var(skillset),
        skillset_state(skillset, "lock")
    );
    for skill in skillset.skills() {
        out += &format!(
            "!{}_inva_false_while_run and ",
            skill_fact_pred_name(skillset, skill),
        );
    }
    out += &format!(
        "{}' = {} and ",
        skillset_var(skillset),
        skillset_state(skillset, "free")
    );
    for skill in skillset.skills() {
        out += &format!(
            "{}' = {} and ",
            skill_var(skillset, skill),
            skill_var(skillset, skill)
        );
    }
    for resource in skillset.resources() {
        out += &format!(
            "{}' = {} and ",
            resource_var(skillset, resource),
            resource_var(skillset, resource),
        );
    }
    out.truncate(out.len() - " and ".len()); // To remove the last "and" statement
    out += "}\n";

    out
}
