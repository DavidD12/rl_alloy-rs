use super::*;
use heck::{ToSnakeCase, ToUpperCamelCase};


pub fn resource_enum(skillset: &Skillset, resource: &Resource) -> String {
    format!(
        "{}_{}",
        skillset.name().to_upper_camel_case(),
        resource.name().to_upper_camel_case()
    )
}

pub fn resource_state(skillset: &Skillset, state: &State) -> String {
    format!(
        "{}_{}",
        skillset.name().to_upper_camel_case(),
        state.name().to_upper_camel_case()
    )
}

pub fn resource_var(skillset: &Skillset, resource: &Resource) -> String {
    format!(
        "{}_{}",
        skillset.name().to_snake_case(),
        resource.name().to_snake_case()
    )
}

pub fn resources_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "// ==================== Resouces ====================\n";
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
        "\nfact {}_initial_state {{\n",
        resource_enum(skillset, resource)
        );
        out += &format!(
            "{} = {}",
            resource_var(skillset, resource),
            resource_state(skillset, resource.states().first().unwrap())
        );
        out += "\n}\n";
    }

    out
}
