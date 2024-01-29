use super::*;
use heck::{ToSnakeCase, ToUpperCamelCase};

// Skillset

pub fn skillset_enum(skillset: &Skillset) -> String {
    format!("{}_states", skillset.name().to_upper_camel_case())
}

pub fn skillset_state(skillset: &Skillset, state_name: &str) -> String {
    format!("{}_{}", skillset.name().to_upper_camel_case(), state_name)
}

pub fn skillset_var(skillset: &Skillset) -> String {
    format!("{}_state", skillset.name().to_snake_case())
}

pub fn skillset_fact_pred_name(skillset: &Skillset) -> String {
    skillset.name().to_snake_case()
}

pub fn success_pred_name(success: &Success) -> String {
    format!("success_{}", success.name().to_snake_case())
}

pub fn failure_pred_name(failure: &Failure) -> String {
    format!("failure_{}", failure.name().to_snake_case())
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

pub fn skill_enum(skillset: &Skillset) -> String {
    format!("{}_skill_states", skillset.name().to_upper_camel_case())
}

pub fn skill_state(skillset: &Skillset, state_name: &str) -> String {
    format!("{}_{}", skillset.name().to_upper_camel_case(), state_name)
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

// Event

pub fn event_fact_pred_name(skillset: &Skillset, event: &Event) -> String {
    format!(
        "{}_{}",
        skillset.name().to_snake_case(),
        event.name().to_snake_case()
    )
}
