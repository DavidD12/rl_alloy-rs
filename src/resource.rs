use super::*;
use naming::*;

pub fn resources_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Resouces ====================\n";
    for resource in skillset.resources() {
        // Enum
        out += &format!("\nenum {} {{", resource_enum(skillset, resource));
        if let Some((first, others)) = resource.states().split_first() {
            out += &resource_state(skillset, first);
            for state in others {
                out += &format!(", {}", resource_state(skillset, state));
            }
        }
        out += "}\n";

        // Var
        out += &format!(
            "var one sig {} in {} {{",
            resource_var(skillset, resource),
            resource_enum(skillset, resource)
        );
        out += "}\n";

        // Init
        out += &format!(
            "\nfact {}_initial_state {{",
            resource_enum(skillset, resource)
        );
        out += &format!(
            "{} = {}",
            resource_var(skillset, resource),
            resource_state(skillset, resource.initial()) // states().first().unwrap()
        );
        out += "}\n";
    }

    out
}
