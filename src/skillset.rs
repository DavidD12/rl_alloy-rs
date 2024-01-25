use super::*;
pub use expression_converter::*;
pub use naming::*;

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

    out
}

pub fn skillset_content_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Skillset ====================\n";

    // Enum
    out += &format!("\nenum {} {{", skillset_enum(skillset));
    out += "Free, Lock}\n";

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
    out += &format!("{} = Free", skillset_var(skillset));
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
                "{} = Lock and {} = Running and ",
                skillset_var(skillset),
                skill_var(skillset, skill)
            );
            for ind_2 in 0..ind {
                out += &format!(
                    "{} and ",
                    get_alloy_formula(skillset, invariants[ind_2].guard())
                );
            }
            out += &format!(
                "!{} and ",
                get_alloy_formula(skillset, invariants[ind].guard())
            );
            for effect in invariants[ind].effects() {
                let resource = skillset.get_resource(effect.resource().resolved());
                out += &format!(
                    "{}' = {} and ",
                    resource.expect("Some").name(),
                    resource
                        .expect("Some")
                        .get_state(effect.state().resolved())
                        .expect("Some")
                        .name()
                );
            }
            out += &format!("{}' = Idle and ", skill_var(skillset, skill));
            for skill_2 in skillset.skills() {
                if skill.id() != skill_2.id() {
                    out += &format!(
                        "{}' = {} and ",
                        skill_var(skillset, skill_2),
                        skill_var(skillset, skill_2)
                    );
                }
            }

            out += "}\n";
        }
    }

    out
}
