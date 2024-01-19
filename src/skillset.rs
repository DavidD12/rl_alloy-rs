use super::*;

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

    out
}
