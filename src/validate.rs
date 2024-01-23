use super::*;
use heck::{ToSnakeCase};


pub fn snake_case_skil_name(skillset: &Skillset, skill: &Skill) -> String {
    format!(
        "{}_{}",
        skillset.name().to_snake_case(),
        skill.name().to_snake_case()
    )
}

pub fn validates_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "// ==================== Validates ====================\n";

    for skill in skillset.skills() {
        out += &format!("\npred {}_validate {{",
        snake_case_skil_name(skillset, skill));
        out += "}\n";
    }

    out
}
