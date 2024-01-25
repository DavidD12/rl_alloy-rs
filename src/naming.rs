use heck::{ToSnakeCase, ToUpperCamelCase};
use super::*;



// Skillset

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

pub fn skillset_fact_pred_name(skillset: &Skillset) -> String {
    skillset.name().to_snake_case()
}


// Skill

pub fn skill_fact_pred_name(skillset: &Skillset, skill: &Skill) -> String {
    format!(
        "{}_{}",
        skillset.name().to_snake_case(),
        skill.name().to_snake_case()
    )
}

pub fn skill_var(skillset: &Skillset, skill: &Skill) -> String {
    format!(
        "{}_{}_state",
        skillset.name().to_snake_case(),
        skill.name().to_snake_case()
    )
}


// Resource

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