use super::*;
use heck::{ToSnakeCase, ToUpperCamelCase};


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




pub fn skillset_enum(skillset: &Skillset) -> String {
    format!(
        "{}_states",
        skillset.name().to_upper_camel_case()
    )
}

pub fn skillset_var(skillset: &Skillset) -> String {
    format!(
        "{}_state",
        skillset.name().to_snake_case()
    )
}


pub fn skillset_content_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "// ==================== Skillset ====================\n";

    // Enum
    out += &format!("\nenum {} {{", skillset_enum(skillset));
    out += "Free, Lock }\n";
    
    // Var
    out += &format!(
        "var one sig {} in {} {{",
        skillset_var(skillset),
        skillset_enum(skillset)
    );
    out += "}\n";

    // Init
    out += &format!(
        "\nfact {}_initial_state {{\n",
        skillset.name().to_upper_camel_case()
    );
    out += &format!(
        "{} = {{Free}}",
        skillset_var(skillset)
    );
    out += "\n}\n";
    
    // // Trans
    // for skill in skillset.skills() {
    //     for inv: &Invariant in skill.invariants() {
    //         // TODO
    //     }
    // }

    out
}
