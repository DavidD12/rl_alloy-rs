use super::*;
use naming::*;

pub fn validates_to_alloy(skillset: &Skillset) -> String {
    let mut out = "".to_string();

    out += "\n// ==================== Validates ====================\n";

    for skill in skillset.skills() {
        out += &format!(
            "\npred {}_validate {{",
            skill_fact_pred_name(skillset, skill)
        );
        out += "}\n";
    }

    out
}
