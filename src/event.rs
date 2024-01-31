use super::*;
use naming::*;

pub fn events_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Events ====================\n\n";

    for event in skillset.events() {
        out += &format!("pred {} {{", event_fact_pred_name(skillset, event));
        out += &format!(
            "{} = {} and ",
            skillset_var(skillset),
            skillset_state(skillset, "free")
        );
        let mut used_resources = Vec::new();
        for effect in event.effects() {
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
            skillset_var(skillset),
            skillset_state(skillset, "lock")
        );
        for skill in skillset.skills() {
            out += &format!(
                "{}' = {} and ",
                skill_var(skillset, skill),
                skill_var(skillset, skill)
            );
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
        out += "}\n";
    }

    out
}
